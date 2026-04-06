import 'package:freezed_annotation/freezed_annotation.dart';

import 'device_info_model.dart';

part 'login_local_request_model.freezed.dart';
part 'login_local_request_model.g.dart';

@freezed
class LoginLocalRequestModel with _$LoginLocalRequestModel {
  const factory LoginLocalRequestModel({
    required String email,
    required String password,
    required DeviceInfoModel deviceInfo,
  }) = _LoginLocalRequestModel;

  factory LoginLocalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginLocalRequestModelFromJson(json);
}
