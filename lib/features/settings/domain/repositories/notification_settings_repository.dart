import '../entities/notification_settings.dart';

abstract class NotificationSettingsRepository {
  Future<NotificationSettings> getNotificationSettings();

  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  );
}