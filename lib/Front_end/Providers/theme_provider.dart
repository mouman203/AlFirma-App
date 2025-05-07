import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  // Toggle between light and dark mode, and save it
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  // Load saved theme preference or fallback to system
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    _themeMode = (isDarkMode ?? false) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
