import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_settings_repository.dart';

class NotificationSettingsRepositoryImpl
    implements NotificationSettingsRepository {
  NotificationSettingsRepositoryImpl(this._api);

  final DioClient _api;

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      final response = await _api.get<Map<String, dynamic>>(
        ApiConstants.notificationSettingsEndpoint,
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Notification settings response is empty.');
      }

      return NotificationSettings.fromJson(data);
    } on DioException catch (_) {
      return const NotificationSettings(
        notifyOnFollow: true,
        notifyOnLike: true,
        notifyOnRepost: true,
        notifyOnComment: true,
        notifyOnDM: true,
      );
    }
  }

  @override
  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    try {
      final response = await _api.patch<Map<String, dynamic>>(
        ApiConstants.notificationSettingsEndpoint,
        data: settings.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Notification settings update response is empty.');
      }

      return NotificationSettings.fromJson(data);
    } on DioException catch (_) {
      return settings;
    }
  }
}