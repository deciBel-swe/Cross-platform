// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FollowResponseModel _$FollowResponseModelFromJson(Map<String, dynamic> json) {
  return _FollowResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FollowResponseModel {
  /// Human-readable message from the server (e.g. "Followed successfully").
  String get message => throw _privateConstructorUsedError;

  /// Whether the current user is now following the target user.
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Serializes this FollowResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FollowResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowResponseModelCopyWith<FollowResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowResponseModelCopyWith<$Res> {
  factory $FollowResponseModelCopyWith(
    FollowResponseModel value,
    $Res Function(FollowResponseModel) then,
  ) = _$FollowResponseModelCopyWithImpl<$Res, FollowResponseModel>;
  @useResult
  $Res call({String message, bool isFollowing});
}

/// @nodoc
class _$FollowResponseModelCopyWithImpl<$Res, $Val extends FollowResponseModel>
    implements $FollowResponseModelCopyWith<$Res> {
  _$FollowResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isFollowing = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            isFollowing: null == isFollowing
                ? _value.isFollowing
                : isFollowing // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FollowResponseModelImplCopyWith<$Res>
    implements $FollowResponseModelCopyWith<$Res> {
  factory _$$FollowResponseModelImplCopyWith(
    _$FollowResponseModelImpl value,
    $Res Function(_$FollowResponseModelImpl) then,
  ) = __$$FollowResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, bool isFollowing});
}

/// @nodoc
class __$$FollowResponseModelImplCopyWithImpl<$Res>
    extends _$FollowResponseModelCopyWithImpl<$Res, _$FollowResponseModelImpl>
    implements _$$FollowResponseModelImplCopyWith<$Res> {
  __$$FollowResponseModelImplCopyWithImpl(
    _$FollowResponseModelImpl _value,
    $Res Function(_$FollowResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FollowResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isFollowing = null}) {
    return _then(
      _$FollowResponseModelImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isFollowing: null == isFollowing
            ? _value.isFollowing
            : isFollowing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowResponseModelImpl implements _FollowResponseModel {
  const _$FollowResponseModelImpl({
    required this.message,
    required this.isFollowing,
  });

  factory _$FollowResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowResponseModelImplFromJson(json);

  /// Human-readable message from the server (e.g. "Followed successfully").
  @override
  final String message;

  /// Whether the current user is now following the target user.
  @override
  final bool isFollowing;

  @override
  String toString() {
    return 'FollowResponseModel(message: $message, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowResponseModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, isFollowing);

  /// Create a copy of FollowResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowResponseModelImplCopyWith<_$FollowResponseModelImpl> get copyWith =>
      __$$FollowResponseModelImplCopyWithImpl<_$FollowResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowResponseModelImplToJson(this);
  }
}

abstract class _FollowResponseModel implements FollowResponseModel {
  const factory _FollowResponseModel({
    required final String message,
    required final bool isFollowing,
  }) = _$FollowResponseModelImpl;

  factory _FollowResponseModel.fromJson(Map<String, dynamic> json) =
      _$FollowResponseModelImpl.fromJson;

  /// Human-readable message from the server (e.g. "Followed successfully").
  @override
  String get message;

  /// Whether the current user is now following the target user.
  @override
  bool get isFollowing;

  /// Create a copy of FollowResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowResponseModelImplCopyWith<_$FollowResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
