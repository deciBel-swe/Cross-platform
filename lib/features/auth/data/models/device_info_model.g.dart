// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceInfoModelImpl _$$DeviceInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$DeviceInfoModelImpl(
  deviceType: json['deviceType'] as String,
  fingerPrint: json['fingerPrint'] as String,
  deviceName: json['deviceName'] as String,
);

Map<String, dynamic> _$$DeviceInfoModelImplToJson(
  _$DeviceInfoModelImpl instance,
) => <String, dynamic>{
  'deviceType': instance.deviceType,
  'fingerPrint': instance.fingerPrint,
  'deviceName': instance.deviceName,
};
