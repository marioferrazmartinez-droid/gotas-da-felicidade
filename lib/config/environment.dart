// lib/config/environment.dart

/// Configurações de ambiente e variáveis sensíveis
///
/// Para desenvolvimento, execute com:
/// flutter run --dart-define=GEMINI_API_KEY=sua_chave_aqui
///
/// Para produção, configure as variáveis no CI/CD
abstract class Environment {
  // =============================================
  // CONFIGURAÇÕES DE API E SERVIÇOS EXTERNOS
  // =============================================

  /// Chave da API Gemini AI - configure via --dart-define
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '', // Será substituída via --dart-define
  );

  /// URL base da API Gemini
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// Modelo Gemini a ser utilizado
  static const String geminiModel = 'gemini-pro';

  // =============================================
  // CONFIGURAÇÕES DO APP
  // =============================================

  /// Nome do aplicativo
  static const String appName = 'Gotas da Felicidade';

  /// Versão do aplicativo
  static const String appVersion = '1.0.0';

  /// Ambiente atual (desenvolvimento/produção)
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// Modo debug
  static const bool isDebug = !isProduction;

  // =============================================
  // CONFIGURAÇÕES DE FIREBASE
  // =============================================

  /// Projeto ID do Firebase
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'gotas-da-felicidade',
  );

  // =============================================
  // CONFIGURAÇÕES DE NOTIFICAÇÕES
  // =============================================

  /// Hora padrão para notificações diárias (formato 24h)
  static const int defaultNotificationHour = 9; // 9:00 AM

  /// Minuto padrão para notificações diárias
  static const int defaultNotificationMinute = 0;

  /// Título padrão para notificações
  static const String defaultNotificationTitle = 'Sua dose diária de felicidade!';

  // =============================================
  // CONFIGURAÇÕES DE INTERNACIONALIZAÇÃO
  // =============================================

  /// Idioma padrão do aplicativo
  static const String defaultLanguage = 'pt';

  /// Idiomas suportados
  static const List<String> supportedLanguages = [
    'pt', // Português
    'en', // Inglês
    'es', // Espanhol
    'fr', // Francês
    'zh', // Chinês
    'ja', // Japonês
    'ar', // Árabe
  ];

  // =============================================
  // CONFIGURAÇÕES DE UI/UX
  // =============================================

  /// Tempo de duração das animações (em milissegundos)
  static const int animationDuration = 300;

  /// Tempo de delay para carregamentos (em milissegundos)
  static const int loadingDelay = 1000;

  /// Número máximo de tentativas de API
  static const int maxApiRetries = 3;

  /// Timeout para requisições de API (em segundos)
  static const int apiTimeoutSeconds = 30;

  // =============================================
  // MENSAGENS E TEXTO
  // =============================================

  /// Mensagens de fallback para quando a API não está disponível
  static const List<String> fallbackMotivationalMessages = [
    "Cada novo dia é uma oportunidade para ser feliz. Aproveite cada momento!",
    "A felicidade está nas pequenas coisas. Encontre alegria no simples hoje!",
    "Como uma gota que forma o oceano, cada sorriso constrói um dia melhor.",
    "A vida é feita de escolhas. Escolha ser feliz hoje!",
    "O sol sempre nasce após a noite. Mantenha a esperança!",
    "Seja como uma flor que busca a luz mesmo na sombra.",
    "Grandes jornadas começam com pequenos passos. Continue caminhando!",
    "Você é mais forte do que imagina. Acredite no seu potencial!",
    "A gratidão transforma o que temos em suficiente. Seja grato hoje!",
    "Cada desafio é uma oportunidade de crescimento. Você consegue!",
  ];
}

// =============================================
// EXCEÇÕES E VALIDAÇÕES
// =============================================

/// Exceção para configurações de ambiente faltantes
class EnvironmentException implements Exception {
  final String message;
  final String? missingVariable;

  const EnvironmentException(this.message, {this.missingVariable});

  @override
  String toString() => missingVariable == null
      ? 'EnvironmentException: $message'
      : 'EnvironmentException: $message (Variável: $missingVariable)';
}

/// Exceção para erros de HTTP
class HttpException implements Exception {
  final String message;
  final Uri? uri;
  final int? statusCode;

  const HttpException(this.message, {this.uri, this.statusCode});

  @override
  String toString() {
    final base = 'HttpException: $message';
    if (uri != null && statusCode != null) {
      return '$base (Status: $statusCode, URI: $uri)';
    } else if (uri != null) {
      return '$base (URI: $uri)';
    } else if (statusCode != null) {
      return '$base (Status: $statusCode)';
    }
    return base;
  }
}

/// Exceção para erros de API
class ApiException implements Exception {
  final String message;
  final String endpoint;
  final dynamic error;

  const ApiException(this.message, {required this.endpoint, this.error});

  @override
  String toString() => 'ApiException: $message (Endpoint: $endpoint)';
}

// =============================================
// VALIDADOR DE AMBIENTE
// =============================================

/// Validador para configurações de ambiente
class EnvironmentValidator {
  /// Valida todas as configurações necessárias
  static void validateAll() {
    validateGeminiConfig();
    validateFirebaseConfig();
  }

  /// Valida configurações da Gemini AI (AGORA PÚBLICO)
  static void validateGeminiConfig() {
    if (Environment.geminiApiKey.isEmpty) {
      throw EnvironmentException(
        'Chave da API Gemini não configurada. '
            'Execute o app com: '
            'flutter run --dart-define=GEMINI_API_KEY=sua_chave_aqui',
        missingVariable: 'GEMINI_API_KEY',
      );
    }

    if (Environment.geminiApiKey.length < 10) {
      throw EnvironmentException(
        'Chave da API Gemini parece inválida.',
        missingVariable: 'GEMINI_API_KEY',
      );
    }
  }

  /// Valida configurações do Firebase (AGORA PÚBLICO)
  static void validateFirebaseConfig() {
    // Verificações básicas do Firebase
    if (Environment.firebaseProjectId.isEmpty) {
      throw EnvironmentException(
        'Project ID do Firebase não configurado.',
        missingVariable: 'FIREBASE_PROJECT_ID',
      );
    }
  }

  /// Obtém informações do ambiente (para debug)
  static Map<String, dynamic> getEnvironmentInfo() {
    return {
      'appName': Environment.appName,
      'appVersion': Environment.appVersion,
      'isProduction': Environment.isProduction,
      'isDebug': Environment.isDebug,
      'defaultLanguage': Environment.defaultLanguage,
      'supportedLanguages': Environment.supportedLanguages,
      'geminiApiKeyConfigured': Environment.geminiApiKey.isNotEmpty,
      'firebaseProjectId': Environment.firebaseProjectId,
      'defaultNotificationTime': '${Environment.defaultNotificationHour}:${Environment.defaultNotificationMinute}',
      'apiTimeout': '${Environment.apiTimeoutSeconds}s',
      'maxApiRetries': Environment.maxApiRetries,
    };
  }

  /// Verifica se o ambiente está configurado para desenvolvimento
  static bool isDevelopmentConfigured() {
    try {
      validateGeminiConfig();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// =============================================
// UTILITÁRIOS
// =============================================

/// Utilitários para ambiente
class EnvironmentUtils {
  /// Obtém uma mensagem de fallback baseada no timestamp
  static String getFallbackMessage() {
    final messages = Environment.fallbackMotivationalMessages;
    final index = DateTime.now().millisecondsSinceEpoch % messages.length;
    return messages[index];
  }

  /// Obtém uma mensagem de fallback específica por índice
  static String getFallbackMessageByIndex(int index) {
    final messages = Environment.fallbackMotivationalMessages;
    final safeIndex = index % messages.length;
    return messages[safeIndex];
  }

  /// Formata informações do ambiente para logging
  static String formatEnvironmentInfo() {
    final info = EnvironmentValidator.getEnvironmentInfo();
    final buffer = StringBuffer();

    buffer.writeln('=== CONFIGURAÇÃO DO AMBIENTE ===');
    buffer.writeln('App: ${info['appName']} v${info['appVersion']}');
    buffer.writeln('Modo: ${info['isProduction'] ? 'Produção' : 'Desenvolvimento'}');
    buffer.writeln('Idioma padrão: ${info['defaultLanguage']}');
    buffer.writeln('Gemini API: ${info['geminiApiKeyConfigured'] ? 'Configurada' : 'Não configurada'}');
    buffer.writeln('Firebase Project: ${info['firebaseProjectId']}');
    buffer.writeln('Timeout API: ${info['apiTimeout']}');
    buffer.writeln('Tentativas máximas: ${info['maxApiRetries']}');
    buffer.writeln('================================');

    return buffer.toString();
  }

  /// Valida e retorna a chave da API Gemini
  static String getValidatedGeminiApiKey() {
    EnvironmentValidator.validateGeminiConfig();
    return Environment.geminiApiKey;
  }
}