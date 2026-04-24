import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_track.freezed.dart';

/// Domain entity representing a single track item in the user's activity feed.
///
/// When [isARepost] is true the item was reposted by someone other than the
/// original artist; the [repostedBy*] fields carry that person's info.
@freezed
class FeedTrack with _$FeedTrack {
  const factory FeedTrack({
    required int id,
    required String title,
    required int artistId,
    required String artistUsername,
    String? artistDisplayName,
    String? artistAvatarUrl,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    required String genre,
    required String access,
    required bool isReposted,
    required bool isLiked,
    required List<String> tags,
    required DateTime releaseDate,
    required int playCount,
    required int likeCount,
    required int repostCount,
    required int commentCount,
    required bool isPrivate,
    required DateTime uploadDate,
    String? description,
    String? secretToken,
    required int trackDurationSeconds,
    // Repost envelope
    @Default(false) bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    DateTime? repostedAt,
  }) = _FeedTrack;

  const FeedTrack._();

  /// Display name of the original artist.
  String get displayArtistName => artistDisplayName ?? artistUsername;

  /// Display name of whoever appears at the top of this feed card.
  /// - If it's a repost: the person who reposted it.
  /// - Otherwise: the original artist.
  String get feedActorName =>
      isARepost
          ? (repostedByDisplayName ?? repostedByUsername ?? artistUsername)
          : displayArtistName;

  /// "reposted" / "posted a track".
  String get feedAction => isARepost ? 'reposted' : 'posted a track';

  /// Timestamp relevant to the feed card (repost time or upload time).
  DateTime get feedTimestamp => isARepost ? (repostedAt ?? uploadDate) : uploadDate;

  /// Duration from [trackDurationSeconds].
  Duration get duration => Duration(seconds: trackDurationSeconds);
}
