import 'package:freezed_annotation/freezed_annotation.dart';
import 'public_profile_social_links.dart';

// Use JsonValue so Freezed knows how to map the uppercase API response

enum UserTier {
  @JsonValue('FREE')
  free,
  @JsonValue('PRO')
  pro,
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.role,
    required this.email,
    required this.username,
    this.displayName,
    required this.emailVerified,
    required this.tier,
    required this.profileDetails,
    this.socialLinks,
    required this.privacySettings,
    required this.stats,
  });

  final int id;
  final String role;
  final String email;
  final String username;
  final String? displayName;
  final bool emailVerified;
  final UserTier tier;
  final UserProfileDetails profileDetails;
  final PublicProfileSocialLinks? socialLinks;
  final PrivacySettings privacySettings;
  final UserStats stats;
}

class UserProfileDetails {
  const UserProfileDetails({
    this.bio,
    this.city,
    this.country,
    this.profilePic,
    this.coverPic,
    required this.favoriteGenres,
  });

  final String? bio;
  final String? city;
  final String? country;
  final String? profilePic;
  final String? coverPic;
  final List<String> favoriteGenres;
}

class PrivacySettings {
  const PrivacySettings({required this.isPrivate, required this.showHistory});

  final bool isPrivate;
  final bool showHistory;
}

class UserStats {
  const UserStats({
    required this.followers,
    required this.following,
    required this.tracksCount,
  });

  final int followers;
  final int following;
  final int tracksCount;
}
