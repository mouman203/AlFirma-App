import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('ar'); // Default to Arabic

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage(); // Load saved language on startup
  }

  // Change and persist language
  void changeLanguage(Locale newLocale) async {
    if (_locale == newLocale) return; // Avoid redundant updates
    _locale = newLocale;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  // Load saved language from preferences
 Future<void> loadLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('languageCode');

  final newLocale = (langCode != null && langCode.isNotEmpty)
      ? Locale(langCode)
      : const Locale('ar'); // Fallback to Arabic

  if (_locale != newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}

}
