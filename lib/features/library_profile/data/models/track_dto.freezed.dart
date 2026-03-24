// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackDto _$TrackDtoFromJson(Map<String, dynamic> json) {
  return _TrackDto.fromJson(json);
}

/// @nodoc
mixin _$TrackDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Map<String, dynamic> get artist => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;

  /// Serializes this TrackDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackDtoCopyWith<TrackDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackDtoCopyWith<$Res> {
  factory $TrackDtoCopyWith(TrackDto value, $Res Function(TrackDto) then) =
      _$TrackDtoCopyWithImpl<$Res, TrackDto>;
  @useResult
  $Res call({
    int id,
    String title,
    Map<String, dynamic> artist,
    String? coverUrl,
    int playCount,
    int likeCount,
  });
}

/// @nodoc
class _$TrackDtoCopyWithImpl<$Res, $Val extends TrackDto>
    implements $TrackDtoCopyWith<$Res> {
  _$TrackDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? coverUrl = freezed,
    Object? playCount = null,
    Object? likeCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            artist: null == artist
                ? _value.artist
                : artist // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            playCount: null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                      as int,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackDtoImplCopyWith<$Res>
    implements $TrackDtoCopyWith<$Res> {
  factory _$$TrackDtoImplCopyWith(
    _$TrackDtoImpl value,
    $Res Function(_$TrackDtoImpl) then,
  ) = __$$TrackDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    Map<String, dynamic> artist,
    String? coverUrl,
    int playCount,
    int likeCount,
  });
}

/// @nodoc
class __$$TrackDtoImplCopyWithImpl<$Res>
    extends _$TrackDtoCopyWithImpl<$Res, _$TrackDtoImpl>
    implements _$$TrackDtoImplCopyWith<$Res> {
  __$$TrackDtoImplCopyWithImpl(
    _$TrackDtoImpl _value,
    $Res Function(_$TrackDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? coverUrl = freezed,
    Object? playCount = null,
    Object? likeCount = null,
  }) {
    return _then(
      _$TrackDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        artist: null == artist
            ? _value._artist
            : artist // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        playCount: null == playCount
            ? _value.playCount
            : playCount // ignore: cast_nullable_to_non_nullable
                  as int,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackDtoImpl extends _TrackDto {
  const _$TrackDtoImpl({
    required this.id,
    required this.title,
    required final Map<String, dynamic> artist,
    this.coverUrl,
    this.playCount = 0,
    this.likeCount = 0,
  }) : _artist = artist,
       super._();

  factory _$TrackDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  final Map<String, dynamic> _artist;
  @override
  Map<String, dynamic> get artist {
    if (_artist is EqualUnmodifiableMapView) return _artist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_artist);
  }

  @override
  final String? coverUrl;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final int likeCount;

  @override
  String toString() {
    return 'TrackDto(id: $id, title: $title, artist: $artist, coverUrl: $coverUrl, playCount: $playCount, likeCount: $likeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._artist, _artist) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_artist),
    coverUrl,
    playCount,
    likeCount,
  );

  /// Create a copy of TrackDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackDtoImplCopyWith<_$TrackDtoImpl> get copyWith =>
      __$$TrackDtoImplCopyWithImpl<_$TrackDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackDtoImplToJson(this);
  }
}

abstract class _TrackDto extends TrackDto {
  const factory _TrackDto({
    required final int id,
    required final String title,
    required final Map<String, dynamic> artist,
    final String? coverUrl,
    final int playCount,
    final int likeCount,
  }) = _$TrackDtoImpl;
  const _TrackDto._() : super._();

  factory _TrackDto.fromJson(Map<String, dynamic> json) =
      _$TrackDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  Map<String, dynamic> get artist;
  @override
  String? get coverUrl;
  @override
  int get playCount;
  @override
  int get likeCount;

  /// Create a copy of TrackDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackDtoImplCopyWith<_$TrackDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
