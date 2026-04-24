// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackDtoImpl _$$TrackDtoImplFromJson(Map<String, dynamic> json) =>
    _$TrackDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      artist: json['artist'] as Map<String, dynamic>,
      coverUrl: json['coverUrl'] as String?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TrackDtoImplToJson(_$TrackDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'coverUrl': instance.coverUrl,
      'playCount': instance.playCount,
      'likeCount': instance.likeCount,
    };
