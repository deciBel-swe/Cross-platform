class BlockedUser {
  const BlockedUser({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.tier,
    required this.isFollowing,
  });

  final int id;
  final String username;
  final String? avatarUrl;
  final String? tier;
  final bool isFollowing;
}