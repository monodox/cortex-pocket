import 'package:shared_preferences/shared_preferences.dart';

class ConfigStore {
  static final ConfigStore _instance = ConfigStore._internal();
  factory ConfigStore() => _instance;
  ConfigStore._internal();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Model settings
  String get modelPath => _prefs.getString('model_path') ?? '/storage/models/';
  set modelPath(String value) => _prefs.setString('model_path', value);

  String get currentModel => _prefs.getString('current_model') ?? '';
  set currentModel(String value) => _prefs.setString('current_model', value);

  String get quantization => _prefs.getString('quantization') ?? 'Q4';
  set quantization(String value) => _prefs.setString('quantization', value);

  // UI settings
  bool get darkMode => _prefs.getBool('dark_mode') ?? false;
  set darkMode(bool value) => _prefs.setBool('dark_mode', value);

  String get selectedPersona => _prefs.getString('selected_persona') ?? 'Helper';
  set selectedPersona(String value) => _prefs.setString('selected_persona', value);

  // Performance settings
  int get maxTokens => _prefs.getInt('max_tokens') ?? 2048;
  set maxTokens(int value) => _prefs.setInt('max_tokens', value);

  double get temperature => _prefs.getDouble('temperature') ?? 0.7;
  set temperature(double value) => _prefs.setDouble('temperature', value);

  int get threads => _prefs.getInt('threads') ?? 4;
  set threads(int value) => _prefs.setInt('threads', value);

  // Cache management
  double get cacheSize => _prefs.getDouble('cache_size') ?? 0.0;
  set cacheSize(double value) => _prefs.setDouble('cache_size', value);

  Future<void> clearCache() async {
    cacheSize = 0.0;
  }

  Future<void> reset() async {
    await _prefs.clear();
  }
}