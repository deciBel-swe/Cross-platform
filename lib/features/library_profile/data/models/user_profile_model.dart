import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required int id,
    required String username,
    required String displayName,
    required String email,
    String? bio,
    required String tier,
    required int followersCount,
    required int followingCount,
    required int tracksCount,
    required bool isVerified,
    SocialLinksModel? socialLinks,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
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

extension UserProfileModelX on UserProfileModel {
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      username: username,
      displayName: displayName,
      email: email,
      bio: bio,
      tier: tier,
      followersCount: followersCount,
      followingCount: followingCount,
      tracksCount: tracksCount,
      isVerified: isVerified,
      socialLinks: socialLinks?.toEntity(),
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
