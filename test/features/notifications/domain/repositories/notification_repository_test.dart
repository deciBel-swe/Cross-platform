import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:decibel/features/notifications/data/models/activity_notification_model.dart';
import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationRemoteDataSource
    implements INotificationRemoteDataSource {
  List<ActivityNotificationModel> notifications = const [];
  int unreadCount = 0;
  Object? getNotificationsError;
  Object? unreadCountError;
  Object? markAllError;
  Object? registerError;
  final registeredTokens = <String>[];
  var markAllCalls = 0;

  @override
  Future<List<ActivityNotificationModel>> getNotifications({
    required int page,
    required int size,
  }) async {
    if (getNotificationsError != null) throw getNotificationsError!;
    return notifications;
  }

  @override
  Future<int> getUnreadCount() async {
    if (unreadCountError != null) throw unreadCountError!;
    return unreadCount;
  }

  @override
  Future<void> markAllAsRead() async {
    markAllCalls++;
    if (markAllError != null) throw markAllError!;
  }

  @override
  Future<void> registerDeviceToken(String fcmToken) async {
    registeredTokens.add(fcmToken);
    if (registerError != null) throw registerError!;
  }
}

void main() {
  late FakeNotificationRemoteDataSource remote;
  late NotificationRepository repository;

  setUp(() {
    remote = FakeNotificationRemoteDataSource();
    repository = NotificationRepository(remote);
  });

  ActivityNotificationModel model({String type = 'FOLLOW'}) {
    return ActivityNotificationModel(
      id: 1,
      type: type,
      user: const NotificationUserModel(id: 2, username: 'alice'),
      resource: const NotificationResourceModel(
        resourceType: 'USER',
        resourceId: 2,
      ),
      isRead: false,
      createdAt: DateTime.utc(2026, 1, 1),
    );
  }

  test('getNotifications maps models into entities', () async {
    remote.notifications = [model()];

    final (failure, notifications) = await repository.getNotifications(0, 20);

    expect(failure, isNull);
    expect(notifications?.single.type, NotificationType.follow);
  });

  test('getNotifications maps server exceptions into failures', () async {
    remote.getNotificationsError = const ServerException('server down');

    final (failure, notifications) = await repository.getNotifications(0, 20);

    expect(failure, const ServerFailure('server down'));
    expect(notifications, isNull);
  });

  test('getUnreadCount returns count or failure', () async {
    remote.unreadCount = 7;
    expect((await repository.getUnreadCount()).$2, 7);

    remote.unreadCountError = Exception('boom');
    final (failure, count) = await repository.getUnreadCount();
    expect(failure, const ServerFailure('An unexpected error occurred'));
    expect(count, isNull);
  });

  test(
    'markAllAsRead and registerDeviceToken forward success and failures',
    () async {
      expect(await repository.markAllAsRead(), isNull);
      expect(remote.markAllCalls, 1);

      expect(await repository.registerDeviceToken('token'), isNull);
      expect(remote.registeredTokens, ['token']);

      remote.markAllError = const ServerException('cannot mark');
      remote.registerError = const ServerException('cannot register');

      expect(
        await repository.markAllAsRead(),
        const ServerFailure('cannot mark'),
      );
      expect(
        await repository.registerDeviceToken('other'),
        const ServerFailure('cannot register'),
      );
    },
  );
}
