// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscoveryTrackModel _$DiscoveryTrackModelFromJson(Map<String, dynamic> json) {
  return _DiscoveryTrackModel.fromJson(json);
}

/// @nodoc
mixin _$DiscoveryTrackModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DiscoveryUserModel get artist => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get trackUrl => throw _privateConstructorUsedError;
  String? get trackPreviewUrl => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get waveformUrl => throw _privateConstructorUsedError;
  String? get genre => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get availability => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get repostCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  int? get durationSeconds => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get secretToken => throw _privateConstructorUsedError;

  /// Serializes this DiscoveryTrackModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoveryTrackModelCopyWith<DiscoveryTrackModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoveryTrackModelCopyWith<$Res> {
  factory $DiscoveryTrackModelCopyWith(
    DiscoveryTrackModel value,
    $Res Function(DiscoveryTrackModel) then,
  ) = _$DiscoveryTrackModelCopyWithImpl<$Res, DiscoveryTrackModel>;
  @useResult
  $Res call({
    int id,
    String title,
    DiscoveryUserModel artist,
    String? slug,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String? genre,
    List<String> tags,
    String? availability,
    bool isLiked,
    bool isReposted,
    int playCount,
    int likeCount,
    int repostCount,
    int commentCount,
    DateTime? releaseDate,
    DateTime? createdAt,
    int? durationSeconds,
    String? description,
    String? secretToken,
  });

  $DiscoveryUserModelCopyWith<$Res> get artist;
}

/// @nodoc
class _$DiscoveryTrackModelCopyWithImpl<$Res, $Val extends DiscoveryTrackModel>
    implements $DiscoveryTrackModelCopyWith<$Res> {
  _$DiscoveryTrackModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? slug = freezed,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = freezed,
    Object? tags = null,
    Object? availability = freezed,
    Object? isLiked = null,
    Object? isReposted = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? releaseDate = freezed,
    Object? createdAt = freezed,
    Object? durationSeconds = freezed,
    Object? description = freezed,
    Object? secretToken = freezed,
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
                      as DiscoveryUserModel,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackUrl: freezed == trackUrl
                ? _value.trackUrl
                : trackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackPreviewUrl: freezed == trackPreviewUrl
                ? _value.trackPreviewUrl
                : trackPreviewUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            waveformUrl: freezed == waveformUrl
                ? _value.waveformUrl
                : waveformUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            genre: freezed == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            availability: freezed == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isReposted: null == isReposted
                ? _value.isReposted
                : isReposted // ignore: cast_nullable_to_non_nullable
                      as bool,
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
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            durationSeconds: freezed == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            secretToken: freezed == secretToken
                ? _value.secretToken
                : secretToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscoveryUserModelCopyWith<$Res> get artist {
    return $DiscoveryUserModelCopyWith<$Res>(_value.artist, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscoveryTrackModelImplCopyWith<$Res>
    implements $DiscoveryTrackModelCopyWith<$Res> {
  factory _$$DiscoveryTrackModelImplCopyWith(
    _$DiscoveryTrackModelImpl value,
    $Res Function(_$DiscoveryTrackModelImpl) then,
  ) = __$$DiscoveryTrackModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    DiscoveryUserModel artist,
    String? slug,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String? genre,
    List<String> tags,
    String? availability,
    bool isLiked,
    bool isReposted,
    int playCount,
    int likeCount,
    int repostCount,
    int commentCount,
    DateTime? releaseDate,
    DateTime? createdAt,
    int? durationSeconds,
    String? description,
    String? secretToken,
  });

  @override
  $DiscoveryUserModelCopyWith<$Res> get artist;
}

/// @nodoc
class __$$DiscoveryTrackModelImplCopyWithImpl<$Res>
    extends _$DiscoveryTrackModelCopyWithImpl<$Res, _$DiscoveryTrackModelImpl>
    implements _$$DiscoveryTrackModelImplCopyWith<$Res> {
  __$$DiscoveryTrackModelImplCopyWithImpl(
    _$DiscoveryTrackModelImpl _value,
    $Res Function(_$DiscoveryTrackModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? slug = freezed,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = freezed,
    Object? tags = null,
    Object? availability = freezed,
    Object? isLiked = null,
    Object? isReposted = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? releaseDate = freezed,
    Object? createdAt = freezed,
    Object? durationSeconds = freezed,
    Object? description = freezed,
    Object? secretToken = freezed,
  }) {
    return _then(
      _$DiscoveryTrackModelImpl(
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
                  as DiscoveryUserModel,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackUrl: freezed == trackUrl
            ? _value.trackUrl
            : trackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackPreviewUrl: freezed == trackPreviewUrl
            ? _value.trackPreviewUrl
            : trackPreviewUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        waveformUrl: freezed == waveformUrl
            ? _value.waveformUrl
            : waveformUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        genre: freezed == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        availability: freezed == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isReposted: null == isReposted
            ? _value.isReposted
            : isReposted // ignore: cast_nullable_to_non_nullable
                  as bool,
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
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        durationSeconds: freezed == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        secretToken: freezed == secretToken
            ? _value.secretToken
            : secretToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscoveryTrackModelImpl implements _DiscoveryTrackModel {
  const _$DiscoveryTrackModelImpl({
    required this.id,
    required this.title,
    required this.artist,
    this.slug,
    this.trackUrl,
    this.trackPreviewUrl,
    this.coverUrl,
    this.waveformUrl,
    this.genre,
    final List<String> tags = const <String>[],
    this.availability,
    this.isLiked = false,
    this.isReposted = false,
    this.playCount = 0,
    this.likeCount = 0,
    this.repostCount = 0,
    this.commentCount = 0,
    this.releaseDate,
    this.createdAt,
    this.durationSeconds,
    this.description,
    this.secretToken,
  }) : _tags = tags;

  factory _$DiscoveryTrackModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscoveryTrackModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final DiscoveryUserModel artist;
  @override
  final String? slug;
  @override
  final String? trackUrl;
  @override
  final String? trackPreviewUrl;
  @override
  final String? coverUrl;
  @override
  final String? waveformUrl;
  @override
  final String? genre;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? availability;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  @JsonKey()
  final bool isReposted;
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
  final int commentCount;
  @override
  final DateTime? releaseDate;
  @override
  final DateTime? createdAt;
  @override
  final int? durationSeconds;
  @override
  final String? description;
  @override
  final String? secretToken;

  @override
  String toString() {
    return 'DiscoveryTrackModel(id: $id, title: $title, artist: $artist, slug: $slug, trackUrl: $trackUrl, trackPreviewUrl: $trackPreviewUrl, coverUrl: $coverUrl, waveformUrl: $waveformUrl, genre: $genre, tags: $tags, availability: $availability, isLiked: $isLiked, isReposted: $isReposted, playCount: $playCount, likeCount: $likeCount, repostCount: $repostCount, commentCount: $commentCount, releaseDate: $releaseDate, createdAt: $createdAt, durationSeconds: $durationSeconds, description: $description, secretToken: $secretToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoveryTrackModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.trackUrl, trackUrl) ||
                other.trackUrl == trackUrl) &&
            (identical(other.trackPreviewUrl, trackPreviewUrl) ||
                other.trackPreviewUrl == trackPreviewUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.waveformUrl, waveformUrl) ||
                other.waveformUrl == waveformUrl) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isReposted, isReposted) ||
                other.isReposted == isReposted) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.repostCount, repostCount) ||
                other.repostCount == repostCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.secretToken, secretToken) ||
                other.secretToken == secretToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    artist,
    slug,
    trackUrl,
    trackPreviewUrl,
    coverUrl,
    waveformUrl,
    genre,
    const DeepCollectionEquality().hash(_tags),
    availability,
    isLiked,
    isReposted,
    playCount,
    likeCount,
    repostCount,
    commentCount,
    releaseDate,
    createdAt,
    durationSeconds,
    description,
    secretToken,
  ]);

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoveryTrackModelImplCopyWith<_$DiscoveryTrackModelImpl> get copyWith =>
      __$$DiscoveryTrackModelImplCopyWithImpl<_$DiscoveryTrackModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoveryTrackModelImplToJson(this);
  }
}

abstract class _DiscoveryTrackModel implements DiscoveryTrackModel {
  const factory _DiscoveryTrackModel({
    required final int id,
    required final String title,
    required final DiscoveryUserModel artist,
    final String? slug,
    final String? trackUrl,
    final String? trackPreviewUrl,
    final String? coverUrl,
    final String? waveformUrl,
    final String? genre,
    final List<String> tags,
    final String? availability,
    final bool isLiked,
    final bool isReposted,
    final int playCount,
    final int likeCount,
    final int repostCount,
    final int commentCount,
    final DateTime? releaseDate,
    final DateTime? createdAt,
    final int? durationSeconds,
    final String? description,
    final String? secretToken,
  }) = _$DiscoveryTrackModelImpl;

  factory _DiscoveryTrackModel.fromJson(Map<String, dynamic> json) =
      _$DiscoveryTrackModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  DiscoveryUserModel get artist;
  @override
  String? get slug;
  @override
  String? get trackUrl;
  @override
  String? get trackPreviewUrl;
  @override
  String? get coverUrl;
  @override
  String? get waveformUrl;
  @override
  String? get genre;
  @override
  List<String> get tags;
  @override
  String? get availability;
  @override
  bool get isLiked;
  @override
  bool get isReposted;
  @override
  int get playCount;
  @override
  int get likeCount;
  @override
  int get repostCount;
  @override
  int get commentCount;
  @override
  DateTime? get releaseDate;
  @override
  DateTime? get createdAt;
  @override
  int? get durationSeconds;
  @override
  String? get description;
  @override
  String? get secretToken;

  /// Create a copy of DiscoveryTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoveryTrackModelImplCopyWith<_$DiscoveryTrackModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
