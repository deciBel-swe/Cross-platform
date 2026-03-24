import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_model.freezed.dart';
part 'device_info_model.g.dart';

@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const factory DeviceInfoModel({
    required String deviceType,
    required String fingerPrint,
    required String deviceName,
  }) = _DeviceInfoModel;

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);
}
