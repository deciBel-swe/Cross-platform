import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_settings_model.dart';

@lazySingleton
class NotificationSettingsRemoteDatasource {
  NotificationSettingsRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  /// GET /notifications/settings
  Future<NotificationSettingsModel> getNotificationSettings() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.notificationSettingsEndpoint,
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty notification settings response');
      }

      return NotificationSettingsModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const AuthException('Unauthorized');
      }

      throw ServerException(
        error.message ?? 'Failed to fetch notification settings',
      );
    }
  }

  /// PATCH /notifications/settings
  Future<NotificationSettingsModel> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    try {
      final response = await _dioClient.patch<Map<String, dynamic>>(
        ApiConstants.notificationSettingsEndpoint,
        data: settings.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(
          'Empty update notification settings response',
        );
      }

      return NotificationSettingsModel.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const AuthException('Unauthorized');
      }

      throw ServerException(
        error.message ?? 'Failed to update notification settings',
      );
    }
  }
}
