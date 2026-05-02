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

  test('fromJson factories parse generated model payloads', () {
    final user = NotificationUserModel.fromJson({
      'id': 4,
      'username': 'sam',
      'displayName': 'Sam',
      'avatarUrl': 'avatar.png',
    });
    final resource = NotificationResourceModel.fromJson({
      'resourceType': 'PLAYLIST',
      'resourceId': 88,
    });
    final notification = ActivityNotificationModel.fromJson({
      'id': 5,
      'type': 'REPOST',
      'user': user.toJson(),
      'resource': resource.toJson(),
      'isRead': true,
      'createdAt': '2026-01-01T00:00:00.000Z',
    });

    final entity = notification.toEntity();

    expect(entity.type, NotificationType.repost);
    expect(entity.resource.resourceType, ResourceType.playlist);
    expect(entity.resource.resourceId, 88);
  });

  test(
    'api mapper supports sender/fromUser aliases and numeric timestamps',
    () {
      final senderModel = activityNotificationModelFromApiJson({
        'id': 1.0,
        'type': 'COMMENT',
        'sender': {'id': 6.0, 'displayName': 'Sender'},
        'trackId': 123.0,
        'read': true,
        'timestamp': 1710000000,
      }).toEntity();

      final fromUserModel = activityNotificationModelFromApiJson({
        'type': 'REPLY',
        'fromUser': {'id': '7', 'userName': 'reply_user'},
        'playlistId': '456',
        'time': 1710000000000,
      }).toEntity();

      expect(senderModel.type, NotificationType.comment);
      expect(senderModel.user.id, 6);
      expect(senderModel.resource.resourceId, 123);
      expect(senderModel.createdAt.millisecondsSinceEpoch, 1710000000000);

      expect(fromUserModel.type, NotificationType.reply);
      expect(fromUserModel.user.username, 'reply_user');
      expect(fromUserModel.resource.resourceId, 456);
    },
  );

  test('api mapper defaults missing resource data by notification type', () {
    final follow = activityNotificationModelFromApiJson({
      'type': 'FOLLOW',
      'user': {'id': 22, 'name': 'Follower'},
    }).toEntity();

    final like = activityNotificationModelFromApiJson({
      'type': 'LIKE',
      'user': {'id': 23, 'username': 'liker'},
    }).toEntity();

    final unknown = activityNotificationModelFromApiJson({
      'type': 'SOMETHING_ELSE',
      'user': <String, Object?>{},
    }).toEntity();

    expect(follow.resource.resourceType, ResourceType.user);
    expect(follow.resource.resourceId, 22);
    expect(like.resource.resourceType, ResourceType.track);
    expect(unknown.type, NotificationType.unknown);
    expect(unknown.resource.resourceType, ResourceType.unknown);
  });
}
