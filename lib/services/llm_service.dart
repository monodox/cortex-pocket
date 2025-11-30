import 'dart:async';
import 'package:flutter/foundation.dart';
import '../ffi/llama_bridge_io.dart' if (dart.library.html) '../ffi/llama_bridge_web.dart';
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
  String _selectedModel = 'gemini-2.5-flash';
  final LlamaBridge _bridge = LlamaBridge();

  Future<void> initialize() async {
    _useRemote = await ConfigStore.getUseRemote();
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
    await ConfigStore.setUseRemote(useRemote);
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
    await ConfigStore.setUseRemote(false);
    notifyListeners();
  }

  Future<bool> testApiKey(String apiKey) async {
    return await RemoteApi.testKey(apiKey);
  }

  void setSelectedModel(String model) {
    _selectedModel = model;
    notifyListeners();
  }

  Future<String> ask(String prompt) async {
    if (_useRemote && _apiKey != null && _apiKey!.isNotEmpty) {
      try {
        return await RemoteApi.generate(_apiKey!, prompt, model: _selectedModel);
      } catch (e) {
        if (_isModelLoaded) {
          return await _askLocal(prompt);
        } else {
          throw Exception('Remote API failed: $e\nNo local model loaded as fallback.');
        }
      }
    } else {
      if (_isModelLoaded) {
        return await _askLocal(prompt);
      } else {
        throw Exception('No model available. Please load a local model or configure remote API.');
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
        final response = await RemoteApi.generate(_apiKey!, prompt, model: _selectedModel);
        yield response;
        return;
      } catch (e) {
        if (!_isModelLoaded) {
          yield 'Remote API Error: $e\n\nNo local model available for fallback.\nPlease check your API key or load a local model.';
          return;
        }
        // Fall through to local model
      }
    }

    if (!_isModelLoaded) {
      yield '🤖 **No Local Model Installed**\n\n'
            '**To use Local Mode:**\n'
            '1. Go to **Models** screen\n'
            '2. Tap **Browse Models** (download icon)\n'
            '3. Choose a model (Gemma 2B recommended for most devices)\n'
            '4. Tap **Download from HuggingFace**\n'
            '5. Place the .gguf file in assets/models/\n'
            '6. Return and load the model\n\n'
            '**Quick Start Models:**\n'
            '• **Gemma 2 2B** - Lightweight, fast\n'
            '• **Llama 3.2 3B** - Balanced performance\n'
            '• **Phi-3.5 Mini** - Efficient for coding\n\n'
            '**Alternative:** Switch to Remote mode with API key';
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
  String get mode => _useRemote && hasApiKey ? 'Remote ($_selectedModel)' : 'On-device';
  String get selectedModel => _selectedModel;
  
  bool get isGeminiKey => _apiKey != null && _apiKey!.startsWith('AIza');
  
  List<Map<String, String>> get availableModels {
    if (isGeminiKey) {
      return [
        {'id': 'gemini-2.5-flash', 'name': 'Gemini 2.5 Flash (Default)'},
        {'id': 'gemini-2.5-pro', 'name': 'Gemini 2.5 Pro'},
        {'id': 'gemini-2.5-flash-lite', 'name': 'Gemini 2.5 Flash Lite'},
        {'id': 'gemini-3-pro-preview', 'name': 'Gemini 3 Pro Preview'},
      ];
    } else {
      return [
        {'id': 'gpt-3.5-turbo', 'name': 'GPT-3.5 Turbo'},
        {'id': 'gpt-4', 'name': 'GPT-4'},
        {'id': 'gpt-4-turbo', 'name': 'GPT-4 Turbo'},
      ];
    }
  }
}