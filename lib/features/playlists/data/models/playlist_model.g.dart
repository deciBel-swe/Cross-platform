// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnerModelImpl _$$OwnerModelImplFromJson(Map<String, dynamic> json) =>
    _$OwnerModelImpl(
      id: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$OwnerModelImplToJson(_$OwnerModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };

_$PlaylistModelImpl _$$PlaylistModelImplFromJson(Map<String, dynamic> json) =>
    _$PlaylistModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isLiked: json['isLiked'] as bool? ?? false,
      coverArt: json['coverArtUrl'] as String?,
      owner: json['owner'] == null
          ? null
          : OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      tracks: json['tracks'] == null
          ? const []
          : const PlaylistTracksConverter().fromJson(json['tracks']),
      totalDurationSeconds:
          (json['totalDurationSeconds'] as num?)?.toInt() ?? 0,
      trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlaylistModelImplToJson(_$PlaylistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'isPrivate': instance.isPrivate,
      'isLiked': instance.isLiked,
      'coverArtUrl': instance.coverArt,
      'owner': instance.owner,
      'tracks': const PlaylistTracksConverter().toJson(instance.tracks),
      'totalDurationSeconds': instance.totalDurationSeconds,
      'trackCount': instance.trackCount,
    };
