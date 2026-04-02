// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_engager_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackEngagerModelImpl _$$TrackEngagerModelImplFromJson(
  Map<String, dynamic> json,
) => _$TrackEngagerModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  tier: json['tier'] as String,
  isFollowing: json['isFollowing'] as bool? ?? false,
);

Map<String, dynamic> _$$TrackEngagerModelImplToJson(
  _$TrackEngagerModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
  'tier': instance.tier,
  'isFollowing': instance.isFollowing,
};
