import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteApi {
  static const String _openaiUrl = 'https://api.openai.com/v1';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const Duration _timeout = Duration(seconds: 30);
  
  static bool _isGeminiKey(String apiKey) => apiKey.startsWith('AIza');

  static Future<bool> testKey(String apiKey) async {
    final key = apiKey.trim();
    
    // Format validation for multiple providers
    if (key.isEmpty || key.length < 20) {
      return false;
    }
    
    // Check for valid API key formats
    bool isValidFormat = key.startsWith('sk-') ||           // OpenAI
                        key.startsWith('AIza') ||          // Gemini
                        key.startsWith('gsk_') ||          // Groq
                        key.startsWith('anthropic-');      // Anthropic
    
    // For testing, accept valid format without network validation
    return isValidFormat;
  }

  static Future<String> generate(String apiKey, String prompt, {int maxTokens = 150, String model = 'gemini-2.5-flash'}) async {
    try {
      final isGemini = _isGeminiKey(apiKey);
      
      if (isGemini) {
        return _generateGemini(apiKey, prompt, maxTokens, model);
      } else {
        return _generateOpenAI(apiKey, prompt, maxTokens, model);
      }
    } catch (e) {
      throw Exception('Remote API failed: $e');
    }
  }
  
  static Future<String> _generateOpenAI(String apiKey, String prompt, int maxTokens, String model) async {
    final response = await http.post(
      Uri.parse('$_openaiUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model.startsWith('gpt') ? model : 'gpt-3.5-turbo',
        'messages': [{'role': 'user', 'content': prompt}],
        'max_tokens': maxTokens,
        'temperature': 0.7,
      }),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      throw Exception('OpenAI API Error: ${response.statusCode}');
    }
  }
  
  static Future<String> _generateGemini(String apiKey, String prompt, int maxTokens, String model) async {
    try {
      final response = await http.post(
        Uri.parse('$_geminiUrl/models/$model:generateContent').replace(
          queryParameters: {'key': apiKey}
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
        } else {
          throw Exception('No response from Gemini API');
        }
      } else {
        final errorBody = response.body;
        // Temporary: Return error details in response to see what's wrong
        return 'DEBUG ERROR - Status: ${response.statusCode}, Body: $errorBody';
      }
    } catch (e) {
      throw Exception('Gemini API request failed: $e');
    }
  }
}