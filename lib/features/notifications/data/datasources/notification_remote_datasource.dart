import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
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
  NotificationRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<ActivityNotificationModel>> getNotifications({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        ApiConstants.notifications,
        queryParameters: {'page': page, 'size': size},
      );

      // 1. Safely cast the raw response data
      final responseData = response.data as Map<String, Object?>;

      // 2. Cast the content array
      final content = responseData['content'] as List<Object?>;

      // 3. Map the array
      return content.map((item) {
        final jsonMap = item as Map<String, dynamic>;
        return ActivityNotificationModel.fromJson(jsonMap);
      }).toList();
    } on DioException catch (e) {
      debugPrint('DioException in getNotifications: ${e.message}');
      debugPrint('Response Data: ${e.response?.data}');

      if (e.response?.statusCode == 401)
        throw const ServerException('Unauthorized');
      throw const ServerException('Failed to fetch notifications');
    } catch (e, stackTrace) {
      debugPrint('CRITICAL ERROR in getNotifications: $e');
      debugPrint('StackTrace: $stackTrace');
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get<Object?>(
        ApiConstants.unreadNotificationCount,
      );

      final responseData = response.data as Map<String, Object?>;
      return responseData['unreadCount'] as int;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401)
        throw const ServerException('Unauthorized');
      throw const ServerException('Failed to fetch unread count');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.post<Object?>(ApiConstants.markAllNotificationsRead, data: {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 401)
        throw const ServerException('Unauthorized');
      throw const ServerException('Failed to mark notifications as read');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<void> registerDeviceToken(String fcmToken) async {
    try {
      await _dio.post<Object?>(
        ApiConstants.deviceTokens,
        data: {'token': fcmToken, 'deviceType': 'MOBILE'},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400)
        throw const ServerException('Validation error on token registration');
      if (e.response?.statusCode == 401)
        throw const ServerException('Unauthorized');
      throw const ServerException('Failed to register device token');
    } catch (e) {
      throw const ServerException('Unexpected error occurred');
    }
  }
}
