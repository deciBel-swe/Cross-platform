// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationSettingsImpl(
  notifyOnFollow: json['notifyOnFollow'] as bool? ?? true,
  notifyOnLike: json['notifyOnLike'] as bool? ?? true,
  notifyOnRepost: json['notifyOnRepost'] as bool? ?? true,
  notifyOnComment: json['notifyOnComment'] as bool? ?? true,
  notifyOnDM: json['notifyOnDM'] as bool? ?? true,
);

Map<String, dynamic> _$$NotificationSettingsImplToJson(
  _$NotificationSettingsImpl instance,
) => <String, dynamic>{
  'notifyOnFollow': instance.notifyOnFollow,
  'notifyOnLike': instance.notifyOnLike,
  'notifyOnRepost': instance.notifyOnRepost,
  'notifyOnComment': instance.notifyOnComment,
  'notifyOnDM': instance.notifyOnDM,
};
