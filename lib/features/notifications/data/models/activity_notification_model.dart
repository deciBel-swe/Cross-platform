import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/activity_notification.dart';

part 'activity_notification_model.freezed.dart';
part 'activity_notification_model.g.dart';

// SUB-MODELS

@freezed
class NotificationUserModel with _$NotificationUserModel {
  const factory NotificationUserModel({
    required int id,
    required String username,
    String? displayName,
    String? avatarUrl,
  }) = _NotificationUserModel;

  factory NotificationUserModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationUserModelFromJson(json);
}

@freezed
class NotificationResourceModel with _$NotificationResourceModel {
  const factory NotificationResourceModel({
    required String resourceType,
    required int resourceId,
  }) = _NotificationResourceModel;

  factory NotificationResourceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResourceModelFromJson(json);
}

// MAIN MODEL

@freezed
class ActivityNotificationModel with _$ActivityNotificationModel {
  const factory ActivityNotificationModel({
    required int id,
    required String type,
    required NotificationUserModel user,
    required NotificationResourceModel resource,
    required bool isRead,
    required DateTime createdAt,
  }) = _ActivityNotificationModel;

  factory ActivityNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityNotificationModelFromJson(json);
}

// MAPPERS

extension ActivityNotificationModelX on ActivityNotificationModel {
  ActivityNotification toEntity() {
    return ActivityNotification(
      id: id,
      type: _parseNotificationType(type),
      user: NotificationUser(
        id: user.id,
        username: user.username,
        displayName: user.displayName,
        avatarUrl: user.avatarUrl,
      ),
      resource: NotificationResource(
        resourceType: _parseResourceType(resource.resourceType),
        resourceId: resource.resourceId,
      ),
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  NotificationType _parseNotificationType(String type) {
    switch (type.toUpperCase()) {
      case 'FOLLOW': return NotificationType.follow;
      case 'LIKE': return NotificationType.like;
      case 'REPOST': return NotificationType.repost;
      case 'COMMENT': return NotificationType.comment;
      case 'REPLY': return NotificationType.reply;
      default: return NotificationType.unknown;
    }
  }

  ResourceType _parseResourceType(String type) {
    switch (type.toUpperCase()) {
      case 'USER': return ResourceType.user;
      case 'TRACK': return ResourceType.track;
      case 'PLAYLIST': return ResourceType.playlist;
      default: return ResourceType.unknown;
    }
  }
}