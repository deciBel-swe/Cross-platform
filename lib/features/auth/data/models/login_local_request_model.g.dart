// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_local_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginLocalRequestModelImpl _$$LoginLocalRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginLocalRequestModelImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  deviceInfo: DeviceInfoModel.fromJson(
    json['deviceInfo'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$LoginLocalRequestModelImplToJson(
  _$LoginLocalRequestModelImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'deviceInfo': instance.deviceInfo,
};
