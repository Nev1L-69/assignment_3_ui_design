import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isDarkTheme = false;

  Locale get locale => _locale;
  bool get isDarkTheme => _isDarkTheme;

  void setLocale(Locale locale) {
    if (!['en', 'ru', 'kk'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkTheme = isDark;
    notifyListeners();
  }

  void loadAll({required Locale locale, required bool isDark}) {
    _locale = locale;
    _isDarkTheme = isDark;
    notifyListeners();
  }
}
