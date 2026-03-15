import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences wrapper for simple key-value local storage.
class SharedPrefsService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }
}
