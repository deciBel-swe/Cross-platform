import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_verification_response_model.freezed.dart';
part 'resend_verification_response_model.g.dart';

@freezed
class ResendVerificationResponseModel with _$ResendVerificationResponseModel {
  const factory ResendVerificationResponseModel({
    required String message,
    int? coolDown,
  }) = _ResendVerificationResponseModel;

  factory ResendVerificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationResponseModelFromJson(json);
}
