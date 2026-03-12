class PublicProfileSocialLinks {
  final String? instagram;
  final String? twitter;
  final String? website;

  const PublicProfileSocialLinks({
    this.instagram,
    this.twitter,
    this.website,
  });

  bool get isEmpty =>
      _isNullOrEmpty(instagram) &&
      _isNullOrEmpty(twitter) &&
      _isNullOrEmpty(website);

  bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }
}