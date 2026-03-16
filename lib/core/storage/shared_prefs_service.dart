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
