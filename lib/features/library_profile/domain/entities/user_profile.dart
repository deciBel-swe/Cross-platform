import 'public_profile_social_links.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.bio,
    required this.tier,
    required this.followersCount,
    required this.followingCount,
    required this.tracksCount,
    required this.isVerified,
    // TODO: Map Privacy settings if needed
    // required Privacy privacy,
    this.socialLinks,
  });

  final int id;
  final String username;
  final String displayName;
  final String email;
  final String? bio;
  final String tier;
  final int followersCount;
  final int followingCount;
  final int tracksCount;
  final bool isVerified;
  final PublicProfileSocialLinks? socialLinks;
}
