// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_local_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginLocalRequestModel _$LoginLocalRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _LoginLocalRequestModel.fromJson(json);
}

/// @nodoc
mixin _$LoginLocalRequestModel {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  DeviceInfoModel get deviceInfo => throw _privateConstructorUsedError;

  /// Serializes this LoginLocalRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginLocalRequestModelCopyWith<LoginLocalRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginLocalRequestModelCopyWith<$Res> {
  factory $LoginLocalRequestModelCopyWith(
    LoginLocalRequestModel value,
    $Res Function(LoginLocalRequestModel) then,
  ) = _$LoginLocalRequestModelCopyWithImpl<$Res, LoginLocalRequestModel>;
  @useResult
  $Res call({String email, String password, DeviceInfoModel deviceInfo});

  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class _$LoginLocalRequestModelCopyWithImpl<
  $Res,
  $Val extends LoginLocalRequestModel
>
    implements $LoginLocalRequestModelCopyWith<$Res> {
  _$LoginLocalRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceInfo: null == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as DeviceInfoModel,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeviceInfoModelCopyWith<$Res> get deviceInfo {
    return $DeviceInfoModelCopyWith<$Res>(_value.deviceInfo, (value) {
      return _then(_value.copyWith(deviceInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginLocalRequestModelImplCopyWith<$Res>
    implements $LoginLocalRequestModelCopyWith<$Res> {
  factory _$$LoginLocalRequestModelImplCopyWith(
    _$LoginLocalRequestModelImpl value,
    $Res Function(_$LoginLocalRequestModelImpl) then,
  ) = __$$LoginLocalRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, DeviceInfoModel deviceInfo});

  @override
  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class __$$LoginLocalRequestModelImplCopyWithImpl<$Res>
    extends
        _$LoginLocalRequestModelCopyWithImpl<$Res, _$LoginLocalRequestModelImpl>
    implements _$$LoginLocalRequestModelImplCopyWith<$Res> {
  __$$LoginLocalRequestModelImplCopyWithImpl(
    _$LoginLocalRequestModelImpl _value,
    $Res Function(_$LoginLocalRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _$LoginLocalRequestModelImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceInfo: null == deviceInfo
            ? _value.deviceInfo
            : deviceInfo // ignore: cast_nullable_to_non_nullable
                  as DeviceInfoModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginLocalRequestModelImpl implements _LoginLocalRequestModel {
  const _$LoginLocalRequestModelImpl({
    required this.email,
    required this.password,
    required this.deviceInfo,
  });

  factory _$LoginLocalRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginLocalRequestModelImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final DeviceInfoModel deviceInfo;

  @override
  String toString() {
    return 'LoginLocalRequestModel(email: $email, password: $password, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginLocalRequestModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password, deviceInfo);

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginLocalRequestModelImplCopyWith<_$LoginLocalRequestModelImpl>
  get copyWith =>
      __$$LoginLocalRequestModelImplCopyWithImpl<_$LoginLocalRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginLocalRequestModelImplToJson(this);
  }
}

abstract class _LoginLocalRequestModel implements LoginLocalRequestModel {
  const factory _LoginLocalRequestModel({
    required final String email,
    required final String password,
    required final DeviceInfoModel deviceInfo,
  }) = _$LoginLocalRequestModelImpl;

  factory _LoginLocalRequestModel.fromJson(Map<String, dynamic> json) =
      _$LoginLocalRequestModelImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  DeviceInfoModel get deviceInfo;

  /// Create a copy of LoginLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginLocalRequestModelImplCopyWith<_$LoginLocalRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
