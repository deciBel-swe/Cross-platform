// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockedUserModelImpl _$$BlockedUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$BlockedUserModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  tier: json['tier'] as String?,
  isFollowing: json['isFollowing'] as bool,
);

Map<String, dynamic> _$$BlockedUserModelImplToJson(
  _$BlockedUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
  'tier': instance.tier,
  'isFollowing': instance.isFollowing,
};
