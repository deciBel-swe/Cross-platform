// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_comment_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostCommentRequestModel _$PostCommentRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _PostCommentRequestModel.fromJson(json);
}

/// @nodoc
mixin _$PostCommentRequestModel {
  String get body => throw _privateConstructorUsedError;
  int? get timeStampseconds => throw _privateConstructorUsedError;

  /// Serializes this PostCommentRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostCommentRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCommentRequestModelCopyWith<PostCommentRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentRequestModelCopyWith<$Res> {
  factory $PostCommentRequestModelCopyWith(
    PostCommentRequestModel value,
    $Res Function(PostCommentRequestModel) then,
  ) = _$PostCommentRequestModelCopyWithImpl<$Res, PostCommentRequestModel>;
  @useResult
  $Res call({String body, int? timeStampseconds});
}

/// @nodoc
class _$PostCommentRequestModelCopyWithImpl<
  $Res,
  $Val extends PostCommentRequestModel
>
    implements $PostCommentRequestModelCopyWith<$Res> {
  _$PostCommentRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostCommentRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? body = null, Object? timeStampseconds = freezed}) {
    return _then(
      _value.copyWith(
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            timeStampseconds: freezed == timeStampseconds
                ? _value.timeStampseconds
                : timeStampseconds // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostCommentRequestModelImplCopyWith<$Res>
    implements $PostCommentRequestModelCopyWith<$Res> {
  factory _$$PostCommentRequestModelImplCopyWith(
    _$PostCommentRequestModelImpl value,
    $Res Function(_$PostCommentRequestModelImpl) then,
  ) = __$$PostCommentRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String body, int? timeStampseconds});
}

/// @nodoc
class __$$PostCommentRequestModelImplCopyWithImpl<$Res>
    extends
        _$PostCommentRequestModelCopyWithImpl<
          $Res,
          _$PostCommentRequestModelImpl
        >
    implements _$$PostCommentRequestModelImplCopyWith<$Res> {
  __$$PostCommentRequestModelImplCopyWithImpl(
    _$PostCommentRequestModelImpl _value,
    $Res Function(_$PostCommentRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostCommentRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? body = null, Object? timeStampseconds = freezed}) {
    return _then(
      _$PostCommentRequestModelImpl(
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        timeStampseconds: freezed == timeStampseconds
            ? _value.timeStampseconds
            : timeStampseconds // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCommentRequestModelImpl implements _PostCommentRequestModel {
  const _$PostCommentRequestModelImpl({
    required this.body,
    this.timeStampseconds,
  });

  factory _$PostCommentRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCommentRequestModelImplFromJson(json);

  @override
  final String body;
  @override
  final int? timeStampseconds;

  @override
  String toString() {
    return 'PostCommentRequestModel(body: $body, timeStampseconds: $timeStampseconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCommentRequestModelImpl &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.timeStampseconds, timeStampseconds) ||
                other.timeStampseconds == timeStampseconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, body, timeStampseconds);

  /// Create a copy of PostCommentRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCommentRequestModelImplCopyWith<_$PostCommentRequestModelImpl>
  get copyWith =>
      __$$PostCommentRequestModelImplCopyWithImpl<
        _$PostCommentRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCommentRequestModelImplToJson(this);
  }
}

abstract class _PostCommentRequestModel implements PostCommentRequestModel {
  const factory _PostCommentRequestModel({
    required final String body,
    final int? timeStampseconds,
  }) = _$PostCommentRequestModelImpl;

  factory _PostCommentRequestModel.fromJson(Map<String, dynamic> json) =
      _$PostCommentRequestModelImpl.fromJson;

  @override
  String get body;
  @override
  int? get timeStampseconds;

  /// Create a copy of PostCommentRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostCommentRequestModelImplCopyWith<_$PostCommentRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
