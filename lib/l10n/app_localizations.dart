import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Métodos para cada texto
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get dailyMotivation => _localizedValues[locale.languageCode]!['dailyMotivation']!;
  String get getMotivation => _localizedValues[locale.languageCode]!['getMotivation']!;
  String get newMotivation => _localizedValues[locale.languageCode]!['newMotivation']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signup => _localizedValues[locale.languageCode]!['signup']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirmPassword']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['alreadyHaveAccount']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dontHaveAccount']!;
  String get or => _localizedValues[locale.languageCode]!['or']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get motivationLoading => _localizedValues[locale.languageCode]!['motivationLoading']!;
  String get todayMessage => _localizedValues[locale.languageCode]!['todayMessage']!;
  String get notificationTitle => _localizedValues[locale.languageCode]!['notificationTitle']!;
  String get notificationBody => _localizedValues[locale.languageCode]!['notificationBody']!;
  String get goodMorning => _localizedValues[locale.languageCode]!['goodMorning']!;
  String get goodAfternoon => _localizedValues[locale.languageCode]!['goodAfternoon']!;
  String get goodEvening => _localizedValues[locale.languageCode]!['goodEvening']!;
  String get happinessQuote => _localizedValues[locale.languageCode]!['happinessQuote']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Drops of Happiness',
      'welcome': 'Welcome to Drops of Happiness!',
      'dailyMotivation': 'Your daily motivation',
      'getMotivation': 'Get Motivation',
      'newMotivation': 'New Motivation',
      'settings': 'Settings',
      'language': 'Language',
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'confirmPassword': 'Confirm Password',
      'alreadyHaveAccount': 'Already have an account?',
      'dontHaveAccount': 'Don\'t have an account?',
      'or': 'OR',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'motivationLoading': 'Generating your daily motivation...',
      'todayMessage': 'Today\'s message',
      'notificationTitle': 'Your daily dose of happiness!',
      'notificationBody': 'Tap to receive your motivational message',
      'goodMorning': 'Good Morning',
      'goodAfternoon': 'Good Afternoon',
      'goodEvening': 'Good Evening',
      'happinessQuote': 'Happiness is not something ready-made. It comes from your own actions.',
    },
    'pt': {
      'appTitle': 'Gotas da Felicidade',
      'welcome': 'Bem-vindo ao Gotas da Felicidade!',
      'dailyMotivation': 'Sua motivação diária',
      'getMotivation': 'Obter Motivação',
      'newMotivation': 'Nova Motivação',
      'settings': 'Configurações',
      'language': 'Idioma',
      'login': 'Entrar',
      'signup': 'Cadastrar',
      'logout': 'Sair',
      'email': 'E-mail',
      'password': 'Senha',
      'name': 'Nome',
      'confirmPassword': 'Confirmar Senha',
      'alreadyHaveAccount': 'Já tem uma conta?',
      'dontHaveAccount': 'Não tem uma conta?',
      'or': 'OU',
      'loading': 'Carregando...',
      'error': 'Erro',
      'success': 'Sucesso',
      'motivationLoading': 'Gerando sua motivação diária...',
      'todayMessage': 'Mensagem de hoje',
      'notificationTitle': 'Sua dose diária de felicidade!',
      'notificationBody': 'Toque para receber sua mensagem motivacional',
      'goodMorning': 'Bom Dia',
      'goodAfternoon': 'Boa Tarde',
      'goodEvening': 'Boa Noite',
      'happinessQuote': 'A felicidade não é algo pronto. Ela vem das suas próprias ações.',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt', 'es', 'fr', 'zh', 'ja', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}