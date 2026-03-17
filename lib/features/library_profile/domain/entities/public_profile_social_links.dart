class PublicProfileSocialLinks {
  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? tiktok;
  final String? linkedin;
  final String? snapchat;
  final String? facebook;
  final String? website;
  final String? supportLink;

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

  static const List<String> displayPlatforms = [
    'instagram',
    'twitter',
    'youtube',
    'tiktok',
    'linkedin',
    'snapchat',
    'facebook',
    'website',
  ];

  static const List<String> allPlatforms = [
    'instagram',
    'twitter',
    'youtube',
    'tiktok',
    'linkedin',
    'snapchat',
    'facebook',
    'website',
    'supportLink',
  ];

  bool get isEmpty =>
      _isNullOrEmpty(instagram) &&
      _isNullOrEmpty(twitter) &&
      _isNullOrEmpty(youtube) &&
      _isNullOrEmpty(tiktok) &&
      _isNullOrEmpty(linkedin) &&
      _isNullOrEmpty(snapchat) &&
      _isNullOrEmpty(facebook) &&
      _isNullOrEmpty(website) &&
      _isNullOrEmpty(supportLink);

  bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  bool hasValueForPlatform(String platform) {
    final value = valueForPlatform(platform);
    return value != null && value.trim().isNotEmpty;
  }

  String? valueForPlatform(String platform) {
    switch (platform) {
      case 'instagram':
        return instagram;
      case 'twitter':
        return twitter;
      case 'youtube':
        return youtube;
      case 'tiktok':
        return tiktok;
      case 'linkedin':
        return linkedin;
      case 'snapchat':
        return snapchat;
      case 'facebook':
        return facebook;
      case 'website':
        return website;
      case 'supportLink':
        return supportLink;
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
      instagram:
          identical(instagram, _unset) ? this.instagram : instagram as String?,
      twitter: identical(twitter, _unset) ? this.twitter : twitter as String?,
      youtube: identical(youtube, _unset) ? this.youtube : youtube as String?,
      tiktok: identical(tiktok, _unset) ? this.tiktok : tiktok as String?,
      linkedin:
          identical(linkedin, _unset) ? this.linkedin : linkedin as String?,
      snapchat:
          identical(snapchat, _unset) ? this.snapchat : snapchat as String?,
      facebook:
          identical(facebook, _unset) ? this.facebook : facebook as String?,
      website: identical(website, _unset) ? this.website : website as String?,
      supportLink: identical(supportLink, _unset)
          ? this.supportLink
          : supportLink as String?,
    );
  }

  PublicProfileSocialLinks copyWithPlatform(String platform, String? value) {
    switch (platform) {
      case 'instagram':
        return copyWith(instagram: value);
      case 'twitter':
        return copyWith(twitter: value);
      case 'youtube':
        return copyWith(youtube: value);
      case 'tiktok':
        return copyWith(tiktok: value);
      case 'linkedin':
        return copyWith(linkedin: value);
      case 'snapchat':
        return copyWith(snapchat: value);
      case 'facebook':
        return copyWith(facebook: value);
      case 'website':
        return copyWith(website: value);
      case 'supportLink':
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