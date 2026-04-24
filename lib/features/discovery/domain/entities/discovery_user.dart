/// Lightweight user entity used across discovery, search, and stations.
class DiscoveryUser {
  const DiscoveryUser({
    required this.id,
    required this.username,
    this.displayName,
    this.isFollowing = false,
    this.followerCount = 0,
    this.trackCount = 0,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String? displayName;
  final bool isFollowing;
  final int followerCount;
  final int trackCount;
  final String? avatarUrl;
}
