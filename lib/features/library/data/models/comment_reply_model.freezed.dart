// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_reply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentReplyModel _$CommentReplyModelFromJson(Map<String, dynamic> json) {
  return _CommentReplyModel.fromJson(json);
}

/// @nodoc
mixin _$CommentReplyModel {
  @JsonKey(name: 'id')
  int get commentId => throw _privateConstructorUsedError;
  CommentUserModel get user => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommentReplyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentReplyModelCopyWith<CommentReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentReplyModelCopyWith<$Res> {
  factory $CommentReplyModelCopyWith(
    CommentReplyModel value,
    $Res Function(CommentReplyModel) then,
  ) = _$CommentReplyModelCopyWithImpl<$Res, CommentReplyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int commentId,
    CommentUserModel user,
    String body,
    DateTime? createdAt,
  });

  $CommentUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$CommentReplyModelCopyWithImpl<$Res, $Val extends CommentReplyModel>
    implements $CommentReplyModelCopyWith<$Res> {
  _$CommentReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? user = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            commentId: null == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
                      as int,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as CommentUserModel,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentUserModelCopyWith<$Res> get user {
    return $CommentUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentReplyModelImplCopyWith<$Res>
    implements $CommentReplyModelCopyWith<$Res> {
  factory _$$CommentReplyModelImplCopyWith(
    _$CommentReplyModelImpl value,
    $Res Function(_$CommentReplyModelImpl) then,
  ) = __$$CommentReplyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int commentId,
    CommentUserModel user,
    String body,
    DateTime? createdAt,
  });

  @override
  $CommentUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$CommentReplyModelImplCopyWithImpl<$Res>
    extends _$CommentReplyModelCopyWithImpl<$Res, _$CommentReplyModelImpl>
    implements _$$CommentReplyModelImplCopyWith<$Res> {
  __$$CommentReplyModelImplCopyWithImpl(
    _$CommentReplyModelImpl _value,
    $Res Function(_$CommentReplyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? user = null,
    Object? body = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CommentReplyModelImpl(
        commentId: null == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as int,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as CommentUserModel,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentReplyModelImpl implements _CommentReplyModel {
  const _$CommentReplyModelImpl({
    @JsonKey(name: 'id') required this.commentId,
    required this.user,
    required this.body,
    this.createdAt,
  });

  factory _$CommentReplyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentReplyModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int commentId;
  @override
  final CommentUserModel user;
  @override
  final String body;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CommentReplyModel(commentId: $commentId, user: $user, body: $body, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentReplyModelImpl &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, commentId, user, body, createdAt);

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentReplyModelImplCopyWith<_$CommentReplyModelImpl> get copyWith =>
      __$$CommentReplyModelImplCopyWithImpl<_$CommentReplyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentReplyModelImplToJson(this);
  }
}

abstract class _CommentReplyModel implements CommentReplyModel {
  const factory _CommentReplyModel({
    @JsonKey(name: 'id') required final int commentId,
    required final CommentUserModel user,
    required final String body,
    final DateTime? createdAt,
  }) = _$CommentReplyModelImpl;

  factory _CommentReplyModel.fromJson(Map<String, dynamic> json) =
      _$CommentReplyModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get commentId;
  @override
  CommentUserModel get user;
  @override
  String get body;
  @override
  DateTime? get createdAt;

  /// Create a copy of CommentReplyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentReplyModelImplCopyWith<_$CommentReplyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
