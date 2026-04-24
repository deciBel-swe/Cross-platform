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

ActivityNotificationModel activityNotificationModelFromApiJson(
  Map<String, Object?> json,
) {
  final userJson = _asObjectMap(json['user']) ??
      _asObjectMap(json['actor']) ??
      _asObjectMap(json['sender']) ??
      _asObjectMap(json['fromUser']) ??
      const <String, Object?>{};
  final resourceJson =
      _asObjectMap(json['resource']) ?? const <String, Object?>{};
  final type = _asString(json['type'] ?? json['notificationType']) ?? 'UNKNOWN';
  final createdAt = _asDateTime(
        json['createdAt'] ??
            json['created_at'] ??
            json['timestamp'] ??
            json['time'],
      ) ??
      DateTime.now();

  return ActivityNotificationModel(
    id: _asInt(json['id'] ?? json['notificationId']) ?? 0,
    type: type,
    user: NotificationUserModel(
      id: _asInt(userJson['id'] ?? userJson['userId']) ?? 0,
      username: _asString(
            userJson['username'] ??
                userJson['userName'] ??
                userJson['displayName'] ??
                userJson['name'],
          ) ??
          'unknown',
      displayName: _asString(
        userJson['displayName'] ?? userJson['name'] ?? userJson['username'],
      ),
      avatarUrl: _asString(
        userJson['avatarUrl'] ?? userJson['avatar'] ?? userJson['profileImage'],
      ),
    ),
    resource: NotificationResourceModel(
      resourceType: _asString(
            resourceJson['resourceType'] ??
                resourceJson['type'] ??
                json['resourceType'] ??
                json['targetType'],
          ) ??
          _defaultResourceType(type),
      resourceId: _asInt(
            resourceJson['resourceId'] ??
                resourceJson['id'] ??
                json['resourceId'] ??
                json['targetId'] ??
                json['trackId'] ??
                json['playlistId'] ??
                json['userId'],
          ) ??
          _asInt(userJson['id']) ??
          0,
    ),
    isRead: _asBool(json['isRead'] ?? json['read']) ?? false,
    createdAt: createdAt,
  );
}

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
      case 'FOLLOW':
        return NotificationType.follow;
      case 'LIKE':
        return NotificationType.like;
      case 'REPOST':
        return NotificationType.repost;
      case 'COMMENT':
        return NotificationType.comment;
      case 'REPLY':
        return NotificationType.reply;
      default:
        return NotificationType.unknown;
    }
  }

  ResourceType _parseResourceType(String type) {
    switch (type.toUpperCase()) {
      case 'USER':
        return ResourceType.user;
      case 'TRACK':
        return ResourceType.track;
      case 'PLAYLIST':
        return ResourceType.playlist;
      default:
        return ResourceType.unknown;
    }
  }
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

String? _asString(Object? value) {
  if (value == null) {
    return null;
  }

  final stringValue = value.toString().trim();
  if (stringValue.isEmpty) {
    return null;
  }

  return stringValue;
}

int? _asInt(Object? value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}

bool? _asBool(Object? value) {
  if (value is bool) {
    return value;
  }

  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true') {
      return true;
    }
    if (normalized == 'false') {
      return false;
    }
  }

  return null;
}

DateTime? _asDateTime(Object? value) {
  if (value is DateTime) {
    return value;
  }

  if (value is num) {
    final milliseconds = value > 1000000000000 ? value.toInt() : value * 1000;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
  }

  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}

String _defaultResourceType(String notificationType) {
  switch (notificationType.toUpperCase()) {
    case 'FOLLOW':
      return 'USER';
    case 'LIKE':
    case 'REPOST':
    case 'COMMENT':
    case 'REPLY':
      return 'TRACK';
    default:
      return 'UNKNOWN';
  }
}
