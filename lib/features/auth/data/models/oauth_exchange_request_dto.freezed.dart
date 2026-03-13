// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oauth_exchange_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OauthExchangeRequestDto _$OauthExchangeRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  return _OauthExchangeRequestDto.fromJson(json);
}

/// @nodoc
mixin _$OauthExchangeRequestDto {
  String get code => throw _privateConstructorUsedError;
  DeviceInfoModel get deviceInfo => throw _privateConstructorUsedError;

  /// Serializes this OauthExchangeRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OauthExchangeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OauthExchangeRequestDtoCopyWith<OauthExchangeRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OauthExchangeRequestDtoCopyWith<$Res> {
  factory $OauthExchangeRequestDtoCopyWith(
    OauthExchangeRequestDto value,
    $Res Function(OauthExchangeRequestDto) then,
  ) = _$OauthExchangeRequestDtoCopyWithImpl<$Res, OauthExchangeRequestDto>;
  @useResult
  $Res call({String code, DeviceInfoModel deviceInfo});

  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class _$OauthExchangeRequestDtoCopyWithImpl<
  $Res,
  $Val extends OauthExchangeRequestDto
>
    implements $OauthExchangeRequestDtoCopyWith<$Res> {
  _$OauthExchangeRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OauthExchangeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? deviceInfo = null}) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceInfo: null == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as DeviceInfoModel,
          )
          as $Val,
    );
  }

  /// Create a copy of OauthExchangeRequestDto
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
abstract class _$$OauthExchangeRequestDtoImplCopyWith<$Res>
    implements $OauthExchangeRequestDtoCopyWith<$Res> {
  factory _$$OauthExchangeRequestDtoImplCopyWith(
    _$OauthExchangeRequestDtoImpl value,
    $Res Function(_$OauthExchangeRequestDtoImpl) then,
  ) = __$$OauthExchangeRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, DeviceInfoModel deviceInfo});

  @override
  $DeviceInfoModelCopyWith<$Res> get deviceInfo;
}

/// @nodoc
class __$$OauthExchangeRequestDtoImplCopyWithImpl<$Res>
    extends
        _$OauthExchangeRequestDtoCopyWithImpl<
          $Res,
          _$OauthExchangeRequestDtoImpl
        >
    implements _$$OauthExchangeRequestDtoImplCopyWith<$Res> {
  __$$OauthExchangeRequestDtoImplCopyWithImpl(
    _$OauthExchangeRequestDtoImpl _value,
    $Res Function(_$OauthExchangeRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OauthExchangeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? deviceInfo = null}) {
    return _then(
      _$OauthExchangeRequestDtoImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
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
class _$OauthExchangeRequestDtoImpl implements _OauthExchangeRequestDto {
  const _$OauthExchangeRequestDtoImpl({
    required this.code,
    required this.deviceInfo,
  });

  factory _$OauthExchangeRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OauthExchangeRequestDtoImplFromJson(json);

  @override
  final String code;
  @override
  final DeviceInfoModel deviceInfo;

  @override
  String toString() {
    return 'OauthExchangeRequestDto(code: $code, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OauthExchangeRequestDtoImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, deviceInfo);

  /// Create a copy of OauthExchangeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OauthExchangeRequestDtoImplCopyWith<_$OauthExchangeRequestDtoImpl>
  get copyWith =>
      __$$OauthExchangeRequestDtoImplCopyWithImpl<
        _$OauthExchangeRequestDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OauthExchangeRequestDtoImplToJson(this);
  }
}

abstract class _OauthExchangeRequestDto implements OauthExchangeRequestDto {
  const factory _OauthExchangeRequestDto({
    required final String code,
    required final DeviceInfoModel deviceInfo,
  }) = _$OauthExchangeRequestDtoImpl;

  factory _OauthExchangeRequestDto.fromJson(Map<String, dynamic> json) =
      _$OauthExchangeRequestDtoImpl.fromJson;

  @override
  String get code;
  @override
  DeviceInfoModel get deviceInfo;

  /// Create a copy of OauthExchangeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OauthExchangeRequestDtoImplCopyWith<_$OauthExchangeRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
