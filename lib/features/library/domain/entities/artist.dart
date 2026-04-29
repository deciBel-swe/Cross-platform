class Artist {
  const Artist({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.location,
    this.bio,
  });

  final int id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? location;
  final String? bio;
}
