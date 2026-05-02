// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resend_verification_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ResendVerificationResponseModel _$ResendVerificationResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _ResendVerificationResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ResendVerificationResponseModel {
  String get message => throw _privateConstructorUsedError;
  int? get coolDown => throw _privateConstructorUsedError;

  /// Serializes this ResendVerificationResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResendVerificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResendVerificationResponseModelCopyWith<ResendVerificationResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResendVerificationResponseModelCopyWith<$Res> {
  factory $ResendVerificationResponseModelCopyWith(
    ResendVerificationResponseModel value,
    $Res Function(ResendVerificationResponseModel) then,
  ) =
      _$ResendVerificationResponseModelCopyWithImpl<
        $Res,
        ResendVerificationResponseModel
      >;
  @useResult
  $Res call({String message, int? coolDown});
}

/// @nodoc
class _$ResendVerificationResponseModelCopyWithImpl<
  $Res,
  $Val extends ResendVerificationResponseModel
>
    implements $ResendVerificationResponseModelCopyWith<$Res> {
  _$ResendVerificationResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResendVerificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? coolDown = freezed}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            coolDown: freezed == coolDown
                ? _value.coolDown
                : coolDown // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResendVerificationResponseModelImplCopyWith<$Res>
    implements $ResendVerificationResponseModelCopyWith<$Res> {
  factory _$$ResendVerificationResponseModelImplCopyWith(
    _$ResendVerificationResponseModelImpl value,
    $Res Function(_$ResendVerificationResponseModelImpl) then,
  ) = __$$ResendVerificationResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? coolDown});
}

/// @nodoc
class __$$ResendVerificationResponseModelImplCopyWithImpl<$Res>
    extends
        _$ResendVerificationResponseModelCopyWithImpl<
          $Res,
          _$ResendVerificationResponseModelImpl
        >
    implements _$$ResendVerificationResponseModelImplCopyWith<$Res> {
  __$$ResendVerificationResponseModelImplCopyWithImpl(
    _$ResendVerificationResponseModelImpl _value,
    $Res Function(_$ResendVerificationResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResendVerificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? coolDown = freezed}) {
    return _then(
      _$ResendVerificationResponseModelImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        coolDown: freezed == coolDown
            ? _value.coolDown
            : coolDown // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResendVerificationResponseModelImpl
    implements _ResendVerificationResponseModel {
  const _$ResendVerificationResponseModelImpl({
    required this.message,
    this.coolDown,
  });

  factory _$ResendVerificationResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ResendVerificationResponseModelImplFromJson(json);

  @override
  final String message;
  @override
  final int? coolDown;

  @override
  String toString() {
    return 'ResendVerificationResponseModel(message: $message, coolDown: $coolDown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResendVerificationResponseModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.coolDown, coolDown) ||
                other.coolDown == coolDown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, coolDown);

  /// Create a copy of ResendVerificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResendVerificationResponseModelImplCopyWith<
    _$ResendVerificationResponseModelImpl
  >
  get copyWith =>
      __$$ResendVerificationResponseModelImplCopyWithImpl<
        _$ResendVerificationResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResendVerificationResponseModelImplToJson(this);
  }
}

abstract class _ResendVerificationResponseModel
    implements ResendVerificationResponseModel {
  const factory _ResendVerificationResponseModel({
    required final String message,
    final int? coolDown,
  }) = _$ResendVerificationResponseModelImpl;

  factory _ResendVerificationResponseModel.fromJson(Map<String, dynamic> json) =
      _$ResendVerificationResponseModelImpl.fromJson;

  @override
  String get message;
  @override
  int? get coolDown;

  /// Create a copy of ResendVerificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResendVerificationResponseModelImplCopyWith<
    _$ResendVerificationResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
