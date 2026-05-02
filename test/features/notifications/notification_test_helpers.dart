import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget notificationTestApp(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(body: child),
    ),
  );
}

ActivityNotification activityNotification({
  int id = 1,
  NotificationType type = NotificationType.follow,
  ResourceType resourceType = ResourceType.user,
  int resourceId = 2,
  bool isRead = false,
  DateTime? createdAt,
  String username = 'alice',
  String? displayName = 'Alice',
  String? avatarUrl,
}) {
  return ActivityNotification(
    id: id,
    type: type,
    user: NotificationUser(
      id: 9,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
    ),
    resource: NotificationResource(
      resourceType: resourceType,
      resourceId: resourceId,
    ),
    isRead: isRead,
    createdAt: createdAt ?? DateTime.now(),
  );
}

class FakeNotificationRepository implements INotificationRepository {
  FakeNotificationRepository({
    Map<int, List<ActivityNotification>>? pages,
    this.unreadCount = 3,
  }) : pages =
           pages ??
           {
             0: [activityNotification()],
           };

  final Map<int, List<ActivityNotification>> pages;
  int unreadCount;
  Failure? getNotificationsFailure;
  Failure? unreadCountFailure;
  Failure? markAllFailure;
  Failure? registerFailure;
  final registeredTokens = <String>[];
  var markAllCalls = 0;

  @override
  Future<(Failure?, List<ActivityNotification>?)> getNotifications(
    int page,
    int size,
  ) async {
    if (getNotificationsFailure != null) {
      return (getNotificationsFailure, null);
    }

    return (null, pages[page] ?? const <ActivityNotification>[]);
  }

  @override
  Future<(Failure?, int?)> getUnreadCount() async {
    if (unreadCountFailure != null) {
      return (unreadCountFailure, null);
    }

    return (null, unreadCount);
  }

  @override
  Future<Failure?> markAllAsRead() async {
    markAllCalls++;
    return markAllFailure;
  }

  @override
  Future<Failure?> registerDeviceToken(String fcmToken) async {
    registeredTokens.add(fcmToken);
    return registerFailure;
  }
}
