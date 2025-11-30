import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyStore {
  static const _storage = FlutterSecureStorage();
  static const _keyApiKey = 'api_key';

  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyApiKey, value: apiKey);
  }

  static Future<String?> getApiKey() async {
    return await _storage.read(key: _keyApiKey);
  }

  static Future<void> clearApiKey() async {
    await _storage.delete(key: _keyApiKey);
  }

  static Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }
}