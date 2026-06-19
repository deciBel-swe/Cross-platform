// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscoveryUserModel _$DiscoveryUserModelFromJson(Map<String, dynamic> json) {
  return _DiscoveryUserModel.fromJson(json);
}

/// @nodoc
mixin _$DiscoveryUserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get trackCount => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this DiscoveryUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoveryUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoveryUserModelCopyWith<DiscoveryUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoveryUserModelCopyWith<$Res> {
  factory $DiscoveryUserModelCopyWith(
    DiscoveryUserModel value,
    $Res Function(DiscoveryUserModel) then,
  ) = _$DiscoveryUserModelCopyWithImpl<$Res, DiscoveryUserModel>;
  @useResult
  $Res call({
    int id,
    String username,
    String? displayName,
    bool isFollowing,
    int followerCount,
    int trackCount,
    String? avatarUrl,
  });
}

/// @nodoc
class _$DiscoveryUserModelCopyWithImpl<$Res, $Val extends DiscoveryUserModel>
    implements $DiscoveryUserModelCopyWith<$Res> {
  _$DiscoveryUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoveryUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? isFollowing = null,
    Object? followerCount = null,
    Object? trackCount = null,
    Object? avatarUrl = freezed,
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
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFollowing: null == isFollowing
                ? _value.isFollowing
                : isFollowing // ignore: cast_nullable_to_non_nullable
                      as bool,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            trackCount: null == trackCount
                ? _value.trackCount
                : trackCount // ignore: cast_nullable_to_non_nullable
                      as int,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscoveryUserModelImplCopyWith<$Res>
    implements $DiscoveryUserModelCopyWith<$Res> {
  factory _$$DiscoveryUserModelImplCopyWith(
    _$DiscoveryUserModelImpl value,
    $Res Function(_$DiscoveryUserModelImpl) then,
  ) = __$$DiscoveryUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String username,
    String? displayName,
    bool isFollowing,
    int followerCount,
    int trackCount,
    String? avatarUrl,
  });
}

/// @nodoc
class __$$DiscoveryUserModelImplCopyWithImpl<$Res>
    extends _$DiscoveryUserModelCopyWithImpl<$Res, _$DiscoveryUserModelImpl>
    implements _$$DiscoveryUserModelImplCopyWith<$Res> {
  __$$DiscoveryUserModelImplCopyWithImpl(
    _$DiscoveryUserModelImpl _value,
    $Res Function(_$DiscoveryUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoveryUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? isFollowing = null,
    Object? followerCount = null,
    Object? trackCount = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$DiscoveryUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFollowing: null == isFollowing
            ? _value.isFollowing
            : isFollowing // ignore: cast_nullable_to_non_nullable
                  as bool,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        trackCount: null == trackCount
            ? _value.trackCount
            : trackCount // ignore: cast_nullable_to_non_nullable
                  as int,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscoveryUserModelImpl implements _DiscoveryUserModel {
  const _$DiscoveryUserModelImpl({
    required this.id,
    required this.username,
    this.displayName,
    this.isFollowing = false,
    this.followerCount = 0,
    this.trackCount = 0,
    this.avatarUrl,
  });

  factory _$DiscoveryUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscoveryUserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  @JsonKey()
  final bool isFollowing;
  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int trackCount;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'DiscoveryUserModel(id: $id, username: $username, displayName: $displayName, isFollowing: $isFollowing, followerCount: $followerCount, trackCount: $trackCount, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoveryUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.trackCount, trackCount) ||
                other.trackCount == trackCount) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    displayName,
    isFollowing,
    followerCount,
    trackCount,
    avatarUrl,
  );

  /// Create a copy of DiscoveryUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoveryUserModelImplCopyWith<_$DiscoveryUserModelImpl> get copyWith =>
      __$$DiscoveryUserModelImplCopyWithImpl<_$DiscoveryUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoveryUserModelImplToJson(this);
  }
}

abstract class _DiscoveryUserModel implements DiscoveryUserModel {
  const factory _DiscoveryUserModel({
    required final int id,
    required final String username,
    final String? displayName,
    final bool isFollowing,
    final int followerCount,
    final int trackCount,
    final String? avatarUrl,
  }) = _$DiscoveryUserModelImpl;

  factory _DiscoveryUserModel.fromJson(Map<String, dynamic> json) =
      _$DiscoveryUserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String? get displayName;
  @override
  bool get isFollowing;
  @override
  int get followerCount;
  @override
  int get trackCount;
  @override
  String? get avatarUrl;

  /// Create a copy of DiscoveryUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoveryUserModelImplCopyWith<_$DiscoveryUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
