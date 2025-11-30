class AppConstants {
  static const String appName = 'Cortex Pocket';
  static const String appVersion = '1.0.0';
  
  // Model constants
  static const int defaultContextSize = 2048;
  static const int defaultBatchSize = 512;
  static const int defaultThreads = 4;
  static const double defaultTemperature = 0.7;
  static const double defaultTopP = 0.9;
  
  // File extensions
  static const List<String> supportedTextFiles = ['.txt', '.log', '.md', '.json', '.xml'];
  static const List<String> supportedCodeFiles = ['.dart', '.py', '.js', '.java', '.cpp', '.c'];
  
  // Storage paths
  static const String modelsFolder = 'models';
  static const String chatsFolder = 'chats';
  static const String cacheFolder = 'cache';
  
  // Performance thresholds
  static const double minTokensPerSecond = 1.0;
  static const int maxLatencyMs = 5000;
  static const double maxMemoryUsageGB = 8.0;
}

class ModelConstants {
  static const Map<String, double> quantizationSizes = {
    'Q8': 4.2,
    'Q6': 3.1,
    'Q4': 2.1,
    'Q3': 1.6,
  };
  
  static const Map<String, String> modelTypes = {
    'llama': 'Llama',
    'mistral': 'Mistral',
    'codellama': 'CodeLlama',
  };
}