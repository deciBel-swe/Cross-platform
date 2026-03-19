import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/social_settings.dart';
import '../../domain/repositories/social_settings_repository.dart';

class SocialSettingsRepositoryImpl implements SocialSettingsRepository {
  SocialSettingsRepositoryImpl(this._api, this._cache);
  final DioClient _api;
  final SharedPrefsService _cache;

  static const String _cacheKeyIsPrivate = 'cache_social_is_private';
  static const String _cacheKeyShowHistory = 'cache_social_show_history';
  @override
  Future<SocialSettings> getSocialSettings() async {
    try {
      final response = await _api.get(ApiConstants.userProfileEndpoint);
      final privacyData = response.data['privacySettings'];

      if (privacyData != null) {
        // Generated fromJson is now used here
        final settings = SocialSettings.fromJson(
          privacyData as Map<String, dynamic>,
        );

        // Save to cache...
        return settings;
      }
      return _getFallbackSettings();
    } catch (e) {
      return _getFallbackSettings();
    }
  }

  Future<SocialSettings> _getFallbackSettings() async {
    final cachedPrivate = await _cache.getString(_cacheKeyIsPrivate);
    final cachedHistory = await _cache.getString(_cacheKeyShowHistory);

    return SocialSettings(
      isPrivate: (cachedPrivate ?? 'false') == 'true',
      showHistory: (cachedHistory ?? 'false') == 'true',
    );
  }

  @override
  Future<void> updateSocialSettings(SocialSettings settings) async {
    try {
      // Attempt to save to the cloud
      await _api.put(ApiConstants.userProfilePrivacy, data: settings.toJson());

      // Only if the Cloud save works, we update the local cache
      await _cache.setString(_cacheKeyIsPrivate, settings.isPrivate.toString());
      await _cache.setString(
        _cacheKeyShowHistory,
        settings.showHistory.toString(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
