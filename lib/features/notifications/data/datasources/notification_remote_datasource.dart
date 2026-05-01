import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/activity_notification_model.dart';

abstract class INotificationRemoteDataSource {
  Future<List<ActivityNotificationModel>> getNotifications({
    required int page,
    required int size,
  });
  Future<int> getUnreadCount();
  Future<void> markAllAsRead();
  Future<void> registerDeviceToken(String fcmToken);
}

@LazySingleton(as: INotificationRemoteDataSource)
class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  NotificationRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<ActivityNotificationModel>> getNotifications({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<Object?>(
        ApiConstants.notifications,
        queryParams: {'page': page, 'size': size},
      );

      final content = _extractNotificationItems(response.data);

      return content
          .map(_asObjectMap)
          .whereType<Map<String, Object?>>()
          .map(activityNotificationModelFromApiJson)
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized');
      }
      throw const ServerException('Failed to fetch notifications');
    } catch (e, stackTrace) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dioClient.get<Object?>(
        ApiConstants.unreadNotificationCount,
      );

      final responseData = response.data as Map<String, Object?>;
      return responseData['unreadCount'] as int;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized');
      }
      throw const ServerException('Failed to fetch unread count');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dioClient.post<Object?>(
        ApiConstants.markAllNotificationsRead,
        data: <String, Object?>{},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized');
      }
      throw const ServerException('Failed to mark notifications as read');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<void> registerDeviceToken(String fcmToken) async {
    try {
      await _dioClient.post<Object?>(
        ApiConstants.deviceTokens,
        data: {'token': fcmToken, 'deviceType': 'MOBILE'},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const ServerException('Validation error on token registration');
      }
      if (e.response?.statusCode == 401) {
        throw const ServerException('Unauthorized');
      }
      throw const ServerException('Failed to register device token');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }
}

List<Object?> _extractNotificationItems(Object? responseData) {
  if (responseData is List) {
    return responseData.cast<Object?>();
  }

  final responseMap = _asObjectMap(responseData);
  if (responseMap == null) {
    return const <Object?>[];
  }

  final content = responseMap['content'] ??
      responseMap['notifications'] ??
      responseMap['items'] ??
      responseMap['results'] ??
      responseMap['data'];

  if (content is List) {
    return content.cast<Object?>();
  }

  final nestedContent = _asObjectMap(content);
  if (nestedContent != null) {
    return _extractNotificationItems(nestedContent);
  }

  return const <Object?>[];
}

Map<String, Object?>? _asObjectMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  return null;
}
