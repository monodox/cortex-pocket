import 'dart:async';
import 'package:flutter/foundation.dart';
import 'src/io_directory_stub.dart'
  if (dart.library.io) 'src/io_directory.dart';
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
  bool _hasLocalModelsCached = false;

  Future<void> initialize() async {
    _useRemote = await ConfigStore.getUseRemote();
    _apiKey = await ApiKeyStore.getApiKey();
    // Scan for local models once during initialization (best-effort)
    _hasLocalModelsCached = await _scanLocalModels();
    notifyListeners();
  }

  /// Scans common project/app folders for local model files (.gguf etc.).
  /// Returns true if at least one candidate local model file is found.
  Future<bool> _scanLocalModels() async {
    try {
      final files = listModelFilesInDir('assets/models');
      return files.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Public trigger to (re)scan for local models. Useful before showing errors.
  Future<bool> scanLocalModels() async {
    _hasLocalModelsCached = await _scanLocalModels();
    notifyListeners();
    return _hasLocalModelsCached;
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
          throw Exception('Remote API failed: $e\n\nNo local model available for fallback.\nPlease load a local model or check your API key.');
        }
      }
    } else {
      if (_isModelLoaded) {
        return await _askLocal(prompt);
      } else {
        throw Exception('No AI model available.\n\nPlease either:\n• Load a local model (Models screen)\n• Configure remote API (Settings screen)');
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
          yield '❌ **Remote API Error**\n\n'
                'Error: $e\n\n'
                '**No local model available for fallback.**\n\n'
                '**To fix this:**\n'
                '1. Check your API key in Settings\n'
                '2. Verify internet connection\n'
                '3. Or load a local model for offline use\n\n'
                '**Load Local Model:**\n'
                '• Go to Models → Browse Models\n'
                '• Download Gemma 2B (recommended)\n'
                '• Load for offline backup';
          return;
        }
        // Fall through to local model
      }
    }

    if (!_isModelLoaded) {
      if (!_useRemote || !hasApiKey) {
        yield '🤖 **Welcome to Cortex Pocket!**\n\n'
              'To start chatting, you need either a **local model** or **remote API access**.\n\n'
              '**Option 1: Local AI (Private & Offline)**\n'
              '1. Tap **Models** in bottom navigation\n'
              '2. Tap **Browse Models** (📥 icon)\n'
              '3. Choose a model for your device:\n'
              '   • **2-4GB RAM**: Gemma 2 2B (Q4)\n'
              '   • **4-6GB RAM**: Phi-3.5 Mini (Q4)\n'
              '   • **6GB+ RAM**: Llama 3.2 3B (Q4)\n'
              '4. Download .gguf file from HuggingFace\n'
              '5. Place in assets/models/ directory\n'
              '6. Return and tap **Load Model**\n\n'
              '**Option 2: Remote API (Requires Internet)**\n'
              '1. Tap **Settings** in bottom navigation\n'
              '2. Scroll to **Remote API** section\n'
              '3. Enter your API key:\n'
              '   • **OpenAI**: sk-...\n'
              '   • **Google Gemini**: AIza...\n'
              '4. Tap **Save & Test**\n'
              '5. Enable **Use Remote API** toggle\n'
              '6. Use the ☁️/⚡ toggle in chat to switch modes\n\n'
              '**Need help?** Check the **About** screen for more details!';
      } else {
        yield '🤖 **No Local Model Available**\n\n'
              'You\'re in **Remote API mode** but no local model is loaded for fallback.\n\n'
              '**To add a local model:**\n'
              '1. Go to **Models** screen\n'
              '2. Tap **Browse Models** (📥 icon)\n'
              '3. Download a model (Gemma 2B recommended)\n'
              '4. Load the model for offline backup\n\n'
              '**Current mode**: Remote API ($_selectedModel)\n'
              '**Fallback**: None (local model recommended)';
      }
      return;
    }

    String fullResponse = '';
    await for (final token in _bridge.generateTokens(prompt)) {
      fullResponse += token;
      yield fullResponse;
    }
  }

  bool get isModelLoaded => _isModelLoaded;
  bool get hasLocalModels => _hasLocalModelsCached;
  String get currentModel => _currentModel;
  bool get useRemote => _useRemote;
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;
  String get mode {
    if (_useRemote && hasApiKey) {
      return 'Remote ($_selectedModel)';
    } else if (_isModelLoaded) {
      return 'Local ($_currentModel)';
    } else {
      return 'No Model';
    }
  }
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