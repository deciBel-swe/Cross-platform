// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BlockedUserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get tier => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Create a copy of BlockedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockedUserModelCopyWith<BlockedUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockedUserModelCopyWith<$Res> {
  factory $BlockedUserModelCopyWith(
    BlockedUserModel value,
    $Res Function(BlockedUserModel) then,
  ) = _$BlockedUserModelCopyWithImpl<$Res, BlockedUserModel>;
  @useResult
  $Res call({
    int id,
    String username,
    String? avatarUrl,
    String? tier,
    bool isFollowing,
  });
}

/// @nodoc
class _$BlockedUserModelCopyWithImpl<$Res, $Val extends BlockedUserModel>
    implements $BlockedUserModelCopyWith<$Res> {
  _$BlockedUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockedUserModel
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
abstract class _$$BlockedUserModelImplCopyWith<$Res>
    implements $BlockedUserModelCopyWith<$Res> {
  factory _$$BlockedUserModelImplCopyWith(
    _$BlockedUserModelImpl value,
    $Res Function(_$BlockedUserModelImpl) then,
  ) = __$$BlockedUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String username,
    String? avatarUrl,
    String? tier,
    bool isFollowing,
  });
}

/// @nodoc
class __$$BlockedUserModelImplCopyWithImpl<$Res>
    extends _$BlockedUserModelCopyWithImpl<$Res, _$BlockedUserModelImpl>
    implements _$$BlockedUserModelImplCopyWith<$Res> {
  __$$BlockedUserModelImplCopyWithImpl(
    _$BlockedUserModelImpl _value,
    $Res Function(_$BlockedUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockedUserModel
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
      _$BlockedUserModelImpl(
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

class _$BlockedUserModelImpl implements _BlockedUserModel {
  const _$BlockedUserModelImpl({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.tier,
    required this.isFollowing,
  });

  @override
  final int id;
  @override
  final String username;
  @override
  final String? avatarUrl;
  @override
  final String? tier;
  @override
  final bool isFollowing;

  @override
  String toString() {
    return 'BlockedUserModel(id: $id, username: $username, avatarUrl: $avatarUrl, tier: $tier, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockedUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, avatarUrl, tier, isFollowing);

  /// Create a copy of BlockedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockedUserModelImplCopyWith<_$BlockedUserModelImpl> get copyWith =>
      __$$BlockedUserModelImplCopyWithImpl<_$BlockedUserModelImpl>(
        this,
        _$identity,
      );
}

abstract class _BlockedUserModel implements BlockedUserModel {
  const factory _BlockedUserModel({
    required final int id,
    required final String username,
    final String? avatarUrl,
    final String? tier,
    required final bool isFollowing,
  }) = _$BlockedUserModelImpl;

  @override
  int get id;
  @override
  String get username;
  @override
  String? get avatarUrl;
  @override
  String? get tier;
  @override
  bool get isFollowing;

  /// Create a copy of BlockedUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockedUserModelImplCopyWith<_$BlockedUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
