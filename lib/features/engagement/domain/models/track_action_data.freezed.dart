// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_action_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrackSocialData {
  bool get isLiked => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;
  int get repostCount => throw _privateConstructorUsedError;

  /// Create a copy of TrackSocialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackSocialDataCopyWith<TrackSocialData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackSocialDataCopyWith<$Res> {
  factory $TrackSocialDataCopyWith(
    TrackSocialData value,
    $Res Function(TrackSocialData) then,
  ) = _$TrackSocialDataCopyWithImpl<$Res, TrackSocialData>;
  @useResult
  $Res call({bool isLiked, int likeCount, bool isReposted, int repostCount});
}

/// @nodoc
class _$TrackSocialDataCopyWithImpl<$Res, $Val extends TrackSocialData>
    implements $TrackSocialDataCopyWith<$Res> {
  _$TrackSocialDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackSocialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLiked = null,
    Object? likeCount = null,
    Object? isReposted = null,
    Object? repostCount = null,
  }) {
    return _then(
      _value.copyWith(
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isReposted: null == isReposted
                ? _value.isReposted
                : isReposted // ignore: cast_nullable_to_non_nullable
                      as bool,
            repostCount: null == repostCount
                ? _value.repostCount
                : repostCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackSocialDataImplCopyWith<$Res>
    implements $TrackSocialDataCopyWith<$Res> {
  factory _$$TrackSocialDataImplCopyWith(
    _$TrackSocialDataImpl value,
    $Res Function(_$TrackSocialDataImpl) then,
  ) = __$$TrackSocialDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLiked, int likeCount, bool isReposted, int repostCount});
}

/// @nodoc
class __$$TrackSocialDataImplCopyWithImpl<$Res>
    extends _$TrackSocialDataCopyWithImpl<$Res, _$TrackSocialDataImpl>
    implements _$$TrackSocialDataImplCopyWith<$Res> {
  __$$TrackSocialDataImplCopyWithImpl(
    _$TrackSocialDataImpl _value,
    $Res Function(_$TrackSocialDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackSocialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLiked = null,
    Object? likeCount = null,
    Object? isReposted = null,
    Object? repostCount = null,
  }) {
    return _then(
      _$TrackSocialDataImpl(
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isReposted: null == isReposted
            ? _value.isReposted
            : isReposted // ignore: cast_nullable_to_non_nullable
                  as bool,
        repostCount: null == repostCount
            ? _value.repostCount
            : repostCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TrackSocialDataImpl implements _TrackSocialData {
  const _$TrackSocialDataImpl({
    required this.isLiked,
    required this.likeCount,
    required this.isReposted,
    required this.repostCount,
  });

  @override
  final bool isLiked;
  @override
  final int likeCount;
  @override
  final bool isReposted;
  @override
  final int repostCount;

  @override
  String toString() {
    return 'TrackSocialData(isLiked: $isLiked, likeCount: $likeCount, isReposted: $isReposted, repostCount: $repostCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackSocialDataImpl &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.isReposted, isReposted) ||
                other.isReposted == isReposted) &&
            (identical(other.repostCount, repostCount) ||
                other.repostCount == repostCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLiked, likeCount, isReposted, repostCount);

  /// Create a copy of TrackSocialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackSocialDataImplCopyWith<_$TrackSocialDataImpl> get copyWith =>
      __$$TrackSocialDataImplCopyWithImpl<_$TrackSocialDataImpl>(
        this,
        _$identity,
      );
}

abstract class _TrackSocialData implements TrackSocialData {
  const factory _TrackSocialData({
    required final bool isLiked,
    required final int likeCount,
    required final bool isReposted,
    required final int repostCount,
  }) = _$TrackSocialDataImpl;

  @override
  bool get isLiked;
  @override
  int get likeCount;
  @override
  bool get isReposted;
  @override
  int get repostCount;

  /// Create a copy of TrackSocialData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackSocialDataImplCopyWith<_$TrackSocialDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
