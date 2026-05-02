import 'package:decibel/core/constants/api_constants.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient dioClient;
  late NotificationRemoteDataSource dataSource;

  setUp(() {
    dioClient = MockDioClient();
    dataSource = NotificationRemoteDataSource(dioClient);
  });

  Response<T> response<T>(T data) {
    return Response<T>(
      requestOptions: RequestOptions(path: '/notifications'),
      data: data,
    );
  }

  group('NotificationRemoteDataSource', () {
    test('getNotifications parses list responses into models', () async {
      when(
        () => dioClient.get<Object?>(
          ApiConstants.notifications,
          queryParams: {'page': 0, 'size': 20},
        ),
      ).thenAnswer(
        (_) async => response<Object?>([
          {
            'id': 1,
            'type': 'FOLLOW',
            'user': {'id': 2, 'username': 'alice'},
            'resource': {'resourceType': 'USER', 'resourceId': 2},
            'isRead': false,
            'createdAt': '2026-01-01T00:00:00Z',
          },
        ]),
      );

      final models = await dataSource.getNotifications(page: 0, size: 20);

      expect(models.single.id, 1);
      expect(models.single.user.username, 'alice');
      verify(
        () => dioClient.get<Object?>(
          ApiConstants.notifications,
          queryParams: {'page': 0, 'size': 20},
        ),
      ).called(1);
    });

    test('getNotifications parses nested content responses', () async {
      when(
        () => dioClient.get<Object?>(
          ApiConstants.notifications,
          queryParams: {'page': 1, 'size': 10},
        ),
      ).thenAnswer(
        (_) async => response<Object?>({
          'data': {
            'content': [
              {
                'notificationId': '7',
                'notificationType': 'LIKE',
                'actor': {'userId': '4', 'name': 'Mona'},
                'targetType': 'TRACK',
                'targetId': '44',
                'read': 'true',
              },
            ],
          },
        }),
      );

      final models = await dataSource.getNotifications(page: 1, size: 10);

      expect(models.single.id, 7);
      expect(models.single.user.displayName, 'Mona');
      expect(models.single.resource.resourceId, 44);
    });

    test('getNotifications maps unauthorized Dio errors', () async {
      when(
        () => dioClient.get<Object?>(
          ApiConstants.notifications,
          queryParams: {'page': 0, 'size': 20},
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiConstants.notifications),
          response: Response<void>(
            requestOptions: RequestOptions(path: ApiConstants.notifications),
            statusCode: 401,
          ),
        ),
      );

      expect(
        () => dataSource.getNotifications(page: 0, size: 20),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Unauthorized',
          ),
        ),
      );
    });

    test('getUnreadCount returns unreadCount from backend payload', () async {
      when(
        () => dioClient.get<Object?>(ApiConstants.unreadNotificationCount),
      ).thenAnswer((_) async => response<Object?>({'unreadCount': 12}));

      final count = await dataSource.getUnreadCount();

      expect(count, 12);
    });

    test('markAllAsRead posts an empty payload', () async {
      when(
        () => dioClient.post<Object?>(
          ApiConstants.markAllNotificationsRead,
          data: <String, Object?>{},
        ),
      ).thenAnswer((_) async => response<Object?>(null));

      await dataSource.markAllAsRead();

      verify(
        () => dioClient.post<Object?>(
          ApiConstants.markAllNotificationsRead,
          data: <String, Object?>{},
        ),
      ).called(1);
    });

    test('registerDeviceToken posts mobile token payload', () async {
      when(
        () => dioClient.post<Object?>(
          ApiConstants.deviceTokens,
          data: {'token': 'abc', 'deviceType': 'MOBILE'},
        ),
      ).thenAnswer((_) async => response<Object?>(null));

      await dataSource.registerDeviceToken('abc');

      verify(
        () => dioClient.post<Object?>(
          ApiConstants.deviceTokens,
          data: {'token': 'abc', 'deviceType': 'MOBILE'},
        ),
      ).called(1);
    });

    test('registerDeviceToken maps validation errors', () async {
      when(
        () => dioClient.post<Object?>(
          ApiConstants.deviceTokens,
          data: {'token': 'bad', 'deviceType': 'MOBILE'},
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiConstants.deviceTokens),
          response: Response<void>(
            requestOptions: RequestOptions(path: ApiConstants.deviceTokens),
            statusCode: 400,
          ),
        ),
      );

      expect(
        () => dataSource.registerDeviceToken('bad'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Validation error on token registration',
          ),
        ),
      );
    });
  });
}
