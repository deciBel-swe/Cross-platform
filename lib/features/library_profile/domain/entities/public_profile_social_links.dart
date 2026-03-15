class PublicProfileSocialLinks {
  final String? instagram;
  final String? twitter;
  final String? youtube;
  final String? tiktok;
  final String? linkedin;
  final String? snapchat;
  final String? facebook;
  final String? website;

  const PublicProfileSocialLinks({
    this.instagram,
    this.twitter,
    this.youtube,
    this.tiktok,
    this.linkedin,
    this.snapchat,
    this.facebook,
    this.website,
  });

  bool get isEmpty =>
      _isNullOrEmpty(instagram) &&
      _isNullOrEmpty(twitter) &&
      _isNullOrEmpty(youtube) &&
      _isNullOrEmpty(tiktok) &&
      _isNullOrEmpty(linkedin) &&
      _isNullOrEmpty(snapchat) &&
      _isNullOrEmpty(facebook) &&
      _isNullOrEmpty(website);

  bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  PublicProfileSocialLinks copyWith({
    String? instagram,
    String? twitter,
    String? youtube,
    String? tiktok,
    String? linkedin,
    String? snapchat,
    String? facebook,
    String? website,
  }) {
    return PublicProfileSocialLinks(
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      youtube: youtube ?? this.youtube,
      tiktok: tiktok ?? this.tiktok,
      linkedin: linkedin ?? this.linkedin,
      snapchat: snapchat ?? this.snapchat,
      facebook: facebook ?? this.facebook,
      website: website ?? this.website,
    );
  }
}