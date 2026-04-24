// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoveryPlaylistModelImpl _$$DiscoveryPlaylistModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscoveryPlaylistModelImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  owner: DiscoveryUserModel.fromJson(json['owner'] as Map<String, dynamic>),
  type: json['type'] as String? ?? 'PLAYLIST',
  isLiked: json['isLiked'] as bool? ?? false,
  description: json['description'] as String?,
  isPrivate: json['isPrivate'] as bool? ?? false,
  coverArtUrl: json['coverArtUrl'] as String?,
  playlistSlug: json['playlistSlug'] as String?,
  totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt() ?? 0,
  trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$DiscoveryPlaylistModelImplToJson(
  _$DiscoveryPlaylistModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'owner': instance.owner,
  'type': instance.type,
  'isLiked': instance.isLiked,
  'description': instance.description,
  'isPrivate': instance.isPrivate,
  'coverArtUrl': instance.coverArtUrl,
  'playlistSlug': instance.playlistSlug,
  'totalDurationSeconds': instance.totalDurationSeconds,
  'trackCount': instance.trackCount,
  'genres': instance.genres,
  'createdAt': instance.createdAt?.toIso8601String(),
};
