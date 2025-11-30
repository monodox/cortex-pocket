import 'dart:async';

class LlamaBridge {
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<bool> loadModel(String modelPath) async {
    // Web platform doesn't support FFI/native models
    _isLoaded = false;
    return false;
  }

  Stream<String> generateTokens(String prompt) async* {
    // Web platform fallback - should use remote API instead
    yield 'Web platform detected. Local models not supported.\nPlease configure Remote API in Settings.';
  }

  void dispose() {
    _isLoaded = false;
  }
}