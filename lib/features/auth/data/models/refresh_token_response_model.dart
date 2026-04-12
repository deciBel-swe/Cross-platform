class RefreshTokenResponseModel {
  const RefreshTokenResponseModel({
    required this.accessToken,
    required this.expiresIn,
    this.refreshToken,
  });

  final String accessToken;
  final int expiresIn;
  final String? refreshToken;
}
