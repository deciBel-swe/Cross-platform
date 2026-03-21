class UserProfile {
  const UserProfile({
    required this.name,
    required this.location,
    required this.followers,
    required this.following,
    required this.bio,
    this.tier = UserTier.free,
  });

  final String name;
  final String location;
  final int followers;
  final int following;
  final String bio;
  final UserTier tier;
}

enum UserTier { free, pro }
