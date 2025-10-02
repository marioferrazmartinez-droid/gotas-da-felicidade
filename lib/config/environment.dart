class EnvironmentConfig {
  // Configurações da API de IA
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  // Configurações do App
  static const String appName = 'Gotas da Felicidade';
  static const String appVersion = '1.0.0';

  // URLs e Endpoints
  static const String fallbackQuotesApi = 'https://api.quotable.io/random';

  // Configurações de Notificação
  static const int defaultNotificationHour = 8;
  static const int defaultNotificationMinute = 0;

  // Limites e Configurações
  static const int maxQuotesPerDay = 5;
  static const int quoteMaxLength = 200;

  // Temas disponíveis
  static const List<String> availableThemes = [
    'motivação',
    'felicidade',
    'sucesso',
    'persistência',
    'otimismo',
    'coragem',
    'paz',
    'amor',
  ];

  // Citações de fallback
  static const Map<String, String> fallbackQuotes = {
    'motivação': '"A persistência é o caminho do êxito" - Charles Chaplin',
    'felicidade': '"A felicidade não é algo pronto. Ela vem de suas próprias ações" - Dalai Lama',
    'sucesso': '"O sucesso nasce do querer, da determinação e persistência em se chegar a um objetivo" - Desconhecido',
    'persistência': '"Não importa o quão devagar você vá, desde que você não pare" - Confúcio',
    'otimismo': '"O otimismo é a fé em ação. Nada se pode levar a efeito sem otimismo" - Helen Keller',
    'coragem': '"A coragem não é a ausência do medo, mas a conquista sobre ele" - Nelson Mandela',
    'paz': '"A paz começa com um sorriso" - Madre Teresa',
    'amor': '"Amar não é olhar um para o outro, é olhar juntos na mesma direção" - Antoine de Saint-Exupéry',
  };
}