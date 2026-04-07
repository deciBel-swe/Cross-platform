// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowingUserModelImpl _$$FollowingUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$FollowingUserModelImpl(
  id: json['id'] == null ? 0 : _toInt(json['id']),
  username: json['username'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String?,
  tier: json['tier'] as String?,
  isFollowing: json['isFollowing'] as bool? ?? false,
);

Map<String, dynamic> _$$FollowingUserModelImplToJson(
  _$FollowingUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
  'tier': instance.tier,
  'isFollowing': instance.isFollowing,
};
