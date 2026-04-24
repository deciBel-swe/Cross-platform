import '../../presentation/utils/web_profile_platform_utils.dart';

class PublicProfileSocialLinks {
  const PublicProfileSocialLinks({
    this.instagram,
    this.twitter,
    this.youtube,
    this.tiktok,
    this.linkedin,
    this.snapchat,
    this.facebook,
    this.website,
    this.supportLink,
  });

  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? tiktok;
  final String? linkedin;
  final String? snapchat;
  final String? facebook;
  final String? website;
  final String? supportLink;

  // 🔥 IMPORTANT FIX: only visible platforms
  static List<String> get displayPlatforms =>
      WebProfilePlatformUtils.displayPlatforms;

  // keep allPlatforms consistent with utils
  static List<String> get allPlatforms => WebProfilePlatformUtils.allPlatforms;

  bool get isEmpty =>
      _isNullOrEmpty(instagram) &&
      _isNullOrEmpty(twitter) &&
      _isNullOrEmpty(website);

  bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  bool hasValueForPlatform(String platform) {
    final value = valueForPlatform(platform);
    return value != null && value.trim().isNotEmpty;
  }

  String? valueForPlatform(String platform) {
    switch (platform) {
      case WebProfilePlatformUtils.instagram:
        return instagram;
      case WebProfilePlatformUtils.twitter:
        return twitter;
      case WebProfilePlatformUtils.youtube:
        return youtube;
      case WebProfilePlatformUtils.tiktok:
        return tiktok;
      case WebProfilePlatformUtils.linkedin:
        return linkedin;
      case WebProfilePlatformUtils.snapchat:
        return snapchat;
      case WebProfilePlatformUtils.facebook:
        return facebook;
      case WebProfilePlatformUtils.website:
        return website;
      case WebProfilePlatformUtils.supportLink:
        return supportLink; // still exists but ignored
      default:
        return null;
    }
  }

  List<String> nonEmptyPlatforms({bool includeSupportLink = true}) {
    final platforms = includeSupportLink ? allPlatforms : displayPlatforms;
    return platforms.where(hasValueForPlatform).toList();
  }

  PublicProfileSocialLinks copyWith({
    Object? instagram = _unset,
    Object? twitter = _unset,
    Object? youtube = _unset,
    Object? tiktok = _unset,
    Object? linkedin = _unset,
    Object? snapchat = _unset,
    Object? facebook = _unset,
    Object? website = _unset,
    Object? supportLink = _unset,
  }) {
    return PublicProfileSocialLinks(
      instagram: identical(instagram, _unset)
          ? this.instagram
          : instagram as String?,
      twitter: identical(twitter, _unset) ? this.twitter : twitter as String?,
      youtube: identical(youtube, _unset) ? this.youtube : youtube as String?,
      tiktok: identical(tiktok, _unset) ? this.tiktok : tiktok as String?,
      linkedin: identical(linkedin, _unset)
          ? this.linkedin
          : linkedin as String?,
      snapchat: identical(snapchat, _unset)
          ? this.snapchat
          : snapchat as String?,
      facebook: identical(facebook, _unset)
          ? this.facebook
          : facebook as String?,
      website: identical(website, _unset) ? this.website : website as String?,
      supportLink: identical(supportLink, _unset)
          ? this.supportLink
          : supportLink as String?,
    );
  }

  PublicProfileSocialLinks copyWithPlatform(String platform, String? value) {
    switch (platform) {
      case WebProfilePlatformUtils.instagram:
        return copyWith(instagram: value);
      case WebProfilePlatformUtils.twitter:
        return copyWith(twitter: value);
      case WebProfilePlatformUtils.youtube:
        return copyWith(youtube: value);
      case WebProfilePlatformUtils.tiktok:
        return copyWith(tiktok: value);
      case WebProfilePlatformUtils.linkedin:
        return copyWith(linkedin: value);
      case WebProfilePlatformUtils.snapchat:
        return copyWith(snapchat: value);
      case WebProfilePlatformUtils.facebook:
        return copyWith(facebook: value);
      case WebProfilePlatformUtils.website:
        return copyWith(website: value);
      case WebProfilePlatformUtils.supportLink:
        return copyWith(supportLink: value);
      default:
        return this;
    }
  }

  PublicProfileSocialLinks clearField(String platform) {
    return copyWithPlatform(platform, '');
  }

  static const Object _unset = Object();
}
