// lib/l10n/app_localizations.dart

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Métodos com fallback para inglês
  String get appTitle => _getLocalizedValue('appTitle');
  String get welcome => _getLocalizedValue('welcome');
  String get dailyMotivation => _getLocalizedValue('dailyMotivation');
  String get getMotivation => _getLocalizedValue('getMotivation');
  String get newMotivation => _getLocalizedValue('newMotivation');
  String get settings => _getLocalizedValue('settings');
  String get language => _getLocalizedValue('language');
  String get login => _getLocalizedValue('login');
  String get signup => _getLocalizedValue('signup');
  String get logout => _getLocalizedValue('logout');
  String get email => _getLocalizedValue('email');
  String get password => _getLocalizedValue('password');
  String get name => _getLocalizedValue('name');
  String get confirmPassword => _getLocalizedValue('confirmPassword');
  String get alreadyHaveAccount => _getLocalizedValue('alreadyHaveAccount');
  String get dontHaveAccount => _getLocalizedValue('dontHaveAccount');
  String get or => _getLocalizedValue('or');
  String get loading => _getLocalizedValue('loading');
  String get error => _getLocalizedValue('error');
  String get success => _getLocalizedValue('success');
  String get motivationLoading => _getLocalizedValue('motivationLoading');
  String get todayMessage => _getLocalizedValue('todayMessage');
  String get notificationTitle => _getLocalizedValue('notificationTitle');
  String get notificationBody => _getLocalizedValue('notificationBody');
  String get goodMorning => _getLocalizedValue('goodMorning');
  String get goodAfternoon => _getLocalizedValue('goodAfternoon');
  String get goodEvening => _getLocalizedValue('goodEvening');
  String get happinessQuote => _getLocalizedValue('happinessQuote');

  /// Obtém valor localizado com fallback para inglês
  String _getLocalizedValue(String key) {
    final languageCode = locale.languageCode;

    // Tenta obter do idioma atual
    final value = _localizedValues[languageCode]?[key];
    if (value != null) return value;

    // Fallback para inglês
    final englishValue = _localizedValues['en']?[key];
    if (englishValue != null) return englishValue;

    // Fallback final
    return '[$key]';
  }

  /// Verifica se um idioma é suportado
  static bool isLanguageSupported(String languageCode) {
    return _localizedValues.containsKey(languageCode);
  }

  /// Lista de idiomas suportados
  static List<String> get supportedLanguages {
    return _localizedValues.keys.toList();
  }

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
    'es': {
      'appTitle': 'Gotas de Felicidad',
      'welcome': '¡Bienvenido a Gotas de Felicidad!',
      'dailyMotivation': 'Tu motivación diaria',
      'getMotivation': 'Obtener Motivación',
      'newMotivation': 'Nueva Motivación',
      'settings': 'Configuración',
      'language': 'Idioma',
      'login': 'Iniciar Sesión',
      'signup': 'Registrarse',
      'logout': 'Cerrar Sesión',
      'email': 'Correo Electrónico',
      'password': 'Contraseña',
      'name': 'Nombre',
      'confirmPassword': 'Confirmar Contraseña',
      'alreadyHaveAccount': '¿Ya tienes una cuenta?',
      'dontHaveAccount': '¿No tienes una conta?',
      'or': 'O',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'motivationLoading': 'Generando tu motivación diaria...',
      'todayMessage': 'Mensaje de hoy',
      'notificationTitle': '¡Tu dosis diaria de felicidad!',
      'notificationBody': 'Toca para recibir tu mensaje motivacional',
      'goodMorning': 'Buenos Días',
      'goodAfternoon': 'Buenas Tardes',
      'goodEvening': 'Buenas Noches',
      'happinessQuote': 'La felicidad no es algo hecho. Viene de tus propias acciones.',
    },
    'fr': {
      'appTitle': 'Gouttes de Bonheur',
      'welcome': 'Bienvenue à Gouttes de Bonheur!',
      'dailyMotivation': 'Votre motivation quotidienne',
      'getMotivation': 'Obtenir une Motivation',
      'newMotivation': 'Nouvelle Motivation',
      'settings': 'Paramètres',
      'language': 'Langue',
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'logout': 'Déconnexion',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'name': 'Nom',
      'confirmPassword': 'Confirmer le mot de passe',
      'alreadyHaveAccount': 'Vous avez déjà un compte?',
      'dontHaveAccount': 'Vous n\'avez pas de compte?',
      'or': 'OU',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'motivationLoading': 'Génération de votre motivation quotidienne...',
      'todayMessage': 'Message du jour',
      'notificationTitle': 'Votre dose quotidienne de bonheur!',
      'notificationBody': 'Tapez pour recevoir votre message de motivation',
      'goodMorning': 'Bonjour',
      'goodAfternoon': 'Bon Après-midi',
      'goodEvening': 'Bonsoir',
      'happinessQuote': 'Le bonheur n\'est pas quelque chose de tout fait. Il vient de vos propres actions.',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.isLanguageSupported(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}