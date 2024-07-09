import 'package:flutter/material.dart';
import 'app_localizations_delegate.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  static List<Locale> get supportedLocales {
    return [
      const Locale('en', 'US'),
      const Locale('es', 'ES'),
    ];
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'enableNotifications': 'Enable Notifications',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'privacyPolicy': 'Privacy Policy',
    },
    'es': {
      'settings': 'Configuración',
      'enableNotifications': 'Habilitar notificaciones',
      'darkMode': 'Modo oscuro',
      'language': 'Idioma',
      'about': 'Acerca de',
      'privacyPolicy': 'Política de privacidad',
    },
  };

  String get settings {
    return _localizedValues[locale.languageCode]!['settings']!;
  }

  String get enableNotifications {
    return _localizedValues[locale.languageCode]!['enableNotifications']!;
  }

  String get darkMode {
    return _localizedValues[locale.languageCode]!['darkMode']!;
  }

  String get language {
    return _localizedValues[locale.languageCode]!['language']!;
  }

  String get about {
    return _localizedValues[locale.languageCode]!['about']!;
  }

  String get privacyPolicy {
    return _localizedValues[locale.languageCode]!['privacyPolicy']!;
  }
}
