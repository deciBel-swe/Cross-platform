// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) {
  return _TrackModel.fromJson(json);
}

/// @nodoc
mixin _$TrackModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ArtistModel get artist => throw _privateConstructorUsedError;
  String? get trackUrl => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get waveformUrl => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  TrackStatusModel get state => throw _privateConstructorUsedError;
  DateTime get releaseDate => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get repostCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get trackDurationSeconds => throw _privateConstructorUsedError;

  /// Serializes this TrackModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackModelCopyWith<TrackModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackModelCopyWith<$Res> {
  factory $TrackModelCopyWith(
    TrackModel value,
    $Res Function(TrackModel) then,
  ) = _$TrackModelCopyWithImpl<$Res, TrackModel>;
  @useResult
  $Res call({
    int id,
    String title,
    ArtistModel artist,
    String? trackUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    List<String> tags,
    TrackStatusModel state,
    DateTime releaseDate,
    int playCount,
    int likeCount,
    int repostCount,
    bool isLiked,
    bool isReposted,
    DateTime createdAt,
    String? description,
    int trackDurationSeconds,
  });

  $ArtistModelCopyWith<$Res> get artist;
}

/// @nodoc
class _$TrackModelCopyWithImpl<$Res, $Val extends TrackModel>
    implements $TrackModelCopyWith<$Res> {
  _$TrackModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? trackUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? tags = null,
    Object? state = null,
    Object? releaseDate = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? isLiked = null,
    Object? isReposted = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? trackDurationSeconds = null,
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
                      as ArtistModel,
            trackUrl: freezed == trackUrl
                ? _value.trackUrl
                : trackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            waveformUrl: freezed == waveformUrl
                ? _value.waveformUrl
                : waveformUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as TrackStatusModel,
            releaseDate: null == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            playCount: null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                      as int,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            repostCount: null == repostCount
                ? _value.repostCount
                : repostCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReposted: null == isReposted
                ? _value.isReposted
                : isReposted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackDurationSeconds: null == trackDurationSeconds
                ? _value.trackDurationSeconds
                : trackDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ArtistModelCopyWith<$Res> get artist {
    return $ArtistModelCopyWith<$Res>(_value.artist, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrackModelImplCopyWith<$Res>
    implements $TrackModelCopyWith<$Res> {
  factory _$$TrackModelImplCopyWith(
    _$TrackModelImpl value,
    $Res Function(_$TrackModelImpl) then,
  ) = __$$TrackModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    ArtistModel artist,
    String? trackUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    List<String> tags,
    TrackStatusModel state,
    DateTime releaseDate,
    int playCount,
    int likeCount,
    int repostCount,
    bool isLiked,
    bool isReposted,
    DateTime createdAt,
    String? description,
    int trackDurationSeconds,
  });

  @override
  $ArtistModelCopyWith<$Res> get artist;
}

/// @nodoc
class __$$TrackModelImplCopyWithImpl<$Res>
    extends _$TrackModelCopyWithImpl<$Res, _$TrackModelImpl>
    implements _$$TrackModelImplCopyWith<$Res> {
  __$$TrackModelImplCopyWithImpl(
    _$TrackModelImpl _value,
    $Res Function(_$TrackModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? trackUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? tags = null,
    Object? state = null,
    Object? releaseDate = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? isLiked = null,
    Object? isReposted = null,
    Object? createdAt = null,
    Object? description = freezed,
    Object? trackDurationSeconds = null,
  }) {
    return _then(
      _$TrackModelImpl(
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
                  as ArtistModel,
        trackUrl: freezed == trackUrl
            ? _value.trackUrl
            : trackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        waveformUrl: freezed == waveformUrl
            ? _value.waveformUrl
            : waveformUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as TrackStatusModel,
        releaseDate: null == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        playCount: null == playCount
            ? _value.playCount
            : playCount // ignore: cast_nullable_to_non_nullable
                  as int,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        repostCount: null == repostCount
            ? _value.repostCount
            : repostCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReposted: null == isReposted
            ? _value.isReposted
            : isReposted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackDurationSeconds: null == trackDurationSeconds
            ? _value.trackDurationSeconds
            : trackDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackModelImpl implements _TrackModel {
  const _$TrackModelImpl({
    required this.id,
    required this.title,
    required this.artist,
    this.trackUrl,
    this.coverUrl,
    this.waveformUrl,
    this.genre = '',
    final List<String> tags = const <String>[],
    required this.state,
    required this.releaseDate,
    this.playCount = 0,
    this.likeCount = 0,
    this.repostCount = 0,
    this.isLiked = false,
    this.isReposted = false,
    required this.createdAt,
    this.description,
    this.trackDurationSeconds = 0,
  }) : _tags = tags;

  factory _$TrackModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final ArtistModel artist;
  @override
  final String? trackUrl;
  @override
  final String? coverUrl;
  @override
  final String? waveformUrl;
  @override
  @JsonKey()
  final String genre;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final TrackStatusModel state;
  @override
  final DateTime releaseDate;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int repostCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  @JsonKey()
  final bool isReposted;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  @JsonKey()
  final int trackDurationSeconds;

  @override
  String toString() {
    return 'TrackModel(id: $id, title: $title, artist: $artist, trackUrl: $trackUrl, coverUrl: $coverUrl, waveformUrl: $waveformUrl, genre: $genre, tags: $tags, state: $state, releaseDate: $releaseDate, playCount: $playCount, likeCount: $likeCount, repostCount: $repostCount, isLiked: $isLiked, isReposted: $isReposted, createdAt: $createdAt, description: $description, trackDurationSeconds: $trackDurationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.trackUrl, trackUrl) ||
                other.trackUrl == trackUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.waveformUrl, waveformUrl) ||
                other.waveformUrl == waveformUrl) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.repostCount, repostCount) ||
                other.repostCount == repostCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isReposted, isReposted) ||
                other.isReposted == isReposted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.trackDurationSeconds, trackDurationSeconds) ||
                other.trackDurationSeconds == trackDurationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    artist,
    trackUrl,
    coverUrl,
    waveformUrl,
    genre,
    const DeepCollectionEquality().hash(_tags),
    state,
    releaseDate,
    playCount,
    likeCount,
    repostCount,
    isLiked,
    isReposted,
    createdAt,
    description,
    trackDurationSeconds,
  );

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackModelImplCopyWith<_$TrackModelImpl> get copyWith =>
      __$$TrackModelImplCopyWithImpl<_$TrackModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackModelImplToJson(this);
  }
}

abstract class _TrackModel implements TrackModel {
  const factory _TrackModel({
    required final int id,
    required final String title,
    required final ArtistModel artist,
    final String? trackUrl,
    final String? coverUrl,
    final String? waveformUrl,
    final String genre,
    final List<String> tags,
    required final TrackStatusModel state,
    required final DateTime releaseDate,
    final int playCount,
    final int likeCount,
    final int repostCount,
    final bool isLiked,
    final bool isReposted,
    required final DateTime createdAt,
    final String? description,
    final int trackDurationSeconds,
  }) = _$TrackModelImpl;

  factory _TrackModel.fromJson(Map<String, dynamic> json) =
      _$TrackModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  ArtistModel get artist;
  @override
  String? get trackUrl;
  @override
  String? get coverUrl;
  @override
  String? get waveformUrl;
  @override
  String get genre;
  @override
  List<String> get tags;
  @override
  TrackStatusModel get state;
  @override
  DateTime get releaseDate;
  @override
  int get playCount;
  @override
  int get likeCount;
  @override
  int get repostCount;
  @override
  bool get isLiked;
  @override
  bool get isReposted;
  @override
  DateTime get createdAt;
  @override
  String? get description;
  @override
  int get trackDurationSeconds;

  /// Create a copy of TrackModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackModelImplCopyWith<_$TrackModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
