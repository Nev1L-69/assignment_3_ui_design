import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'No AppLocalizations found in context');
    return localizations!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'homeTitle': 'Home Screen',
      'welcome': 'Welcome to My App',
      'about': 'About',
      'settings': 'Settings',
      'appearance': 'Appearance',
      'themeMode': 'Theme Mode',
      'language': 'Language',
      'aboutText': 'This is a demo application showing navigation and settings implementation.',
      'itemTitle': 'Item @number',
      'itemDescription': 'Description of item @number',
    },
    'ru': {
      'homeTitle': 'Главный экран',
      'welcome': 'Добро пожаловать в мое приложение',
      'about': 'О приложении',
      'settings': 'Настройки',
      'appearance': 'Внешний вид',
      'themeMode': 'Режим темы',
      'language': 'Язык',
      'aboutText': 'Это демонстрационное приложение, показывающее реализацию навигации и настроек.',
      'itemTitle': 'Элемент @number',
      'itemDescription': 'Описание элемента @number',
    },
    'kk': {
      'homeTitle': 'Басты экран',
      'welcome': 'Менің қолданбама қош келдіңіз',
      'about': 'Қолданба туралы',
      'settings': 'Баптаулар',
      'appearance': 'Сыртқы түрі',
      'themeMode': 'Тақырып режимі',
      'language': 'Тіл',
      'aboutText': 'Бұл навигация мен баптаулардың іске асырылуын көрсететін демонстрациялық қолданба.',
      'itemTitle': '@number элемент',
      'itemDescription': '@number элементінің сипаттамасы',
    },
  };

  String get homeTitle => _localizedValues[locale.languageCode]!['homeTitle']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get aboutTitle => _localizedValues[locale.languageCode]!['about']!;
  String get settingsTitle => _localizedValues[locale.languageCode]!['settings']!;
  String get appearanceTitle => _localizedValues[locale.languageCode]!['appearance']!;
  String get themeModeTitle => _localizedValues[locale.languageCode]!['themeMode']!;
  String get languageTitle => _localizedValues[locale.languageCode]!['language']!;
  String get aboutText => _localizedValues[locale.languageCode]!['aboutText']!;
  
  String itemTitle(int number) => _localizedValues[locale.languageCode]!['itemTitle']!.replaceAll('@number', number.toString());
  String itemDescription(int number) => _localizedValues[locale.languageCode]!['itemDescription']!.replaceAll('@number', number.toString());
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru', 'kk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}