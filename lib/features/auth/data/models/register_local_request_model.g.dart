// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_local_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterLocalRequestModelImpl _$$RegisterLocalRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterLocalRequestModelImpl(
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  password: json['password'] as String,
  dateOfBirth: json['dateOfBirth'] as String,
  gender: json['gender'] as String,
  city: json['city'] as String?,
  country: json['country'] as String?,
  captchaToken: json['captchaToken'] as String,
  deviceInfo: DeviceInfoModel.fromJson(
    json['deviceInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$RegisterLocalRequestModelImplToJson(
  _$RegisterLocalRequestModelImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'displayName': instance.displayName,
  'password': instance.password,
  'dateOfBirth': instance.dateOfBirth,
  'gender': instance.gender,
  'city': instance.city,
  'country': instance.country,
  'captchaToken': instance.captchaToken,
  'deviceInfo': instance.deviceInfo,
};
