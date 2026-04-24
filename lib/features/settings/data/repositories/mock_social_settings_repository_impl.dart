import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/social_settings.dart';
import '../../domain/repositories/social_settings_repository.dart';

class MockSocialSettingsRepository implements SocialSettingsRepository {
  MockSocialSettingsRepository(this._cache);

  final SharedPrefsService _cache;

  static const String _cacheKeyIsPrivate = 'cache_social_is_private';
  static const String _cacheKeyShowHistory = 'cache_social_show_history';

  @override
  Future<SocialSettings> getSocialSettings() async {
    final cachedPrivate = await _cache.getString(_cacheKeyIsPrivate);
    final cachedHistory = await _cache.getString(_cacheKeyShowHistory);

    return SocialSettings(
      isPrivate: (cachedPrivate ?? 'false') == 'true',
      showHistory: (cachedHistory ?? 'true') == 'true',
    );
  }

  @override
  Future<void> updateSocialSettings(SocialSettings settings) async {
    await _cache.setString(_cacheKeyIsPrivate, settings.isPrivate.toString());
    await _cache.setString(
      _cacheKeyShowHistory,
      settings.showHistory.toString(),
    );
  }
}
