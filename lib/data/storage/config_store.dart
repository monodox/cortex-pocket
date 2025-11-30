import 'package:shared_preferences/shared_preferences.dart';

class ConfigStore {
  static Future<bool> getUseRemote() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('use_remote') ?? false;
  }

  static Future<void> setUseRemote(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_remote', value);
  }

  static Future<String> getModelPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('model_path') ?? '/storage/models/';
  }

  static Future<void> setModelPath(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('model_path', value);
  }

  static Future<String> getCurrentModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_model') ?? '';
  }

  static Future<String> getQuantization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quantization') ?? 'Q4';
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode') ?? false;
  }

  static Future<String> getSelectedPersona() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_persona') ?? 'Helper';
  }

  static Future<int> getMaxTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('max_tokens') ?? 2048;
  }

  static Future<double> getTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('temperature') ?? 0.7;
  }

  static Future<int> getThreads() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('threads') ?? 4;
  }

  static Future<double> getCacheSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('cache_size') ?? 0.0;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cache_size', 0.0);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}