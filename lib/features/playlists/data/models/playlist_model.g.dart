// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaylistModelImpl _$$PlaylistModelImplFromJson(
  Map<String, dynamic> json,
) => _$PlaylistModelImpl(
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
  tracks: json['trackSummaryDto'] == null
      ? const []
      : const PlaylistTracksConverter().fromJson(json['trackSummaryDto']),
  totalDurationSeconds: (json['totalDurationSeconds'] as num?)?.toInt() ?? 0,
  trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
  playlistSlug: json['playlistSlug'] as String?,
  firstTrackWaveformUrl: json['firstTrackWaveformUrl'] as String?,
  secretToken: json['secretToken'] as String?,
  access: json['access'] as String?,
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$PlaylistModelImplToJson(
  _$PlaylistModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'type': instance.type,
  'isPrivate': instance.isPrivate,
  'isLiked': instance.isLiked,
  'coverArtUrl': instance.coverArt,
  'owner': instance.owner,
  'trackSummaryDto': const PlaylistTracksConverter().toJson(instance.tracks),
  'totalDurationSeconds': instance.totalDurationSeconds,
  'trackCount': instance.trackCount,
  'playlistSlug': instance.playlistSlug,
  'firstTrackWaveformUrl': instance.firstTrackWaveformUrl,
  'secretToken': instance.secretToken,
  'access': instance.access,
  'genres': instance.genres,
  'createdAt': instance.createdAt?.toIso8601String(),
};
