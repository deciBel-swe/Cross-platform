class BlockedUserSummary {
  const BlockedUserSummary({
    required this.id,
    required this.username,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String? avatarUrl;

  BlockedUserSummary copyWith({int? id, String? username, String? avatarUrl}) {
    return BlockedUserSummary(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
