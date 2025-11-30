import 'dart:async';
import 'package:flutter/foundation.dart';
import '../ffi/llama_bridge.dart';
import '../data/storage/api_key_store.dart';
import '../data/storage/config_store.dart';
import 'remote_api.dart';

class LLMService extends ChangeNotifier {
  static final LLMService _instance = LLMService._internal();
  factory LLMService() => _instance;
  LLMService._internal();

  bool _isModelLoaded = false;
  String _currentModel = '';
  bool _useRemote = false;
  String? _apiKey;
  final LlamaBridge _bridge = LlamaBridge();

  Future<void> initialize() async {
    final configStore = ConfigStore();
    await configStore.initialize();
    _useRemote = configStore.useRemote;
    _apiKey = await ApiKeyStore.getApiKey();
    notifyListeners();
  }

  Future<bool> loadModel(String modelPath) async {
    _isModelLoaded = await _bridge.loadModel(modelPath);
    if (_isModelLoaded) {
      _currentModel = modelPath;
    }
    notifyListeners();
    return _isModelLoaded;
  }

  Future<void> setUseRemote(bool useRemote) async {
    _useRemote = useRemote;
    final configStore = ConfigStore();
    configStore.useRemote = useRemote;
    notifyListeners();
  }

  Future<void> saveApiKey(String apiKey) async {
    _apiKey = apiKey;
    await ApiKeyStore.saveApiKey(apiKey);
    notifyListeners();
  }

  Future<void> clearApiKey() async {
    _apiKey = null;
    _useRemote = false;
    await ApiKeyStore.clearApiKey();
    final configStore = ConfigStore();
    configStore.useRemote = false;
    notifyListeners();
  }

  Future<bool> testApiKey(String apiKey) async {
    return await RemoteApi.testKey(apiKey);
  }

  Future<String> ask(String prompt) async {
    if (_useRemote && _apiKey != null && _apiKey!.isNotEmpty) {
      try {
        return await RemoteApi.generate(_apiKey!, prompt);
      } catch (e) {
        if (_isModelLoaded) {
          return await _askLocal(prompt);
        } else {
          throw Exception('Remote failed and no local model available');
        }
      }
    } else {
      if (_isModelLoaded) {
        return await _askLocal(prompt);
      } else {
        throw Exception('No model available');
      }
    }
  }

  Future<String> _askLocal(String prompt) async {
    String fullResponse = '';
    await for (final token in _bridge.generateTokens(prompt)) {
      fullResponse += token;
    }
    return fullResponse;
  }

  Stream<String> generateResponse(String prompt) async* {
    if (_useRemote && _apiKey != null && _apiKey!.isNotEmpty) {
      try {
        final response = await RemoteApi.generate(_apiKey!, prompt);
        yield response;
        return;
      } catch (e) {
        if (!_isModelLoaded) {
          yield 'Error: Remote failed and no local model loaded';
          return;
        }
      }
    }

    if (!_isModelLoaded) {
      yield 'Error: Model not loaded';
      return;
    }

    String fullResponse = '';
    await for (final token in _bridge.generateTokens(prompt)) {
      fullResponse += token;
      yield fullResponse;
    }
  }

  bool get isModelLoaded => _isModelLoaded;
  String get currentModel => _currentModel;
  bool get useRemote => _useRemote;
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;
  String get mode => _useRemote && hasApiKey ? 'Remote' : 'On-device';
}