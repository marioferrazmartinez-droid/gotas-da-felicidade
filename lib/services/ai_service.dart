// lib/services/ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/environment.dart';

/// Serviço para integração com API de IA Gemini
class AIService {
  static final List<String> _fallbackMessages = [
    "Cada novo dia é uma oportunidade para ser feliz. Aproveite cada momento!",
    "A felicidade está nas pequenas coisas. Encontre alegria no simples hoje!",
    "Como uma gota que forma o oceano, cada sorriso constrói um dia melhor.",
    "A vida é feita de escolhas. Escolha ser feliz hoje!",
    "O sol sempre nasce após a noite. Mantenha a esperança!",
    "Seja como uma flor que busca a luz mesmo na sombra.",
  ];

  /// Obtém uma mensagem motivacional da API Gemini
  /// Retorna uma mensagem de fallback em caso de erro
  static Future<String> getMotivationalMessage({String? userMood}) async {
    try {
      EnvironmentValidator.validate();

      final prompt = _buildPrompt(userMood);
      final response = await _makeApiRequest(prompt);

      return _parseApiResponse(response);
    } catch (e) {
      if (e is EnvironmentException) {
        debugPrint('Configuração de ambiente faltante: $e');
      } else {
        debugPrint('Erro na API Gemini: $e');
      }
      return _getFallbackMessage();
    }
  }

  /// Constrói o prompt para a API
  static String _buildPrompt(String? userMood) {
    final moodContext = userMood != null ?
    'O usuário está se sentindo: $userMood. ' : '';

    return """
      Gere uma mensagem motivacional curta e inspiradora em português do Brasil.
      $moodContext
      Seja criativo, use metáforas sobre felicidade, gotas, luz, natureza ou superação.
      A mensagem deve ser positiva, energizante e fácil de entender.
      Máximo de 2 parágrafos curtos.
      Não inclua marcadores ou formatação.
    """;
  }

  /// Faz a requisição para a API Gemini
  static Future<http.Response> _makeApiRequest(String prompt) async {
    return await http.post(
      Uri.parse('${Environment.geminiBaseUrl}?key=${Environment.geminiApiKey}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        }
      }),
    ).timeout(const Duration(seconds: 30));
  }

  /// Processa a resposta da API
  static String _parseApiResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;

      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;

        if (parts != null && parts.isNotEmpty) {
          final text = parts[0]['text'] as String?;
          if (text != null && text.trim().isNotEmpty) {
            return text.trim();
          }
        }
      }

      throw Exception('Resposta da API vazia ou inválida');
    } else {
      throw HttpException(
          'Falha na API: ${response.statusCode} - ${response.reasonPhrase}',
          uri: Uri.parse(Environment.geminiBaseUrl)
      );
    }
  }

  /// Mensagem de fallback em caso de erro
  static String _getFallbackMessage() {
    final index = DateTime.now().millisecondsSinceEpoch % _fallbackMessages.length;
    return _fallbackMessages[index];
  }

  /// Mensagens de fallback disponíveis (para testes)
  static List<String> get fallbackMessages => List.unmodifiable(_fallbackMessages);
}