/// A user who has interacted with a track (liked or reposted).
class TrackEngager {
  const TrackEngager({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    required this.tier,
    required this.isFollowing,
  });

  final int id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String tier;
  final bool isFollowing;
}

enum EngagerType { likers, reposters }
