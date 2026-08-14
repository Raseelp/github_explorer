import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesService {
  static const _key = 'recent_searches';

  Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> add(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_key) ?? [];
    list.removeWhere((e) => e.toLowerCase() == username.toLowerCase());
    list.insert(0, username);
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }
    await prefs.setStringList(_key, list);
  }
}
