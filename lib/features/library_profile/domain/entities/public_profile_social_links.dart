class PublicProfileSocialLinks {
  const PublicProfileSocialLinks({
    this.instagram,
    this.twitter,
    this.website,
  });

  final String? instagram;
  final String? twitter;
  final String? website;

  bool get isEmpty =>
      _isNullOrEmpty(instagram) &&
      _isNullOrEmpty(twitter) &&
      _isNullOrEmpty(website);

  bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  PublicProfileSocialLinks copyWith({
    String? instagram,
    String? twitter,
    String? website,
  }) {
    return PublicProfileSocialLinks(
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      website: website ?? this.website,
    );
  }
}