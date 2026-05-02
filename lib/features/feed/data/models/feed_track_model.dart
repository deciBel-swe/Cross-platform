import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/feed_track.dart';

part 'feed_track_model.freezed.dart';
part 'feed_track_model.g.dart';

@freezed
class FeedTrackModel with _$FeedTrackModel {
  @JsonSerializable(explicitToJson: true)
  const factory FeedTrackModel({
    required int id,
    required String title,
    required Map<String, dynamic> artist,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    @Default('') String genre,
    @Default('') String slug,
    @Default('PLAYABLE') String access,
    @Default(false) bool isReposted,
    @Default(false) bool isLiked,
    @Default(<String>[]) List<String> tags,
    String? releaseDate,
    @Default(0) int playCount,
    @Default(0) int likeCount,
    @JsonKey(name: 'CompletedPlayCount') @Default(0) int completedPlayCount,
    @Default(0) int repostCount,
    @Default(0) int commentCount,
    @Default(false) bool isPrivate,
    String? uploadDate,
    String? description,
    String? secretToken,
    @Default(0) int trackDurationSeconds,
    // Repost envelope fields
    @Default(false) bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    String? repostedAt,
    // Feed item type (stored as string to avoid enum issues in freezed)
    @Default('track_posted') String feedItemType,
    // Playlist data for PLAYLIST_POSTED type
    Map<String, dynamic>? playlistData,
  }) = _FeedTrackModel;

  const FeedTrackModel._();

  factory FeedTrackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedTrackModelFromJson(_normalize(json));

  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    // Check if this is a playlist post
    final type = (json['type'] ?? json['feedItemType'])?.toString().toUpperCase();
    final isPlaylistPost = type == 'PLAYLIST_POSTED' || 
                          type == 'PLAYLIST_CREATED' || 
                          json['playlistData'] != null ||
                          (json['resource'] is Map && (json['resource'] as Map).containsKey('playlist'));

    if (isPlaylistPost) {
      // Handle playlist post - extract playlist data
      final resource = json['resource'] as Map<String, dynamic>?;
      final playlist = resource != null ? resource['playlist'] as Map<String, dynamic>? : json['playlistData'] as Map<String, dynamic>?;
      
      if (playlist != null) {
        final owner = playlist['owner'] as Map<String, dynamic>?;
        if (owner != null) {
          owner['displayName'] ??= owner['display_name'];
        }
        return {
          'id': playlist['id'] as int? ?? 0,
          'title': playlist['title'] as String? ?? '',
          'artist': owner ?? <String, dynamic>{'id': 0, 'username': 'Unknown'},
          'feedItemType': 'playlist_posted',
          'playlistData': playlist,
          'coverUrl': playlist['coverArtUrl'] as String? ?? playlist['coverUrl'] as String?,
          'isLiked': playlist['isLiked'] as bool? ?? false,
          'trackCount': playlist['trackCount'] as int? ?? 0,
        };
      }
    }

    // Feed responses wrap tracks in resource.track; station responses may use
    // either track or a raw track object.
    final resource = json['resource'];
    final resourceTrack = resource is Map<String, dynamic>
        ? resource['track']
        : null;
    final directTrack = json['track'];

    final Map<String, dynamic> trackData;
    if (resourceTrack is Map<String, dynamic>) {
      trackData = resourceTrack;
    } else if (directTrack is Map<String, dynamic>) {
      trackData = directTrack;
    } else {
      trackData = json;
    }

    final flatMap = Map<String, dynamic>.from(trackData);

    // Extract repost data from envelope if present and type is repost
    final isRepostEvent = type == 'TRACK_REPOSTED' || type == 'PLAYLIST_REPOSTED';
    final repostedBy = json['repostedBy'];
    
    if (isRepostEvent && repostedBy is Map<String, dynamic>) {
      flatMap['isARepost'] = true;
      flatMap['repostedByUsername'] = repostedBy['username'];
      flatMap['repostedByDisplayName'] = repostedBy['displayName'] ?? repostedBy['display_name'];
      flatMap['repostedByAvatarUrl'] = repostedBy['avatarUrl'];
      flatMap['repostedAt'] = json['repostedAt'];
    }

    // Normalize access level
    flatMap['access'] = (flatMap['access'] ?? 'PLAYABLE').toString().toUpperCase();



    // Normalize isPrivate
    if (flatMap['isPrivate'] == null) {
      flatMap['isPrivate'] = flatMap['is_private'] ?? false;
    }

    // Fallback for preview URL if the backend uses previewUrl or preview_url
    if (flatMap['trackPreviewUrl'] == null) {
      final preview = flatMap['previewUrl'] ?? flatMap['preview_url'];
      if (preview != null) {
        flatMap['trackPreviewUrl'] = preview;
      }
    }

    // Determine feed item type
    final String? itemType = (json['type'] ?? flatMap['type'])?.toString().toUpperCase();
    if (itemType == 'TRACK_REPOSTED' || itemType == 'PLAYLIST_REPOSTED' || itemType == 'REPOST') {
      flatMap['feedItemType'] = 'repost';
    } else if (itemType == 'PLAYLIST_POSTED' || itemType == 'PLAYLIST_CREATED' || flatMap['playlistData'] != null) {
      flatMap['feedItemType'] = 'playlist_posted';
    } else {
      flatMap['feedItemType'] = 'track_posted';
    }

    // Guarantee required int id is never null (generated code does hard cast)
    final rawId = flatMap['id'];
    if (rawId == null) {
      flatMap['id'] = 0;
    } else if (rawId is! num) {
      flatMap['id'] = int.tryParse(rawId.toString()) ?? 0;
    }

    // Guarantee required String title is never null
    if (flatMap['title'] == null) {
      flatMap['title'] = '';
    }

    // Guarantee required Map artist is always a valid map
    final rawArtist = flatMap['artist'];
    if (rawArtist is Map<Object?, Object?>) {
      flatMap['artist'] = Map<String, dynamic>.from(rawArtist);
    } else {
      flatMap['artist'] = <String, dynamic>{'id': 0, 'username': 'Unknown'};
    }

    // Normalize tags: ensure it's always a List<String>
    final rawTags = flatMap['tags'];
    if (rawTags is List) {
      flatMap['tags'] = rawTags.whereType<String>().toList();
    } else {
      flatMap['tags'] = <String>[];
    }

    return flatMap;
  }

  FeedTrack toEntity() {
    final artistMap = artist;
    return FeedTrack(
      id: id,
      title: title,
      artistId: (artistMap['id'] as num?)?.toInt() ?? 0,
      artistUsername: artistMap['username'] as String? ?? 'Unknown',
      artistDisplayName: artistMap['displayName'] as String? ?? artistMap['display_name'] as String?,
      artistAvatarUrl: artistMap['avatarUrl'] as String?,
      trackUrl: trackUrl,
      trackPreviewUrl: trackPreviewUrl,
      coverUrl: coverUrl,
      waveformUrl: waveformUrl,
      genre: genre,
      access: access,
      isReposted: isReposted,
      isLiked: isLiked,
      tags: tags,
      releaseDate: releaseDate != null
          ? DateTime.tryParse(releaseDate!) ?? DateTime.now()
          : DateTime.now(),
      playCount: playCount,
      likeCount: likeCount,
      repostCount: repostCount,
      commentCount: commentCount,
      isPrivate: isPrivate,
      uploadDate: uploadDate != null
          ? DateTime.tryParse(uploadDate!) ?? DateTime.now()
          : DateTime.now(),
      description: description,
      secretToken: secretToken,
      trackDurationSeconds: trackDurationSeconds,
      isARepost: isARepost,
      repostedByUsername: repostedByUsername,
      repostedByDisplayName: repostedByDisplayName,
      repostedByAvatarUrl: repostedByAvatarUrl,
      repostedAt: repostedAt != null ? DateTime.tryParse(repostedAt!) : null,
      feedItemType: feedItemType,
      playlistData: playlistData,
    );
  }
}
