// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_engager_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackEngagerModel _$TrackEngagerModelFromJson(Map<String, dynamic> json) {
  return _TrackEngagerModel.fromJson(json);
}

/// @nodoc
mixin _$TrackEngagerModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get tier => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Serializes this TrackEngagerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackEngagerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackEngagerModelCopyWith<TrackEngagerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackEngagerModelCopyWith<$Res> {
  factory $TrackEngagerModelCopyWith(
    TrackEngagerModel value,
    $Res Function(TrackEngagerModel) then,
  ) = _$TrackEngagerModelCopyWithImpl<$Res, TrackEngagerModel>;
  @useResult
  $Res call({
    int id,
    String username,
    String? avatarUrl,
    String tier,
    bool isFollowing,
  });
}

/// @nodoc
class _$TrackEngagerModelCopyWithImpl<$Res, $Val extends TrackEngagerModel>
    implements $TrackEngagerModelCopyWith<$Res> {
  _$TrackEngagerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackEngagerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? tier = null,
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
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TrackEngagerModelImplCopyWith<$Res>
    implements $TrackEngagerModelCopyWith<$Res> {
  factory _$$TrackEngagerModelImplCopyWith(
    _$TrackEngagerModelImpl value,
    $Res Function(_$TrackEngagerModelImpl) then,
  ) = __$$TrackEngagerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String username,
    String? avatarUrl,
    String tier,
    bool isFollowing,
  });
}

/// @nodoc
class __$$TrackEngagerModelImplCopyWithImpl<$Res>
    extends _$TrackEngagerModelCopyWithImpl<$Res, _$TrackEngagerModelImpl>
    implements _$$TrackEngagerModelImplCopyWith<$Res> {
  __$$TrackEngagerModelImplCopyWithImpl(
    _$TrackEngagerModelImpl _value,
    $Res Function(_$TrackEngagerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackEngagerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? avatarUrl = freezed,
    Object? tier = null,
    Object? isFollowing = null,
  }) {
    return _then(
      _$TrackEngagerModelImpl(
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
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
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
class _$TrackEngagerModelImpl implements _TrackEngagerModel {
  const _$TrackEngagerModelImpl({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.tier,
    this.isFollowing = false,
  });

  factory _$TrackEngagerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackEngagerModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String? avatarUrl;
  @override
  final String tier;
  @override
  @JsonKey()
  final bool isFollowing;

  @override
  String toString() {
    return 'TrackEngagerModel(id: $id, username: $username, avatarUrl: $avatarUrl, tier: $tier, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackEngagerModelImpl &&
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

  /// Create a copy of TrackEngagerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackEngagerModelImplCopyWith<_$TrackEngagerModelImpl> get copyWith =>
      __$$TrackEngagerModelImplCopyWithImpl<_$TrackEngagerModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackEngagerModelImplToJson(this);
  }
}

abstract class _TrackEngagerModel implements TrackEngagerModel {
  const factory _TrackEngagerModel({
    required final int id,
    required final String username,
    final String? avatarUrl,
    required final String tier,
    final bool isFollowing,
  }) = _$TrackEngagerModelImpl;

  factory _TrackEngagerModel.fromJson(Map<String, dynamic> json) =
      _$TrackEngagerModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String? get avatarUrl;
  @override
  String get tier;
  @override
  bool get isFollowing;

  /// Create a copy of TrackEngagerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackEngagerModelImplCopyWith<_$TrackEngagerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
