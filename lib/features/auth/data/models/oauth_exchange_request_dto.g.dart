// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_exchange_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OauthExchangeRequestDtoImpl _$$OauthExchangeRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OauthExchangeRequestDtoImpl(
  code: json['code'] as String,
  deviceInfo: DeviceInfoModel.fromJson(
    json['deviceInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$OauthExchangeRequestDtoImplToJson(
  _$OauthExchangeRequestDtoImpl instance,
) => <String, dynamic>{
  'code': instance.code,
  'deviceInfo': instance.deviceInfo,
};
