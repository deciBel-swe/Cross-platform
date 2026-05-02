// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'following_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FollowingUserModel _$FollowingUserModelFromJson(Map<String, dynamic> json) {
  return _FollowingUserModel.fromJson(json);
}

/// @nodoc
mixin _$FollowingUserModel {
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String get username => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get tier => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: false)
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Serializes this FollowingUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FollowingUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowingUserModelCopyWith<FollowingUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowingUserModelCopyWith<$Res> {
  factory $FollowingUserModelCopyWith(
    FollowingUserModel value,
    $Res Function(FollowingUserModel) then,
  ) = _$FollowingUserModelCopyWithImpl<$Res, FollowingUserModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _toInt, defaultValue: 0) int id,
    @JsonKey(defaultValue: '') String username,
    String? avatarUrl,
    String? tier,
    @JsonKey(defaultValue: false) bool isFollowing,
  });
}

/// @nodoc
class _$FollowingUserModelCopyWithImpl<$Res, $Val extends FollowingUserModel>
    implements $FollowingUserModelCopyWith<$Res> {
  _$FollowingUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowingUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? tier = freezed,
    Object? isFollowing = null,
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
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            tier: freezed == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$FollowingUserModelImplCopyWith<$Res>
    implements $FollowingUserModelCopyWith<$Res> {
  factory _$$FollowingUserModelImplCopyWith(
    _$FollowingUserModelImpl value,
    $Res Function(_$FollowingUserModelImpl) then,
  ) = __$$FollowingUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _toInt, defaultValue: 0) int id,
    @JsonKey(defaultValue: '') String username,
    String? avatarUrl,
    String? tier,
    @JsonKey(defaultValue: false) bool isFollowing,
  });
}

/// @nodoc
class __$$FollowingUserModelImplCopyWithImpl<$Res>
    extends _$FollowingUserModelCopyWithImpl<$Res, _$FollowingUserModelImpl>
    implements _$$FollowingUserModelImplCopyWith<$Res> {
  __$$FollowingUserModelImplCopyWithImpl(
    _$FollowingUserModelImpl _value,
    $Res Function(_$FollowingUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FollowingUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? tier = freezed,
    Object? isFollowing = null,
  }) {
    return _then(
      _$FollowingUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        tier: freezed == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$FollowingUserModelImpl implements _FollowingUserModel {
  const _$FollowingUserModelImpl({
    @JsonKey(fromJson: _toInt, defaultValue: 0) required this.id,
    @JsonKey(defaultValue: '') required this.username,
    this.avatarUrl,
    this.tier,
    @JsonKey(defaultValue: false) required this.isFollowing,
  });

  factory _$FollowingUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowingUserModelImplFromJson(json);

  @override
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  final int id;
  @override
  @JsonKey(defaultValue: '')
  final String username;
  @override
  final String? avatarUrl;
  @override
  final String? tier;
  @override
  @JsonKey(defaultValue: false)
  final bool isFollowing;

  @override
  String toString() {
    return 'FollowingUserModel(id: $id, username: $username, avatarUrl: $avatarUrl, tier: $tier, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowingUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, avatarUrl, tier, isFollowing);

  /// Create a copy of FollowingUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowingUserModelImplCopyWith<_$FollowingUserModelImpl> get copyWith =>
      __$$FollowingUserModelImplCopyWithImpl<_$FollowingUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowingUserModelImplToJson(this);
  }
}

abstract class _FollowingUserModel implements FollowingUserModel {
  const factory _FollowingUserModel({
    @JsonKey(fromJson: _toInt, defaultValue: 0) required final int id,
    @JsonKey(defaultValue: '') required final String username,
    final String? avatarUrl,
    final String? tier,
    @JsonKey(defaultValue: false) required final bool isFollowing,
  }) = _$FollowingUserModelImpl;

  factory _FollowingUserModel.fromJson(Map<String, dynamic> json) =
      _$FollowingUserModelImpl.fromJson;

  @override
  @JsonKey(fromJson: _toInt, defaultValue: 0)
  int get id;
  @override
  @JsonKey(defaultValue: '')
  String get username;
  @override
  String? get avatarUrl;
  @override
  String? get tier;
  @override
  @JsonKey(defaultValue: false)
  bool get isFollowing;

  /// Create a copy of FollowingUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowingUserModelImplCopyWith<_$FollowingUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
