// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationUserModelImpl _$$NotificationUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationUserModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$$NotificationUserModelImplToJson(
  _$NotificationUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
};

_$NotificationResourceModelImpl _$$NotificationResourceModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationResourceModelImpl(
  resourceType: json['resourceType'] as String,
  resourceId: (json['resourceId'] as num).toInt(),
);

Map<String, dynamic> _$$NotificationResourceModelImplToJson(
  _$NotificationResourceModelImpl instance,
) => <String, dynamic>{
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
};

_$ActivityNotificationModelImpl _$$ActivityNotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityNotificationModelImpl(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  user: NotificationUserModel.fromJson(json['user'] as Map<String, dynamic>),
  resource: NotificationResourceModel.fromJson(
    json['resource'] as Map<String, dynamic>,
  ),
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ActivityNotificationModelImplToJson(
  _$ActivityNotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'user': instance.user,
  'resource': instance.resource,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};
