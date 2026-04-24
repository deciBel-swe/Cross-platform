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
  }) = _FeedTrackModel;

  const FeedTrackModel._();

  factory FeedTrackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedTrackModelFromJson(_normalize(json));

  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    // If the object is an envelope (contains "track"), flatten it out.
    final trackData = json['track'] is Map<String, dynamic>
        ? json['track'] as Map<String, dynamic>
        : json;

    final flatMap = Map<String, dynamic>.from(trackData);

    // Extract repost data from envelope if present
    final repostedBy = json['repostedBy'];
    if (repostedBy is Map<String, dynamic>) {
      flatMap['isARepost'] = true;
      flatMap['repostedByUsername'] = repostedBy['username'];
      flatMap['repostedByDisplayName'] = repostedBy['displayName'];
      flatMap['repostedByAvatarUrl'] = repostedBy['avatarUrl'];
      flatMap['repostedAt'] = json['repostedAt'];
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
    if (flatMap['artist'] is! Map<String, dynamic>) {
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
      artistDisplayName: artistMap['displayName'] as String?,
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
      isPrivate: completedPlayCount > 0, // Fallback since isPrivate is missing from the old model
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
    );
  }
}
