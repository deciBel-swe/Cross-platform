// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackModelImpl _$$TrackModelImplFromJson(Map<String, dynamic> json) =>
    _$TrackModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      artist: ArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
      trackUrl: json['trackUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      waveformUrl: json['waveformUrl'] as String?,
      genre: json['genre'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      state: $enumDecode(_$TrackStatusModelEnumMap, json['state']),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TrackModelImplToJson(_$TrackModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'trackUrl': instance.trackUrl,
      'coverUrl': instance.coverUrl,
      'waveformUrl': instance.waveformUrl,
      'genre': instance.genre,
      'tags': instance.tags,
      'state': _$TrackStatusModelEnumMap[instance.state]!,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'playCount': instance.playCount,
      'likeCount': instance.likeCount,
      'repostCount': instance.repostCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TrackStatusModelEnumMap = {
  TrackStatusModel.processing: 'PROCESSING',
  TrackStatusModel.finished: 'FINISHED',
};
