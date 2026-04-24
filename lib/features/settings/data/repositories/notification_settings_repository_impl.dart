import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';
import '../datasources/notification_settings_remote_datasource.dart';
import '../models/notification_settings_model.dart';

class NotificationSettingsRepositoryImpl
    implements NotificationSettingsRepository {
  NotificationSettingsRepositoryImpl(this._remoteDatasource);

  final NotificationSettingsRemoteDatasource _remoteDatasource;

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    final settingsModel = await _remoteDatasource.getNotificationSettings();
    return settingsModel.toEntity();
  }

  @override
  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    final settingsModel = await _remoteDatasource.updateNotificationSettings(
      settings.toModel(),
    );
    return settingsModel.toEntity();
  }
}
