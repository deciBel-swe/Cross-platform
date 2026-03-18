// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeviceInfoModel _$DeviceInfoModelFromJson(Map<String, dynamic> json) {
  return _DeviceInfoModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfoModel {
  String get deviceType => throw _privateConstructorUsedError;
  String get fingerPrint => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoModelCopyWith<DeviceInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoModelCopyWith<$Res> {
  factory $DeviceInfoModelCopyWith(
    DeviceInfoModel value,
    $Res Function(DeviceInfoModel) then,
  ) = _$DeviceInfoModelCopyWithImpl<$Res, DeviceInfoModel>;
  @useResult
  $Res call({String deviceType, String fingerPrint, String deviceName});
}

/// @nodoc
class _$DeviceInfoModelCopyWithImpl<$Res, $Val extends DeviceInfoModel>
    implements $DeviceInfoModelCopyWith<$Res> {
  _$DeviceInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceType = null,
    Object? fingerPrint = null,
    Object? deviceName = null,
  }) {
    return _then(
      _value.copyWith(
            deviceType: null == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            fingerPrint: null == fingerPrint
                ? _value.fingerPrint
                : fingerPrint // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceName: null == deviceName
                ? _value.deviceName
                : deviceName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeviceInfoModelImplCopyWith<$Res>
    implements $DeviceInfoModelCopyWith<$Res> {
  factory _$$DeviceInfoModelImplCopyWith(
    _$DeviceInfoModelImpl value,
    $Res Function(_$DeviceInfoModelImpl) then,
  ) = __$$DeviceInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String deviceType, String fingerPrint, String deviceName});
}

/// @nodoc
class __$$DeviceInfoModelImplCopyWithImpl<$Res>
    extends _$DeviceInfoModelCopyWithImpl<$Res, _$DeviceInfoModelImpl>
    implements _$$DeviceInfoModelImplCopyWith<$Res> {
  __$$DeviceInfoModelImplCopyWithImpl(
    _$DeviceInfoModelImpl _value,
    $Res Function(_$DeviceInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceType = null,
    Object? fingerPrint = null,
    Object? deviceName = null,
  }) {
    return _then(
      _$DeviceInfoModelImpl(
        deviceType: null == deviceType
            ? _value.deviceType
            : deviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        fingerPrint: null == fingerPrint
            ? _value.fingerPrint
            : fingerPrint // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceName: null == deviceName
            ? _value.deviceName
            : deviceName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoModelImpl implements _DeviceInfoModel {
  const _$DeviceInfoModelImpl({
    required this.deviceType,
    required this.fingerPrint,
    required this.deviceName,
  });

  factory _$DeviceInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoModelImplFromJson(json);

  @override
  final String deviceType;
  @override
  final String fingerPrint;
  @override
  final String deviceName;

  @override
  String toString() {
    return 'DeviceInfoModel(deviceType: $deviceType, fingerPrint: $fingerPrint, deviceName: $deviceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoModelImpl &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.fingerPrint, fingerPrint) ||
                other.fingerPrint == fingerPrint) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, deviceType, fingerPrint, deviceName);

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoModelImplCopyWith<_$DeviceInfoModelImpl> get copyWith =>
      __$$DeviceInfoModelImplCopyWithImpl<_$DeviceInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoModelImplToJson(this);
  }
}

abstract class _DeviceInfoModel implements DeviceInfoModel {
  const factory _DeviceInfoModel({
    required final String deviceType,
    required final String fingerPrint,
    required final String deviceName,
  }) = _$DeviceInfoModelImpl;

  factory _DeviceInfoModel.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoModelImpl.fromJson;

  @override
  String get deviceType;
  @override
  String get fingerPrint;
  @override
  String get deviceName;

  /// Create a copy of DeviceInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoModelImplCopyWith<_$DeviceInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
