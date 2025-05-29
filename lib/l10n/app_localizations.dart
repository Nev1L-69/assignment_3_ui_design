import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const _localizedStrings = {
    'en': {
      'title': 'Task Manager',
      'settings': 'Settings',
      'logout': 'Log Out',
      'theme': 'Dark Theme',
      'language': 'Language',
      'save': 'Save Settings',
      'welcome': 'Welcome, User',
      'no_tasks': 'No tasks found',
    },
    'ru': {
      'title': 'Менеджер задач',
      'settings': 'Настройки',
      'logout': 'Выйти',
      'theme': 'Тёмная тема',
      'language': 'Язык',
      'save': 'Сохранить настройки',
      'welcome': 'Добро пожаловать',
      'no_tasks': 'Нет задач',
    },
    'kk': {
      'title': 'Тапсырмалар басқарушысы',
      'settings': 'Параметрлер',
      'logout': 'Шығу',
      'theme': 'Қараңғы тақырып',
      'language': 'Тіл',
      'save': 'Баптауларды сақтау',
      'welcome': 'Қош келдіңіз',
      'no_tasks': 'Тапсырмалар жоқ',
    },
  };

  String get(String key) {
    return _localizedStrings[locale.languageCode]?[key] ??
        _localizedStrings['en']![key]!;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ru', 'kk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
