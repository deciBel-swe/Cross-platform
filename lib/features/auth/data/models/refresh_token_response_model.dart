import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response_model.freezed.dart';
part 'refresh_token_response_model.g.dart';

/// DTO returned by the refresh-token endpoint.
///
/// Contains the rotated access token, its expiration window, and an optional
/// replacement refresh token extracted from response cookies.
@freezed
class RefreshTokenResponseModel with _$RefreshTokenResponseModel {
  const factory RefreshTokenResponseModel({
    required String accessToken,
    required int expiresIn,
    String? refreshToken,
  }) = _RefreshTokenResponseModel;

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);
}
