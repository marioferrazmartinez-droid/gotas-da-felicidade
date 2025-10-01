// lib/config/environment.dart

/// Configurações de ambiente e variáveis sensíveis
/// Para desenvolvimento, crie um arquivo .env na raiz do projeto
abstract class Environment {
  // Chave da API Gemini - configure via --dart-define ou .env
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '', // Será substituída via --dart-define
  );

  // Configurações do Firebase
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // URLs da API
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Configurações do app
  static const String appName = 'Gotas da Felicidade';
  static const String appVersion = '1.0.0';
}

/// Exceção para configurações faltantes
class EnvironmentException implements Exception {
  final String message;
  EnvironmentException(this.message);

  @override
  String toString() => 'EnvironmentException: $message';
}

/// Validador de ambiente
class EnvironmentValidator {
  static void validate() {
    if (Environment.geminiApiKey.isEmpty) {
      throw EnvironmentException(
          'GEMINI_API_KEY não configurada. '
              'Execute com: flutter run --dart-define=GEMINI_API_KEY=sua_chave_aqui'
      );
    }
  }
}