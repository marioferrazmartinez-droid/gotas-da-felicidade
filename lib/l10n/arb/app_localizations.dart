import 'package:flutter/material.dart';
import 'dart:async';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Drops of Happiness',
      'dailyMessage': 'Daily Message',
      'tapForMore': 'Tap for more inspiration',
      'favorites': 'Favorites',
      'settings': 'Settings',
      'generateWithAI': 'Generate with AI',
      'share': 'Share',
      'save': 'Save',
      'cancel': 'Cancel',
    },
    'pt': {
      'appTitle': 'Gotas da Felicidade',
      'dailyMessage': 'Mensagem Diária',
      'tapForMore': 'Toque para mais inspiração',
      'favorites': 'Favoritos',
      'settings': 'Configurações',
      'generateWithAI': 'Gerar com IA',
      'share': 'Compartilhar',
      'save': 'Salvar',
      'cancel': 'Cancelar',
    },
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]?['appTitle'] ?? 'Gotas da Felicidade';
  }

  String get dailyMessage {
    return _localizedValues[locale.languageCode]?['dailyMessage'] ?? 'Mensagem Diária';
  }

  String get tapForMore {
    return _localizedValues[locale.languageCode]?['tapForMore'] ?? 'Toque para mais inspiração';
  }

  String get favorites {
    return _localizedValues[locale.languageCode]?['favorites'] ?? 'Favoritos';
  }

  String get settings {
    return _localizedValues[locale.languageCode]?['settings'] ?? 'Configurações';
  }

  String get generateWithAI {
    return _localizedValues[locale.languageCode]?['generateWithAI'] ?? 'Gerar com IA';
  }

  String get share {
    return _localizedValues[locale.languageCode]?['share'] ?? 'Compartilhar';
  }

  String get save {
    return _localizedValues[locale.languageCode]?['save'] ?? 'Salvar';
  }

  String get cancel {
    return _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancelar';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}