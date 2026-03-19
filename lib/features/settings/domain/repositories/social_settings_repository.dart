import '../../domain/entities/social_settings.dart';

abstract class SocialSettingsRepository {
  Future<SocialSettings> getSocialSettings();
  Future<void> updateSocialSettings(SocialSettings settings);
}