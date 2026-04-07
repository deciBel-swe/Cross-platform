import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/public_profile.dart';
import 'user_profile_model.dart';

part 'public_profile_model.freezed.dart';
part 'public_profile_model.g.dart';

/// DTO for the `GET /users/{userId}` public profile response.
///
/// Maps the backend response into a strongly-typed model including the
/// relationship flags `isFollowing` and `isFollowedBy` which indicate
/// the follow relationship between the current user and this profile.
@freezed
class PublicProfileModel with _$PublicProfileModel {
  const factory PublicProfileModel({
    required int id,
    required String username,
    @Default('FREE') String tier,
    PublicProfileDetailsModel? profile,
    SocialLinksModel? socialLinks,
    required PublicStatsModel stats,

    /// Whether the current logged-in user follows this profile's user.
    @Default(false) bool isFollowing,

    /// Whether this profile's user follows the current logged-in user.
    @Default(false) bool isFollowedBy,
  }) = _PublicProfileModel;

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PublicProfileModelFromJson(json);
}

/// Profile details nested inside the public profile response.
///
/// Contains bio, location, avatar, cover photo, and favorite genres.
@freezed
class PublicProfileDetailsModel with _$PublicProfileDetailsModel {
  const factory PublicProfileDetailsModel({
    String? bio,

    /// Capitalised key in the API response (e.g. `"Location": "Cairo"`).
    @JsonKey(name: 'Location') String? location,
    String? avatarUrl,
    String? coverPhotoUrl,
    @Default([]) List<String> favoriteGenres,
  }) = _PublicProfileDetailsModel;

  factory PublicProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$PublicProfileDetailsModelFromJson(json);
}

/// Follower / following / track counts for a public profile.
@freezed
class PublicStatsModel with _$PublicStatsModel {
  const factory PublicStatsModel({
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int trackCount,
  }) = _PublicStatsModel;

  factory PublicStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PublicStatsModelFromJson(json);
}

// ---------------------------------------------------------------------------
// Mappers: Model → Domain Entity
// ---------------------------------------------------------------------------

/// Converts a [PublicProfileModel] into its domain-layer [PublicProfile].
extension PublicProfileModelX on PublicProfileModel {
  PublicProfile toEntity() {
    return PublicProfile(
      id: id,
      username: username,
      tier: tier,
      profile: profile?.toEntity(),
      socialLinks: socialLinks?.toEntity(),
      stats: stats.toEntity(),
      isFollowing: isFollowing,
      isFollowedBy: isFollowedBy,
    );
  }
}

/// Converts a [PublicProfileDetailsModel] into its domain-layer equivalent.
extension PublicProfileDetailsModelX on PublicProfileDetailsModel {
  PublicProfileDetails toEntity() {
    return PublicProfileDetails(
      bio: bio,
      location: location,
      avatarUrl: avatarUrl,
      coverPhotoUrl: coverPhotoUrl,
      favoriteGenres: favoriteGenres,
    );
  }
}

/// Converts a [PublicStatsModel] into its domain-layer equivalent.
extension PublicStatsModelX on PublicStatsModel {
  PublicStats toEntity() {
    return PublicStats(
      followersCount: followersCount,
      followingCount: followingCount,
      trackCount: trackCount,
    );
  }
}
