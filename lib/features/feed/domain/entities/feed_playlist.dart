/// Entity representing a playlist in the activity feed.
class FeedPlaylist {
  const FeedPlaylist({
    required this.id,
    required this.title,
    this.coverArtUrl,
    this.playlistSlug,
    required this.isLiked,
    required this.isPrivate,
    required this.description,
    required this.trackCount,
    required this.totalDurationSeconds,
    required this.genres,
    required this.createdAt,
    required this.owner,
  });

  final int id;
  final String title;
  final String? coverArtUrl;
  final String? playlistSlug;
  final bool isLiked;
  final bool isPrivate;
  final String description;
  final int trackCount;
  final int totalDurationSeconds;
  final List<String> genres;
  final DateTime createdAt;
  final FeedPlaylistOwner owner;
}

/// Owner of a playlist in the feed.
class FeedPlaylistOwner {
  const FeedPlaylistOwner({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    required this.followerCount,
    required this.trackCount,
  });

  final int id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final int followerCount;
  final int trackCount;
}
