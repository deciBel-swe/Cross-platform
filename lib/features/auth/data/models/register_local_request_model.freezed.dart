// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_local_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegisterLocalRequestModel _$RegisterLocalRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _RegisterLocalRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RegisterLocalRequestModel {
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get dateOfBirth => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String get captchaToken => throw _privateConstructorUsedError;
  DeviceInfoModel get deviceInfo => throw _privateConstructorUsedError;

  /// Serializes this RegisterLocalRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterLocalRequestModelCopyWith<RegisterLocalRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterLocalRequestModelCopyWith<$Res> {
  factory $RegisterLocalRequestModelCopyWith(
    RegisterLocalRequestModel value,
    $Res Function(RegisterLocalRequestModel) then,
  ) = _$RegisterLocalRequestModelCopyWithImpl<$Res, RegisterLocalRequestModel>;
  @useResult
  $Res call({
    String email,
    String displayName,
    String password,
    String dateOfBirth,
    String gender,
    String? city,
    String? country,
    String captchaToken,
    DeviceInfoModel deviceInfo,
  });

  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class _$RegisterLocalRequestModelCopyWithImpl<
  $Res,
  $Val extends RegisterLocalRequestModel
>
    implements $RegisterLocalRequestModelCopyWith<$Res> {
  _$RegisterLocalRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? displayName = null,
    Object? password = null,
    Object? dateOfBirth = null,
    Object? gender = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? captchaToken = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            dateOfBirth: null == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            captchaToken: null == captchaToken
                ? _value.captchaToken
                : captchaToken // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceInfo: null == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as DeviceInfoModel,
          )
          as $Val,
    );
  }

  /// Create a copy of RegisterLocalRequestModel
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
abstract class _$$RegisterLocalRequestModelImplCopyWith<$Res>
    implements $RegisterLocalRequestModelCopyWith<$Res> {
  factory _$$RegisterLocalRequestModelImplCopyWith(
    _$RegisterLocalRequestModelImpl value,
    $Res Function(_$RegisterLocalRequestModelImpl) then,
  ) = __$$RegisterLocalRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    String displayName,
    String password,
    String dateOfBirth,
    String gender,
    String? city,
    String? country,
    String captchaToken,
    DeviceInfoModel deviceInfo,
  });

  @override
  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class __$$RegisterLocalRequestModelImplCopyWithImpl<$Res>
    extends
        _$RegisterLocalRequestModelCopyWithImpl<
          $Res,
          _$RegisterLocalRequestModelImpl
        >
    implements _$$RegisterLocalRequestModelImplCopyWith<$Res> {
  __$$RegisterLocalRequestModelImplCopyWithImpl(
    _$RegisterLocalRequestModelImpl _value,
    $Res Function(_$RegisterLocalRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? displayName = null,
    Object? password = null,
    Object? dateOfBirth = null,
    Object? gender = null,
    Object? city = freezed,
    Object? country = freezed,
    Object? captchaToken = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _$RegisterLocalRequestModelImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        dateOfBirth: null == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        captchaToken: null == captchaToken
            ? _value.captchaToken
            : captchaToken // ignore: cast_nullable_to_non_nullable
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
class _$RegisterLocalRequestModelImpl implements _RegisterLocalRequestModel {
  const _$RegisterLocalRequestModelImpl({
    required this.email,
    required this.displayName,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    this.city,
    this.country,
    required this.captchaToken,
    required this.deviceInfo,
  });

  factory _$RegisterLocalRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterLocalRequestModelImplFromJson(json);

  @override
  final String email;
  @override
  final String displayName;
  @override
  final String password;
  @override
  final String dateOfBirth;
  @override
  final String gender;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String captchaToken;
  @override
  final DeviceInfoModel deviceInfo;

  @override
  String toString() {
    return 'RegisterLocalRequestModel(email: $email, displayName: $displayName, password: $password, dateOfBirth: $dateOfBirth, gender: $gender, city: $city, country: $country, captchaToken: $captchaToken, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterLocalRequestModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.captchaToken, captchaToken) ||
                other.captchaToken == captchaToken) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    displayName,
    password,
    dateOfBirth,
    gender,
    city,
    country,
    captchaToken,
    deviceInfo,
  );

  /// Create a copy of RegisterLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterLocalRequestModelImplCopyWith<_$RegisterLocalRequestModelImpl>
  get copyWith =>
      __$$RegisterLocalRequestModelImplCopyWithImpl<
        _$RegisterLocalRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterLocalRequestModelImplToJson(this);
  }
}

abstract class _RegisterLocalRequestModel implements RegisterLocalRequestModel {
  const factory _RegisterLocalRequestModel({
    required final String email,
    required final String displayName,
    required final String password,
    required final String dateOfBirth,
    required final String gender,
    final String? city,
    final String? country,
    required final String captchaToken,
    required final DeviceInfoModel deviceInfo,
  }) = _$RegisterLocalRequestModelImpl;

  factory _RegisterLocalRequestModel.fromJson(Map<String, dynamic> json) =
      _$RegisterLocalRequestModelImpl.fromJson;

  @override
  String get email;
  @override
  String get displayName;
  @override
  String get password;
  @override
  String get dateOfBirth;
  @override
  String get gender;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String get captchaToken;
  @override
  DeviceInfoModel get deviceInfo;

  /// Create a copy of RegisterLocalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterLocalRequestModelImplCopyWith<_$RegisterLocalRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
