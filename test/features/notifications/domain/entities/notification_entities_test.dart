import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:decibel/features/notifications/domain/entities/notification_actor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notification entities preserve constructor values', () {
    final actor = const NotificationActor(id: 1, username: 'actor');
    final user = const NotificationUser(
      id: 2,
      username: 'alice',
      displayName: 'Alice',
      avatarUrl: 'avatar.png',
    );
    final resource = const NotificationResource(
      resourceType: ResourceType.track,
      resourceId: 42,
    );
    final notification = ActivityNotification(
      id: 99,
      type: NotificationType.comment,
      user: user,
      resource: resource,
      isRead: true,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    expect(actor.username, 'actor');
    expect(notification.user.displayName, 'Alice');
    expect(notification.resource.resourceType, ResourceType.track);
    expect(notification.isRead, isTrue);
  });
}
