import 'package:agriplant/Back_end/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  // Method to toggle between light and dark mode
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Only save theme preference if the user is logged in (not anonymous)
    if (!Users.isGuestUser()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDark);
    }
  }

  // Load theme preference if the user is logged in
  Future<void> loadTheme() async {
    if (Users.isGuestUser()) {
      _themeMode = ThemeMode.system;  // Use system default for anonymous users
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isDarkMode = prefs.getBool('isDarkMode');
      _themeMode = (isDarkMode ?? false) ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

}
