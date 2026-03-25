// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentUserModel _$CommentUserModelFromJson(Map<String, dynamic> json) {
  return _CommentUserModel.fromJson(json);
}

/// @nodoc
mixin _$CommentUserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this CommentUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentUserModelCopyWith<CommentUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentUserModelCopyWith<$Res> {
  factory $CommentUserModelCopyWith(
    CommentUserModel value,
    $Res Function(CommentUserModel) then,
  ) = _$CommentUserModelCopyWithImpl<$Res, CommentUserModel>;
  @useResult
  $Res call({int id, String username, String avatarUrl});
}

/// @nodoc
class _$CommentUserModelCopyWithImpl<$Res, $Val extends CommentUserModel>
    implements $CommentUserModelCopyWith<$Res> {
  _$CommentUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: null == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentUserModelImplCopyWith<$Res>
    implements $CommentUserModelCopyWith<$Res> {
  factory _$$CommentUserModelImplCopyWith(
    _$CommentUserModelImpl value,
    $Res Function(_$CommentUserModelImpl) then,
  ) = __$$CommentUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String username, String avatarUrl});
}

/// @nodoc
class __$$CommentUserModelImplCopyWithImpl<$Res>
    extends _$CommentUserModelCopyWithImpl<$Res, _$CommentUserModelImpl>
    implements _$$CommentUserModelImplCopyWith<$Res> {
  __$$CommentUserModelImplCopyWithImpl(
    _$CommentUserModelImpl _value,
    $Res Function(_$CommentUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = null,
  }) {
    return _then(
      _$CommentUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: null == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentUserModelImpl implements _CommentUserModel {
  const _$CommentUserModelImpl({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  factory _$CommentUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentUserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String avatarUrl;

  @override
  String toString() {
    return 'CommentUserModel(id: $id, username: $username, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, avatarUrl);

  /// Create a copy of CommentUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentUserModelImplCopyWith<_$CommentUserModelImpl> get copyWith =>
      __$$CommentUserModelImplCopyWithImpl<_$CommentUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentUserModelImplToJson(this);
  }
}

abstract class _CommentUserModel implements CommentUserModel {
  const factory _CommentUserModel({
    required final int id,
    required final String username,
    required final String avatarUrl,
  }) = _$CommentUserModelImpl;

  factory _CommentUserModel.fromJson(Map<String, dynamic> json) =
      _$CommentUserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String get avatarUrl;

  /// Create a copy of CommentUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentUserModelImplCopyWith<_$CommentUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
