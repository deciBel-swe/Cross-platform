import 'package:freezed_annotation/freezed_annotation.dart';

import 'device_info_model.dart';

part 'register_local_request_model.freezed.dart';
part 'register_local_request_model.g.dart';

@freezed
class RegisterLocalRequestModel with _$RegisterLocalRequestModel {
  const factory RegisterLocalRequestModel({
    required String email,
    required String username,
    required String password,
    required String dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
    required DeviceInfoModel deviceInfo,
  }) = _RegisterLocalRequestModel;

  factory RegisterLocalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterLocalRequestModelFromJson(json);
}
