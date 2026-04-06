import 'public_profile_social_links.dart';

/// Domain entity representing another user's public profile.
///
/// Returned by `GET /users/{userId}`. Unlike [UserProfile] (the logged-in
/// user's own profile), this entity includes relationship flags that describe
/// the follow connection between the current user and this profile's owner.
class PublicProfile {
  const PublicProfile({
    required this.id,
    required this.username,
    required this.tier,
    this.profile,
    this.socialLinks,
    required this.stats,
    required this.isFollowing,
    required this.isFollowedBy,
  });

  /// Unique user identifier.
  final int id;

  /// Display name of the user.
  final String username;

  /// Subscription tier (e.g. `'FREE'`, `'PRO'`).
  final String tier;

  /// Optional profile details (bio, location, avatar, cover photo, genres).
  final PublicProfileDetails? profile;

  /// Optional social links (Instagram, Twitter, website, etc.).
  final PublicProfileSocialLinks? socialLinks;

  /// Follower / following / track counts.
  final PublicStats stats;

  /// Whether the current logged-in user follows this user.
  final bool isFollowing;

  /// Whether this user follows the current logged-in user.
  final bool isFollowedBy;
}

/// Profile details shown on a public profile page.
class PublicProfileDetails {
  const PublicProfileDetails({
    this.bio,
    this.location,
    this.avatarUrl,
    this.coverPhotoUrl,
    required this.favoriteGenres,
  });

  final String? bio;
  final String? location;
  final String? avatarUrl;
  final String? coverPhotoUrl;
  final List<String> favoriteGenres;
}

/// Aggregate statistics for a public profile.
class PublicStats {
  const PublicStats({
    required this.followersCount,
    required this.followingCount,
    required this.trackCount,
  });

  final int followersCount;
  final int followingCount;
  final int trackCount;
}
