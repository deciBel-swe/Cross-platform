import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../../domain/entities/notification_settings.dart';
import '../models/notification_settings_model.dart';

@lazySingleton
class NotificationSettingsRemoteDatasource {
  NotificationSettingsRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  static const String _endpoint = '/notifications/settings';

  /// GET /notifications/settings
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final response = await _dioClient.get<Map<String, dynamic>>(_endpoint);

    final data = response.data;
    if (data == null) {
      throw Exception('Empty notification settings response');
    }

    return NotificationSettingsModel.fromJson(data);
  }

  /// PATCH /notifications/settings
  Future<NotificationSettingsModel> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    final response = await _dioClient.patch<Map<String, dynamic>>(
      _endpoint,
      data: settings.toModel().toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty update notification settings response');
    }

    return NotificationSettingsModel.fromJson(data);
  }
}
