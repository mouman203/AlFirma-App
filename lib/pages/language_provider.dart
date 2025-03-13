import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  void changeLanguage(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('languageCode');
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }
}
