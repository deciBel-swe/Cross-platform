import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  return SharedPrefsService();
});

class SharedPrefsService {
  // Keys
  static const String _privacyKey = 'privacy_settings';

  // Methods

  /// Fetches the last saved privacy state. By default it will be false (Public)
  Future<bool> getLastPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyKey) ?? false;
  }

  /// Saves the user's privacy preference for the next time he comes
  Future<void> saveLastPrivacySettings(bool isPrivate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyKey, isPrivate);
  }
}
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
