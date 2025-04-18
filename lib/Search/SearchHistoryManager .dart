
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryManager {
  static const String key = 'recent_searches';

  Future<void> addSearch(String word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(key) ?? [];

    history.remove(word); // لو الكلمة مكررة نحذفها
    history.insert(0, word); // نضيفها في البداية

    if (history.length > 10) {
      history = history.sublist(0, 10); // نخلي فقط 10 كلمات
    }

    await prefs.setStringList(key, history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}