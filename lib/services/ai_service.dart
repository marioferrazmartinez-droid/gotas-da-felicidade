import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = ''; // Adicione sua API key aqui
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> generateMotivationalMessage({
    String category = 'motivação',
    int maxLength = 150,
  }) async {
    if (_apiKey.isEmpty) {
      return _getFallbackMessage(category);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': 'Gere uma citação motivacional em português sobre $category. Seja inspirador e use no máximo $maxLength caracteres. Formato: "Texto" - Autor',
            }
          ],
          'max_tokens': maxLength,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return _getFallbackMessage(category);
      }
    } catch (e) {
      return _getFallbackMessage(category);
    }
  }

  String _getFallbackMessage(String category) {
    final messages = {
      'motivação': '"A persistência é o caminho do êxito" - Charles Chaplin',
      'felicidade': '"A felicidade não é algo pronto. Ela vem de suas próprias ações" - Dalai Lama',
      'sucesso': '"O sucesso nasce do querer, da determinação e persistência" - Desconhecido',
      'persistência': '"Não importa o quão devagar você vá, desde que você não pare" - Confúcio',
    };
    return messages[category] ?? messages['motivação']!;
  }
}