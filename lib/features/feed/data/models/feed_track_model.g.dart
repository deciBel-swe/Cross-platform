// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedTrackModelImpl _$$FeedTrackModelImplFromJson(Map<String, dynamic> json) =>
    _$FeedTrackModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      artist: json['artist'] as Map<String, dynamic>,
      trackUrl: json['trackUrl'] as String?,
      trackPreviewUrl: json['trackPreviewUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      waveformUrl: json['waveformUrl'] as String?,
      genre: json['genre'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      access: json['access'] as String? ?? 'PLAYABLE',
      isReposted: json['isReposted'] as bool? ?? false,
      isLiked: json['isLiked'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      releaseDate: json['releaseDate'] as String?,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      completedPlayCount: (json['CompletedPlayCount'] as num?)?.toInt() ?? 0,
      repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      isPrivate: json['isPrivate'] as bool? ?? false,
      uploadDate: json['uploadDate'] as String?,
      description: json['description'] as String?,
      secretToken: json['secretToken'] as String?,
      trackDurationSeconds:
          (json['trackDurationSeconds'] as num?)?.toInt() ?? 0,
      isARepost: json['isARepost'] as bool? ?? false,
      repostedByUsername: json['repostedByUsername'] as String?,
      repostedByDisplayName: json['repostedByDisplayName'] as String?,
      repostedByAvatarUrl: json['repostedByAvatarUrl'] as String?,
      repostedAt: json['repostedAt'] as String?,
      feedItemType: json['feedItemType'] as String? ?? 'track_posted',
      playlistData: json['playlistData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FeedTrackModelImplToJson(
  _$FeedTrackModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'artist': instance.artist,
  'trackUrl': instance.trackUrl,
  'trackPreviewUrl': instance.trackPreviewUrl,
  'coverUrl': instance.coverUrl,
  'waveformUrl': instance.waveformUrl,
  'genre': instance.genre,
  'slug': instance.slug,
  'access': instance.access,
  'isReposted': instance.isReposted,
  'isLiked': instance.isLiked,
  'tags': instance.tags,
  'releaseDate': instance.releaseDate,
  'playCount': instance.playCount,
  'likeCount': instance.likeCount,
  'CompletedPlayCount': instance.completedPlayCount,
  'repostCount': instance.repostCount,
  'commentCount': instance.commentCount,
  'isPrivate': instance.isPrivate,
  'uploadDate': instance.uploadDate,
  'description': instance.description,
  'secretToken': instance.secretToken,
  'trackDurationSeconds': instance.trackDurationSeconds,
  'isARepost': instance.isARepost,
  'repostedByUsername': instance.repostedByUsername,
  'repostedByDisplayName': instance.repostedByDisplayName,
  'repostedByAvatarUrl': instance.repostedByAvatarUrl,
  'repostedAt': instance.repostedAt,
  'feedItemType': instance.feedItemType,
  'playlistData': instance.playlistData,
};
