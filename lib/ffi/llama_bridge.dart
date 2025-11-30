import 'dart:ffi';
import 'dart:async';
import 'package:ffi/ffi.dart';
import 'llama_ffi.dart';
import 'llama_types.dart';

class LlamaBridge {
  Pointer<LlamaModel>? _model;
  Pointer<LlamaContext>? _context;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<bool> loadModel(String modelPath) async {
    try {
      _model = LlamaFFI.loadModel(modelPath);
      if (_model == nullptr) return false;

      final params = calloc<LlamaContextParams>();
      params.ref.seed = -1;
      params.ref.nCtx = 2048;
      params.ref.nBatch = 512;
      params.ref.nThreads = 4;
      params.ref.temperature = 0.7;
      params.ref.topP = 0.9;

      _context = LlamaFFI.newContext(_model!, params.ref);
      malloc.free(params);

      _isLoaded = _context != nullptr;
      return _isLoaded;
    } catch (e) {
      return false;
    }
  }

  Stream<String> generateTokens(String prompt) async* {
    if (!_isLoaded || _context == null) return;

    try {
      final tokens = LlamaFFI.tokenize(_context!, prompt, 512, true);
      if (tokens <= 0) return;

      for (int i = 0; i < 100; i++) {
        final result = LlamaFFI.eval(_context!);
        if (result != 0) break;
        
        await Future.delayed(const Duration(milliseconds: 50));
        yield 'token_$i ';
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }

  void dispose() {
    if (_context != null) {
      LlamaFFI.freeContext(_context!);
      _context = null;
    }
    if (_model != null) {
      LlamaFFI.freeModel(_model!);
      _model = null;
    }
    _isLoaded = false;
  }
}