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

  PublicProfileSocialLinks clearField(String platform) {
    switch (platform) {
      case 'instagram':
        return copyWith(instagram: '');
      case 'twitter':
        return copyWith(twitter: '');
      case 'youtube':
        return copyWith(youtube: '');
      case 'tiktok':
        return copyWith(tiktok: '');
      case 'linkedin':
        return copyWith(linkedin: '');
      case 'snapchat':
        return copyWith(snapchat: '');
      case 'facebook':
        return copyWith(facebook: '');
      case 'website':
        return copyWith(website: '');
      case 'supportLink':
        return copyWith(supportLink: '');
      default:
        return this;
    }
  }

  static const Object _unset = Object();
}