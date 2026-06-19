import 'package:decibel/features/notifications/data/models/activity_notification_model.dart';
import 'package:decibel/features/notifications/domain/entities/activity_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toEntity maps REPLY notifications to NotificationType.reply', () {
    final model = ActivityNotificationModel(
      id: 1,
      type: 'REPLY',
      user: const NotificationUserModel(
        id: 9,
        username: 'alice',
        displayName: 'Alice',
      ),
      resource: const NotificationResourceModel(
        resourceType: 'TRACK',
        resourceId: 42,
      ),
      isRead: false,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    final entity = model.toEntity();

    expect(entity.type, NotificationType.reply);
  });

  test(
    'activityNotificationModelFromApiJson supports actor style payloads',
    () {
      final model = activityNotificationModelFromApiJson({
        'notificationId': '12',
        'notificationType': 'LIKE',
        'actor': {'userId': '7', 'username': 'mona', 'name': 'Mona'},
        'resourceType': 'TRACK',
        'resourceId': '44',
        'read': 'false',
        'created_at': '2026-01-01T00:00:00Z',
      });

      final entity = model.toEntity();

      expect(entity.id, 12);
      expect(entity.type, NotificationType.like);
      expect(entity.user.displayName, 'Mona');
      expect(entity.resource.resourceId, 44);
      expect(entity.isRead, isFalse);
    },
  );

  test('activityNotificationModelFromApiJson maps user avatarUrl', () {
    const avatarUrl =
        'https://decibelblob.blob.core.windows.net/uploads/avatars/avatar.png';

    final model = activityNotificationModelFromApiJson({
      'id': 124,
      'type': 'FOLLOW',
      'user': {
        'id': 79,
        'username': 'abdo23',
        'displayName': 'abdalrahman Essam',
        'avatarUrl': avatarUrl,
      },
      'resource': {'resourceType': 'USER', 'resourceId': 79},
      'isRead': true,
      'createdAt': '2026-04-24T12:07:31.440672',
    });

    final entity = model.toEntity();

    expect(entity.user.avatarUrl, avatarUrl);
  });
}
