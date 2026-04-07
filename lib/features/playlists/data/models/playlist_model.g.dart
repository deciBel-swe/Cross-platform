// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnerModelImpl _$$OwnerModelImplFromJson(Map<String, dynamic> json) =>
    _$OwnerModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
    );

Map<String, dynamic> _$$OwnerModelImplToJson(_$OwnerModelImpl instance) =>
    <String, dynamic>{'id': instance.id, 'username': instance.username};

_$PlaylistModelImpl _$$PlaylistModelImplFromJson(Map<String, dynamic> json) =>
    _$PlaylistModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isLiked: json['isLiked'] as bool? ?? false,
      coverArt: json['CoverArt'] as String?,
      owner: json['owner'] == null
          ? null
          : OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      tracks:
          (json['tracks'] as List<dynamic>?)
              ?.map((e) => TrackModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PlaylistModelImplToJson(_$PlaylistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'isPrivate': instance.isPrivate,
      'isLiked': instance.isLiked,
      'CoverArt': instance.coverArt,
      'owner': instance.owner,
      'tracks': instance.tracks,
    };
