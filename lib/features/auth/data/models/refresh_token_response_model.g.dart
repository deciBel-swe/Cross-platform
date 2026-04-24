// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefreshTokenResponseModelImpl _$$RefreshTokenResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenResponseModelImpl(
  accessToken: json['accessToken'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$$RefreshTokenResponseModelImplToJson(
  _$RefreshTokenResponseModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'expiresIn': instance.expiresIn,
  'refreshToken': instance.refreshToken,
};
