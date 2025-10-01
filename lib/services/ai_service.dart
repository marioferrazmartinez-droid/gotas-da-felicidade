// lib/services/ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/environment.dart';

/// Serviço para integração com API de IA Gemini
/// Fornece mensagens motivacionais personalizadas
class AIService {
  // =============================================
  // CONFIGURAÇÕES E CONSTANTES
  // =============================================

  static const String _serviceName = 'AIService';

  // =============================================
  // MÉTODOS PÚBLICOS
  // =============================================

  /// Obtém uma mensagem motivacional da API Gemini
  /// [userMood]: Humor opcional do usuário para personalizar a mensagem
  /// [retryCount]: Número de tentativas (uso interno)
  /// Retorna uma mensagem motivacional ou fallback em caso de erro
  static Future<String> getMotivationalMessage({
    String? userMood,
    int retryCount = 0,
  }) async {
    try {
      if (Environment.isDebug) {
        debugPrint('[$_serviceName] Solicitando mensagem motivacional...');
      }

      // Validar configuração do ambiente
      EnvironmentValidator.validateGeminiConfig();

      final prompt = _buildPrompt(userMood);
      final response = await _makeApiRequest(prompt);

      final message = _parseApiResponse(response);

      if (Environment.isDebug) {
        debugPrint('[$_serviceName] Mensagem gerada com sucesso');
      }

      return message;
    } catch (e) {
      return _handleError(e, userMood, retryCount);
    }
  }

  /// Obtém uma mensagem motivacional baseada no período do dia
  static Future<String> getTimeBasedMotivation() async {
    final hour = DateTime.now().hour;
    String timeContext;

    if (hour >= 5 && hour < 12) {
      timeContext = 'manhã';
    } else if (hour >= 12 && hour < 18) {
      timeContext = 'tarde';
    } else {
      timeContext = 'noite';
    }

    return getMotivationalMessage(userMood: 'começando a $timeContext');
  }

  /// Obtém uma mensagem de fallback (sem usar API)
  static String getFallbackMessage() {
    return EnvironmentUtils.getFallbackMessage();
  }

  /// Obtém todas as mensagens de fallback disponíveis
  static List<String> getAvailableFallbackMessages() {
    return List.unmodifiable(Environment.fallbackMotivationalMessages);
  }

  // =============================================
  // MÉTODOS PRIVADOS - LÓGICA INTERNA
  // =============================================

  /// Constrói o prompt para a API baseado no humor do usuário
  static String _buildPrompt(String? userMood) {
    final moodContext = userMood != null && userMood.isNotEmpty
        ? 'Contexto do usuário: $userMood. '
        : '';

    final languageInstruction = '''
      IMPORTANTE: Responda sempre em Português do Brasil, independente do idioma do prompt.
      Use linguagem natural, calorosa e acessível.
    ''';

    return '''
      $languageInstruction
      
      Gere uma mensagem motivacional curta e inspiradora para ajudar alguém a ter um dia melhor.
      $moodContext
      
      Diretrizes:
      - Seja positivo, energizante e genuíno
      - Use metáforas relacionadas a felicidade, gotas, luz, natureza, crescimento ou superação
      - Máximo de 2 parágrafos curtos (150-300 caracteres no total)
      - Linguagem simples e direta, como um conselho de amigo
      - Foco em ações práticas e mindset positivo
      - Evite clichês vazios, seja específico e significativo
      
      Estrutura sugerida:
      1. Reconhecimento empático (se houver contexto)
      2. Mensagem motivacional principal
      3. Chamada para ação ou reflexão positiva
      
      Não inclua marcadores, títulos ou formatação especial.
      Apenas o texto da mensagem.
    ''';
  }

  /// Faz a requisição para a API Gemini
  static Future<http.Response> _makeApiRequest(String prompt) async {
    final apiKey = EnvironmentUtils.getValidatedGeminiApiKey();
    final url = '${Environment.geminiBaseUrl}?key=$apiKey';

    if (Environment.isDebug) {
      debugPrint('[$_serviceName] Fazendo requisição para API Gemini...');
    }

    final response = await http.post(
      Uri.parse(url),
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
          'temperature': 0.8,       // Criatividade (0.0-1.0)
          'topK': 40,              // Diversidade lexical
          'topP': 0.95,            // Probabilidade acumulada
          'maxOutputTokens': 1024, // Tamanho máximo da resposta
          'stopSequences': ['---'], // Sequências de parada
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      }),
    ).timeout(
      Duration(seconds: Environment.apiTimeoutSeconds),
      onTimeout: () {
        throw ApiException(
          'Timeout na requisição da API Gemini',
          endpoint: url,
          error: 'Timeout após ${Environment.apiTimeoutSeconds} segundos',
        );
      },
    );

    return response;
  }

  /// Processa e valida a resposta da API
  static String _parseApiResponse(http.Response response) {
    if (Environment.isDebug) {
      debugPrint('[$_serviceName] Processando resposta (status: ${response.statusCode})');
    }

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Verificar se há candidatos na resposta
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw ApiException(
            'Nenhuma resposta gerada pela API',
            endpoint: Environment.geminiBaseUrl,
            error: 'Candidates array vazio ou nulo',
          );
        }

        // Extrair o texto da primeira candidata
        final firstCandidate = candidates.first;
        final content = firstCandidate['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List?;

        if (parts == null || parts.isEmpty) {
          throw ApiException(
            'Resposta da API sem conteúdo',
            endpoint: Environment.geminiBaseUrl,
            error: 'Parts array vazio ou nulo',
          );
        }

        final text = parts.first['text'] as String?;
        if (text == null || text.trim().isEmpty) {
          throw ApiException(
            'Texto da resposta vazio',
            endpoint: Environment.geminiBaseUrl,
            error: 'Text vazio ou nulo',
          );
        }

        // Limpar e validar o texto
        final cleanedText = _cleanGeneratedText(text);

        if (Environment.isDebug) {
          debugPrint('[$_serviceName] Mensagem processada: ${cleanedText.length} caracteres');
        }

        return cleanedText;

      } catch (e) {
        throw ApiException(
          'Erro ao processar resposta da API',
          endpoint: Environment.geminiBaseUrl,
          error: e.toString(),
        );
      }
    } else {
      throw HttpException(
        'Falha na comunicação com a API Gemini',
        uri: Uri.parse(Environment.geminiBaseUrl),
        statusCode: response.statusCode,
      );
    }
  }

  /// Limpa e formata o texto gerado pela API
  static String _cleanGeneratedText(String text) {
    // Remover aspas extras no início/fim se existirem
    var cleaned = text.trim();

    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    if (cleaned.startsWith("'") && cleaned.endsWith("'")) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Remover marcadores comuns
    cleaned = cleaned
        .replaceAll(RegExp(r'^\d+[\.\)]\s*'), '') // 1. 2) etc.
        .replaceAll(RegExp(r'^[-•*]\s*'), '')     // - • * etc.
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // **negrito**
        .replaceAll(RegExp(r'_(.*?)_'), r'$1')       // _itálico_
        .trim();

    // Garantir que termina com pontuação apropriada
    if (!cleaned.endsWith('.') &&
        !cleaned.endsWith('!') &&
        !cleaned.endsWith('?')) {
      cleaned += '.';
    }

    return cleaned;
  }

  /// Trata erros e decide se deve tentar novamente
  static Future<String> _handleError(
      dynamic error,
      String? userMood,
      int retryCount,
      ) async {
    if (Environment.isDebug) {
      debugPrint('[$_serviceName] Erro: $error');
      if (error is ApiException) {
        debugPrint('[$_serviceName] Endpoint: ${error.endpoint}');
      }
    }

    // Tentar novamente se for um erro de rede e não excedeu o limite
    if (_shouldRetry(error) && retryCount < Environment.maxApiRetries) {
      if (Environment.isDebug) {
        debugPrint('[$_serviceName] Tentativa ${retryCount + 1} de ${Environment.maxApiRetries}');
      }

      // Esperar um pouco antes de tentar novamente (backoff exponencial)
      await Future.delayed(Duration(seconds: (retryCount + 1) * 2));

      return getMotivationalMessage(
        userMood: userMood,
        retryCount: retryCount + 1,
      );
    }

    // Se não deve tentar novamente ou excedeu tentativas, usar fallback
    if (Environment.isDebug) {
      debugPrint('[$_serviceName] Usando mensagem de fallback');
    }

    return EnvironmentUtils.getFallbackMessage();
  }

  /// Determina se um erro é recuperável (deve tentar novamente)
  static bool _shouldRetry(dynamic error) {
    return error is HttpException ||
        error is ApiException && error.error.toString().contains('timeout') ||
        error is ApiException && error.error.toString().contains('network');
  }

  // =============================================
  // MÉTODOS DE DIAGNÓSTICO E DEBUG
  // =============================================

  /// Verifica se o serviço está configurado e funcionando
  static Future<bool> checkServiceHealth() async {
    try {
      EnvironmentValidator.validateGeminiConfig();

      // Fazer uma requisição de teste simples
      final testPrompt = 'Responda apenas com "OK" se estiver funcionando.';
      final response = await _makeApiRequest(testPrompt);
      final result = _parseApiResponse(response);

      return result.trim() == 'OK';
    } catch (e) {
      if (Environment.isDebug) {
        debugPrint('[$_serviceName] Health check falhou: $e');
      }
      return false;
    }
  }

  /// Obtém estatísticas de uso do serviço (para analytics)
  static Map<String, dynamic> getServiceStats() {
    return {
      'serviceName': _serviceName,
      'maxRetries': Environment.maxApiRetries,
      'apiTimeout': Environment.apiTimeoutSeconds,
      'fallbackMessagesCount': Environment.fallbackMotivationalMessages.length,
      'environment': Environment.isProduction ? 'production' : 'development',
      'geminiConfigured': Environment.geminiApiKey.isNotEmpty,
    };
  }
}