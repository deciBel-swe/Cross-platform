// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_social_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PlaylistSocialData {
  bool get isLiked => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;

  /// Create a copy of PlaylistSocialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaylistSocialDataCopyWith<PlaylistSocialData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistSocialDataCopyWith<$Res> {
  factory $PlaylistSocialDataCopyWith(
    PlaylistSocialData value,
    $Res Function(PlaylistSocialData) then,
  ) = _$PlaylistSocialDataCopyWithImpl<$Res, PlaylistSocialData>;
  @useResult
  $Res call({bool isLiked, bool isReposted});
}

/// @nodoc
class _$PlaylistSocialDataCopyWithImpl<$Res, $Val extends PlaylistSocialData>
    implements $PlaylistSocialDataCopyWith<$Res> {
  _$PlaylistSocialDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaylistSocialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLiked = null, Object? isReposted = null}) {
    return _then(
      _value.copyWith(
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReposted: null == isReposted
                ? _value.isReposted
                : isReposted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaylistSocialDataImplCopyWith<$Res>
    implements $PlaylistSocialDataCopyWith<$Res> {
  factory _$$PlaylistSocialDataImplCopyWith(
    _$PlaylistSocialDataImpl value,
    $Res Function(_$PlaylistSocialDataImpl) then,
  ) = __$$PlaylistSocialDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLiked, bool isReposted});
}

/// @nodoc
class __$$PlaylistSocialDataImplCopyWithImpl<$Res>
    extends _$PlaylistSocialDataCopyWithImpl<$Res, _$PlaylistSocialDataImpl>
    implements _$$PlaylistSocialDataImplCopyWith<$Res> {
  __$$PlaylistSocialDataImplCopyWithImpl(
    _$PlaylistSocialDataImpl _value,
    $Res Function(_$PlaylistSocialDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaylistSocialData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLiked = null, Object? isReposted = null}) {
    return _then(
      _$PlaylistSocialDataImpl(
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReposted: null == isReposted
            ? _value.isReposted
            : isReposted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PlaylistSocialDataImpl implements _PlaylistSocialData {
  const _$PlaylistSocialDataImpl({
    required this.isLiked,
    required this.isReposted,
  });

  @override
  final bool isLiked;
  @override
  final bool isReposted;

  @override
  String toString() {
    return 'PlaylistSocialData(isLiked: $isLiked, isReposted: $isReposted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaylistSocialDataImpl &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isReposted, isReposted) ||
                other.isReposted == isReposted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLiked, isReposted);

  /// Create a copy of PlaylistSocialData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistSocialDataImplCopyWith<_$PlaylistSocialDataImpl> get copyWith =>
      __$$PlaylistSocialDataImplCopyWithImpl<_$PlaylistSocialDataImpl>(
        this,
        _$identity,
      );
}

abstract class _PlaylistSocialData implements PlaylistSocialData {
  const factory _PlaylistSocialData({
    required final bool isLiked,
    required final bool isReposted,
  }) = _$PlaylistSocialDataImpl;

  @override
  bool get isLiked;
  @override
  bool get isReposted;

  /// Create a copy of PlaylistSocialData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaylistSocialDataImplCopyWith<_$PlaylistSocialDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
