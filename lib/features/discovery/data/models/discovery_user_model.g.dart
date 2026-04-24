// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoveryUserModelImpl _$$DiscoveryUserModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscoveryUserModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  displayName: json['displayName'] as String?,
  isFollowing: json['isFollowing'] as bool? ?? false,
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$$DiscoveryUserModelImplToJson(
  _$DiscoveryUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'displayName': instance.displayName,
  'isFollowing': instance.isFollowing,
  'followerCount': instance.followerCount,
  'trackCount': instance.trackCount,
  'avatarUrl': instance.avatarUrl,
};
