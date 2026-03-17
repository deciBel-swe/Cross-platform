/// Repository contract for managing social and insights visibility settings.
abstract class SocialSettingsRepository {
  /// Fetches the current state of all social networking and visibility toggles.
  Future<Map<String, bool>> getSettings();

  /// Persists a specific setting toggle.
  Future<void> updateSetting(String key, bool value);
}