import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to access the service across the app
final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  return SharedPrefsService();
});

class SharedPrefsService {
  // --- Keys ---
  static const String _privacyKey = 'privacy_settings';

  // --- Instance Management ---
  SharedPreferences? _prefs;

  /// Lazy-initialization: only calls getInstance() once per app session
  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  // --- Specific Logic (from snippet 1) ---

  /// Fetches the last saved privacy state. By default it will be false (Public)
  Future<bool> getLastPrivacySettings() async {
    final prefs = await _instance;
    return prefs.getBool(_privacyKey) ?? false;
  }

  /// Saves the user's privacy preference
  Future<void> saveLastPrivacySettings(bool isPrivate) async {
    final prefs = await _instance;
    await prefs.setBool(_privacyKey, isPrivate);
  }

  // --- Generic Logic (from snippet 2) ---

  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }
}