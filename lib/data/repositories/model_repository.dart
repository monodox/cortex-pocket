import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ModelInfo {
  final String name;
  final String filename;
  final String size;
  final List<String> quantizations;
  final bool isLoaded;

  const ModelInfo({
    required this.name,
    required this.filename,
    required this.size,
    required this.quantizations,
    this.isLoaded = false,
  });

  ModelInfo copyWith({bool? isLoaded}) {
    return ModelInfo(
      name: name,
      filename: filename,
      size: size,
      quantizations: quantizations,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class ModelRepository {
  static final ModelRepository _instance = ModelRepository._internal();
  factory ModelRepository() => _instance;
  ModelRepository._internal();

  final List<ModelInfo> _availableModels = [
    ModelInfo(
      name: 'Llama-2-7B',
      filename: 'llama-2-7b-chat',
      size: '3.5GB',
      quantizations: ['Q8', 'Q6', 'Q4', 'Q3'],
    ),
    ModelInfo(
      name: 'CodeLlama-7B',
      filename: 'codellama-7b-instruct',
      size: '3.8GB',
      quantizations: ['Q8', 'Q6', 'Q4', 'Q3'],
      isLoaded: true,
    ),
    ModelInfo(
      name: 'Mistral-7B',
      filename: 'mistral-7b-instruct',
      size: '4.1GB',
      quantizations: ['Q8', 'Q6', 'Q4', 'Q3'],
    ),
  ];

  List<ModelInfo> _loadedModels = [];

  List<ModelInfo> getAvailableModels() => List.unmodifiable(_availableModels);
  List<ModelInfo> getLoadedModels() => List.unmodifiable(_loadedModels);

  Future<String> getModelsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${appDir.path}/cortex/models');
    await modelsDir.create(recursive: true);
    return modelsDir.path;
  }

  Future<bool> isModelDownloaded(String filename, String quantization) async {
    final modelsDir = await getModelsDirectory();
    final modelFile = File('$modelsDir/$filename-$quantization.gguf');
    return await modelFile.exists();
  }

  Future<String> getModelPath(String filename, String quantization) async {
    final modelsDir = await getModelsDirectory();
    return '$modelsDir/$filename-$quantization.gguf';
  }

  Future<bool> loadModel(String modelName) async {
    final modelIndex = _availableModels.indexWhere((m) => m.name == modelName);
    if (modelIndex == -1) return false;

    _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(isLoaded: true);
    _loadedModels.add(_availableModels[modelIndex]);
    return true;
  }

  Future<void> unloadModel(String modelName) async {
    final modelIndex = _availableModels.indexWhere((m) => m.name == modelName);
    if (modelIndex != -1) {
      _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(isLoaded: false);
    }
    _loadedModels.removeWhere((m) => m.name == modelName);
  }

  double getModelSize(String quantization) {
    switch (quantization) {
      case 'Q8': return 4.2;
      case 'Q6': return 3.1;
      case 'Q4': return 2.1;
      case 'Q3': return 1.6;
      default: return 2.1;
    }
  }
}