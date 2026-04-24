import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';

/// In-memory mock – no network calls, suitable for mock/dev environments.
class MockNotificationSettingsRepository
    implements NotificationSettingsRepository {
  NotificationSettings _stored = const NotificationSettings(
    notifyOnFollow: true,
    notifyOnLike: true,
    notifyOnRepost: true,
    notifyOnComment: true,
    notifyOnDM: true,
  );

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _stored;
  }

  @override
  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _stored = settings;
    return _stored;
  }
}
