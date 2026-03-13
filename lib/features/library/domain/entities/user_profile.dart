
class UserProfile {
  final String name;
  final String location;
  final int followers;
  final int following;
  final String bio;

  const UserProfile({
    required this.name,
    required this.location,
    required this.followers,
    required this.following,
    required this.bio,
  });
}