import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('kk'); // fallback на казахский

  LocaleProvider() {
    loadLocale();
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale();
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale');
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', _locale.languageCode);
  }
}
