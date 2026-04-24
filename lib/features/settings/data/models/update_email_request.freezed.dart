// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_email_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateEmailRequest _$UpdateEmailRequestFromJson(Map<String, dynamic> json) {
  return _UpdateEmailRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateEmailRequest {
  String get newEmail => throw _privateConstructorUsedError;

  /// Serializes this UpdateEmailRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateEmailRequestCopyWith<UpdateEmailRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateEmailRequestCopyWith<$Res> {
  factory $UpdateEmailRequestCopyWith(
    UpdateEmailRequest value,
    $Res Function(UpdateEmailRequest) then,
  ) = _$UpdateEmailRequestCopyWithImpl<$Res, UpdateEmailRequest>;
  @useResult
  $Res call({String newEmail});
}

/// @nodoc
class _$UpdateEmailRequestCopyWithImpl<$Res, $Val extends UpdateEmailRequest>
    implements $UpdateEmailRequestCopyWith<$Res> {
  _$UpdateEmailRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newEmail = null}) {
    return _then(
      _value.copyWith(
            newEmail: null == newEmail
                ? _value.newEmail
                : newEmail // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateEmailRequestImplCopyWith<$Res>
    implements $UpdateEmailRequestCopyWith<$Res> {
  factory _$$UpdateEmailRequestImplCopyWith(
    _$UpdateEmailRequestImpl value,
    $Res Function(_$UpdateEmailRequestImpl) then,
  ) = __$$UpdateEmailRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newEmail});
}

/// @nodoc
class __$$UpdateEmailRequestImplCopyWithImpl<$Res>
    extends _$UpdateEmailRequestCopyWithImpl<$Res, _$UpdateEmailRequestImpl>
    implements _$$UpdateEmailRequestImplCopyWith<$Res> {
  __$$UpdateEmailRequestImplCopyWithImpl(
    _$UpdateEmailRequestImpl _value,
    $Res Function(_$UpdateEmailRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newEmail = null}) {
    return _then(
      _$UpdateEmailRequestImpl(
        newEmail: null == newEmail
            ? _value.newEmail
            : newEmail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateEmailRequestImpl implements _UpdateEmailRequest {
  const _$UpdateEmailRequestImpl({required this.newEmail});

  factory _$UpdateEmailRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateEmailRequestImplFromJson(json);

  @override
  final String newEmail;

  @override
  String toString() {
    return 'UpdateEmailRequest(newEmail: $newEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateEmailRequestImpl &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newEmail);

  /// Create a copy of UpdateEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateEmailRequestImplCopyWith<_$UpdateEmailRequestImpl> get copyWith =>
      __$$UpdateEmailRequestImplCopyWithImpl<_$UpdateEmailRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateEmailRequestImplToJson(this);
  }
}

abstract class _UpdateEmailRequest implements UpdateEmailRequest {
  const factory _UpdateEmailRequest({required final String newEmail}) =
      _$UpdateEmailRequestImpl;

  factory _UpdateEmailRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateEmailRequestImpl.fromJson;

  @override
  String get newEmail;

  /// Create a copy of UpdateEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateEmailRequestImplCopyWith<_$UpdateEmailRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
