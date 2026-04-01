// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_comment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PostCommentResponseModel _$PostCommentResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _PostCommentResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PostCommentResponseModel {
  @JsonKey(name: 'id')
  int get commentId => throw _privateConstructorUsedError;
  int get replycount => throw _privateConstructorUsedError;
  CommentUserModel get user => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  int? get timestampSeconds => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PostCommentResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostCommentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCommentResponseModelCopyWith<PostCommentResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentResponseModelCopyWith<$Res> {
  factory $PostCommentResponseModelCopyWith(
    PostCommentResponseModel value,
    $Res Function(PostCommentResponseModel) then,
  ) = _$PostCommentResponseModelCopyWithImpl<$Res, PostCommentResponseModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') int commentId,
    int replycount,
    CommentUserModel user,
    String body,
    int? timestampSeconds,
    DateTime createdAt,
  });

  $CommentUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$PostCommentResponseModelCopyWithImpl<
  $Res,
  $Val extends PostCommentResponseModel
>
    implements $PostCommentResponseModelCopyWith<$Res> {
  _$PostCommentResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostCommentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? replycount = null,
    Object? user = null,
    Object? body = null,
    Object? timestampSeconds = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            commentId: null == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
                      as int,
            replycount: null == replycount
                ? _value.replycount
                : replycount // ignore: cast_nullable_to_non_nullable
                      as int,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as CommentUserModel,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            timestampSeconds: freezed == timestampSeconds
                ? _value.timestampSeconds
                : timestampSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of PostCommentResponseModel
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
abstract class _$$PostCommentResponseModelImplCopyWith<$Res>
    implements $PostCommentResponseModelCopyWith<$Res> {
  factory _$$PostCommentResponseModelImplCopyWith(
    _$PostCommentResponseModelImpl value,
    $Res Function(_$PostCommentResponseModelImpl) then,
  ) = __$$PostCommentResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') int commentId,
    int replycount,
    CommentUserModel user,
    String body,
    int? timestampSeconds,
    DateTime createdAt,
  });

  @override
  $CommentUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$PostCommentResponseModelImplCopyWithImpl<$Res>
    extends
        _$PostCommentResponseModelCopyWithImpl<
          $Res,
          _$PostCommentResponseModelImpl
        >
    implements _$$PostCommentResponseModelImplCopyWith<$Res> {
  __$$PostCommentResponseModelImplCopyWithImpl(
    _$PostCommentResponseModelImpl _value,
    $Res Function(_$PostCommentResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostCommentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? replycount = null,
    Object? user = null,
    Object? body = null,
    Object? timestampSeconds = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$PostCommentResponseModelImpl(
        commentId: null == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as int,
        replycount: null == replycount
            ? _value.replycount
            : replycount // ignore: cast_nullable_to_non_nullable
                  as int,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as CommentUserModel,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        timestampSeconds: freezed == timestampSeconds
            ? _value.timestampSeconds
            : timestampSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCommentResponseModelImpl implements _PostCommentResponseModel {
  const _$PostCommentResponseModelImpl({
    @JsonKey(name: 'id') required this.commentId,
    this.replycount = 0,
    required this.user,
    required this.body,
    this.timestampSeconds,
    required this.createdAt,
  });

  factory _$PostCommentResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCommentResponseModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int commentId;
  @override
  @JsonKey()
  final int replycount;
  @override
  final CommentUserModel user;
  @override
  final String body;
  @override
  final int? timestampSeconds;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PostCommentResponseModel(commentId: $commentId, replycount: $replycount, user: $user, body: $body, timestampSeconds: $timestampSeconds, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCommentResponseModelImpl &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.replycount, replycount) ||
                other.replycount == replycount) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    commentId,
    replycount,
    user,
    body,
    timestampSeconds,
    createdAt,
  );

  /// Create a copy of PostCommentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCommentResponseModelImplCopyWith<_$PostCommentResponseModelImpl>
  get copyWith =>
      __$$PostCommentResponseModelImplCopyWithImpl<
        _$PostCommentResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCommentResponseModelImplToJson(this);
  }
}

abstract class _PostCommentResponseModel implements PostCommentResponseModel {
  const factory _PostCommentResponseModel({
    @JsonKey(name: 'id') required final int commentId,
    final int replycount,
    required final CommentUserModel user,
    required final String body,
    final int? timestampSeconds,
    required final DateTime createdAt,
  }) = _$PostCommentResponseModelImpl;

  factory _PostCommentResponseModel.fromJson(Map<String, dynamic> json) =
      _$PostCommentResponseModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get commentId;
  @override
  int get replycount;
  @override
  CommentUserModel get user;
  @override
  String get body;
  @override
  int? get timestampSeconds;
  @override
  DateTime get createdAt;

  /// Create a copy of PostCommentResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostCommentResponseModelImplCopyWith<_$PostCommentResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
