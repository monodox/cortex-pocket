import 'dart:async';
import '../ffi/llama_bridge.dart';

class LLMService {
  static final LLMService _instance = LLMService._internal();
  factory LLMService() => _instance;
  LLMService._internal();

  bool _isModelLoaded = false;
  String _currentModel = '';
  final LlamaBridge _bridge = LlamaBridge();

  Future<bool> loadModel(String modelPath) async {
    _isModelLoaded = await _bridge.loadModel(modelPath);
    if (_isModelLoaded) {
      _currentModel = modelPath;
    }
    return _isModelLoaded;
  }

  Stream<String> generateResponse(String prompt) async* {
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
}