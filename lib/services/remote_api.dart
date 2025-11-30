import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteApi {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const Duration _timeout = Duration(seconds: 30);

  static Future<bool> testKey(String apiKey) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/models'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String> generate(String apiKey, String prompt, {int maxTokens = 150}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': maxTokens,
          'temperature': 0.7,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Remote API failed: $e');
    }
  }
}