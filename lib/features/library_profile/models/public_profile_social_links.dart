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
      instagram == null && twitter == null && website == null;
}