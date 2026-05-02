// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoveryTrackModelImpl _$$DiscoveryTrackModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscoveryTrackModelImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  artist: DiscoveryUserModel.fromJson(json['artist'] as Map<String, dynamic>),
  slug: json['slug'] as String?,
  trackUrl: json['trackUrl'] as String?,
  trackPreviewUrl: json['trackPreviewUrl'] as String?,
  coverUrl: json['coverUrl'] as String?,
  waveformUrl: json['waveformUrl'] as String?,
  genre: json['genre'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  availability: json['availability'] as String?,
  isLiked: json['isLiked'] as bool? ?? false,
  isReposted: json['isReposted'] as bool? ?? false,
  playCount: (json['playCount'] as num?)?.toInt() ?? 0,
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  releaseDate: json['releaseDate'] == null
      ? null
      : DateTime.parse(json['releaseDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
  secretToken: json['secretToken'] as String?,
);

Map<String, dynamic> _$$DiscoveryTrackModelImplToJson(
  _$DiscoveryTrackModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'artist': instance.artist,
  'slug': instance.slug,
  'trackUrl': instance.trackUrl,
  'trackPreviewUrl': instance.trackPreviewUrl,
  'coverUrl': instance.coverUrl,
  'waveformUrl': instance.waveformUrl,
  'genre': instance.genre,
  'tags': instance.tags,
  'availability': instance.availability,
  'isLiked': instance.isLiked,
  'isReposted': instance.isReposted,
  'playCount': instance.playCount,
  'likeCount': instance.likeCount,
  'repostCount': instance.repostCount,
  'commentCount': instance.commentCount,
  'releaseDate': instance.releaseDate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'description': instance.description,
  'secretToken': instance.secretToken,
};
