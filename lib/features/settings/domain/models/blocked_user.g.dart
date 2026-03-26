// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockedUserImpl _$$BlockedUserImplFromJson(Map<String, dynamic> json) =>
    _$BlockedUserImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      tier: json['tier'] as String?,
      isFollowing: json['isFollowing'] as bool? ?? false,
    );

Map<String, dynamic> _$$BlockedUserImplToJson(_$BlockedUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'tier': instance.tier,
      'isFollowing': instance.isFollowing,
    };
