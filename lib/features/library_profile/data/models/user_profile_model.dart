import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required int id,
    @JsonKey(name: 'Role') required String role,
    required String email,
    required String username,
    required bool emailVerified,
    required UserTier tier,
    @JsonKey(name: 'profile') required ProfileDetailsModel profileDetails,
    SocialLinksModel? socialLinks,
    required PrivacySettingsModel privacySettings,
    required UserStatsModel stats,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class ProfileDetailsModel with _$ProfileDetailsModel {
  const factory ProfileDetailsModel({
    String? bio,
    String? city,
    String? country,
    String? profilePic,
    String? coverPic,
    @Default([]) List<String> favoriteGenres,
  }) = _ProfileDetailsModel;

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsModelFromJson(json);
}

@freezed
class PrivacySettingsModel with _$PrivacySettingsModel {
  const factory PrivacySettingsModel({
    required bool isPrivate,
    required bool showHistory,
  }) = _PrivacySettingsModel;

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsModelFromJson(json);
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    required int followers,
    required int following,
    required int tracksCount,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}

@freezed
class SocialLinksModel with _$SocialLinksModel {
  const factory SocialLinksModel({
    String? instagram,
    String? twitter,
    @JsonKey(name: 'x') String? x,
    String? youtube,
    String? tiktok,
    String? linkedin,
    String? snapchat,
    String? facebook,
    String? website,
    String? supportLink,
  }) = _SocialLinksModel;

  factory SocialLinksModel.fromJson(Map<String, dynamic> json) =>
      _$SocialLinksModelFromJson(json);
}

// --- Mappers ---

extension UserProfileModelX on UserProfileModel {
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      role: role,
      email: email,
      username: username,
      emailVerified: emailVerified,
      tier: tier,
      profileDetails: profileDetails.toEntity(),
      privacySettings: privacySettings.toEntity(),
      stats: stats.toEntity(),
      socialLinks: socialLinks?.toEntity(),
    );
  }
}

extension ProfileDetailsModelX on ProfileDetailsModel {
  UserProfileDetails toEntity() {
    return UserProfileDetails(
      bio: bio,
      city: city,
      country: country,
      profilePic: profilePic,
      coverPic: coverPic,
      favoriteGenres: favoriteGenres,
    );
  }
}

extension PrivacySettingsModelX on PrivacySettingsModel {
  PrivacySettings toEntity() {
    return PrivacySettings(
      isPrivate: isPrivate,
      showHistory: showHistory,
    );
  }
}

extension UserStatsModelX on UserStatsModel {
  UserStats toEntity() {
    return UserStats(
      followers: followers,
      following: following,
      tracksCount: tracksCount,
    );
  }
}

extension SocialLinksModelX on SocialLinksModel {
  PublicProfileSocialLinks toEntity() {
    return PublicProfileSocialLinks(
      instagram: instagram,
      twitter: twitter ?? x, // map 'x' backwards compatibility
      youtube: youtube,
      tiktok: tiktok,
      linkedin: linkedin,
      snapchat: snapchat,
      facebook: facebook,
      website: website,
      supportLink: supportLink,
    );
  }
}
extension PublicProfileSocialLinksX on PublicProfileSocialLinks {
  SocialLinksModel toModel() {
    return SocialLinksModel(
      instagram: instagram,

      twitter: twitter,

      x: twitter,

      youtube: youtube,

      tiktok: tiktok,

      linkedin: linkedin,

      snapchat: snapchat,

      facebook: facebook,

      website: website,

      supportLink: supportLink,
    );
  }
}
