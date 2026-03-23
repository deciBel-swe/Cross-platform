import 'package:freezed_annotation/freezed_annotation.dart';

import 'device_info_model.dart';

part 'oauth_exchange_request_dto.freezed.dart';
part 'oauth_exchange_request_dto.g.dart';

@freezed
class OauthExchangeRequestDto with _$OauthExchangeRequestDto {
  const factory OauthExchangeRequestDto({
    required String code,
    required DeviceInfoModel deviceInfo,
  }) = _OauthExchangeRequestDto;

  factory OauthExchangeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OauthExchangeRequestDtoFromJson(json);
}

// Custom toJson override to match API field name 'authTokenDto'
extension OauthExchangeRequestDtoX on OauthExchangeRequestDto {
  Map<String, dynamic> toApiJson() => {
    'authTokenDto': code,
    'deviceInfo': deviceInfo.toJson(),
  };
}
