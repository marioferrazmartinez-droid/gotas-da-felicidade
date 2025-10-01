import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _geminiApiKey = 'SUA_API_KEY_AQUI';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<String> getMotivationalMessage() async {
    try {
      final prompt = """
        Gere uma mensagem motivacional curta e inspiradora para começar o dia com energia positiva.
        Seja criativo, use metáforas sobre felicidade, gotas, luz ou natureza.
        Máximo 2 parágrafos.
      """;

      final response = await http.post(
        Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return _getFallbackMessage();
      }
    } catch (e) {
      return _getFallbackMessage();
    }
  }

  static String _getFallbackMessage() {
    final messages = [
      "Cada novo dia é uma oportunidade para ser feliz. Aproveite cada momento!",
      "A felicidade está nas pequenas coisas. Encontre alegria no simples hoje!",
      "Como uma gota que forma o oceano, cada sorriso constrói um dia melhor.",
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }
}