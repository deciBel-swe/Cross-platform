// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedTrackModel _$FeedTrackModelFromJson(Map<String, dynamic> json) {
  return _FeedTrackModel.fromJson(json);
}

/// @nodoc
mixin _$FeedTrackModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Map<String, dynamic> get artist => throw _privateConstructorUsedError;
  String? get trackUrl => throw _privateConstructorUsedError;
  String? get trackPreviewUrl => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get waveformUrl => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get access => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get releaseDate => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'CompletedPlayCount')
  int get completedPlayCount => throw _privateConstructorUsedError;
  int get repostCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  String? get uploadDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get secretToken => throw _privateConstructorUsedError;
  int get trackDurationSeconds =>
      throw _privateConstructorUsedError; // Repost envelope fields
  bool get isARepost => throw _privateConstructorUsedError;
  String? get repostedByUsername => throw _privateConstructorUsedError;
  String? get repostedByDisplayName => throw _privateConstructorUsedError;
  String? get repostedByAvatarUrl => throw _privateConstructorUsedError;
  String? get repostedAt => throw _privateConstructorUsedError;

  /// Serializes this FeedTrackModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedTrackModelCopyWith<FeedTrackModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedTrackModelCopyWith<$Res> {
  factory $FeedTrackModelCopyWith(
    FeedTrackModel value,
    $Res Function(FeedTrackModel) then,
  ) = _$FeedTrackModelCopyWithImpl<$Res, FeedTrackModel>;
  @useResult
  $Res call({
    int id,
    String title,
    Map<String, dynamic> artist,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    String slug,
    String access,
    bool isReposted,
    bool isLiked,
    List<String> tags,
    String? releaseDate,
    int playCount,
    int likeCount,
    @JsonKey(name: 'CompletedPlayCount') int completedPlayCount,
    int repostCount,
    int commentCount,
    String? uploadDate,
    String? description,
    String? secretToken,
    int trackDurationSeconds,
    bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    String? repostedAt,
  });
}

/// @nodoc
class _$FeedTrackModelCopyWithImpl<$Res, $Val extends FeedTrackModel>
    implements $FeedTrackModelCopyWith<$Res> {
  _$FeedTrackModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? slug = null,
    Object? access = null,
    Object? isReposted = null,
    Object? isLiked = null,
    Object? tags = null,
    Object? releaseDate = freezed,
    Object? playCount = null,
    Object? likeCount = null,
    Object? completedPlayCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? uploadDate = freezed,
    Object? description = freezed,
    Object? secretToken = freezed,
    Object? trackDurationSeconds = null,
    Object? isARepost = null,
    Object? repostedByUsername = freezed,
    Object? repostedByDisplayName = freezed,
    Object? repostedByAvatarUrl = freezed,
    Object? repostedAt = freezed,
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
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            access: null == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as String,
            isReposted: null == isReposted
                ? _value.isReposted
                : isReposted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            playCount: null == playCount
                ? _value.playCount
                : playCount // ignore: cast_nullable_to_non_nullable
                      as int,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            completedPlayCount: null == completedPlayCount
                ? _value.completedPlayCount
                : completedPlayCount // ignore: cast_nullable_to_non_nullable
                      as int,
            repostCount: null == repostCount
                ? _value.repostCount
                : repostCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            uploadDate: freezed == uploadDate
                ? _value.uploadDate
                : uploadDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            secretToken: freezed == secretToken
                ? _value.secretToken
                : secretToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackDurationSeconds: null == trackDurationSeconds
                ? _value.trackDurationSeconds
                : trackDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            isARepost: null == isARepost
                ? _value.isARepost
                : isARepost // ignore: cast_nullable_to_non_nullable
                      as bool,
            repostedByUsername: freezed == repostedByUsername
                ? _value.repostedByUsername
                : repostedByUsername // ignore: cast_nullable_to_non_nullable
                      as String?,
            repostedByDisplayName: freezed == repostedByDisplayName
                ? _value.repostedByDisplayName
                : repostedByDisplayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            repostedByAvatarUrl: freezed == repostedByAvatarUrl
                ? _value.repostedByAvatarUrl
                : repostedByAvatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            repostedAt: freezed == repostedAt
                ? _value.repostedAt
                : repostedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedTrackModelImplCopyWith<$Res>
    implements $FeedTrackModelCopyWith<$Res> {
  factory _$$FeedTrackModelImplCopyWith(
    _$FeedTrackModelImpl value,
    $Res Function(_$FeedTrackModelImpl) then,
  ) = __$$FeedTrackModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    Map<String, dynamic> artist,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    String slug,
    String access,
    bool isReposted,
    bool isLiked,
    List<String> tags,
    String? releaseDate,
    int playCount,
    int likeCount,
    @JsonKey(name: 'CompletedPlayCount') int completedPlayCount,
    int repostCount,
    int commentCount,
    String? uploadDate,
    String? description,
    String? secretToken,
    int trackDurationSeconds,
    bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    String? repostedAt,
  });
}

/// @nodoc
class __$$FeedTrackModelImplCopyWithImpl<$Res>
    extends _$FeedTrackModelCopyWithImpl<$Res, _$FeedTrackModelImpl>
    implements _$$FeedTrackModelImplCopyWith<$Res> {
  __$$FeedTrackModelImplCopyWithImpl(
    _$FeedTrackModelImpl _value,
    $Res Function(_$FeedTrackModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artist = null,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? slug = null,
    Object? access = null,
    Object? isReposted = null,
    Object? isLiked = null,
    Object? tags = null,
    Object? releaseDate = freezed,
    Object? playCount = null,
    Object? likeCount = null,
    Object? completedPlayCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? uploadDate = freezed,
    Object? description = freezed,
    Object? secretToken = freezed,
    Object? trackDurationSeconds = null,
    Object? isARepost = null,
    Object? repostedByUsername = freezed,
    Object? repostedByDisplayName = freezed,
    Object? repostedByAvatarUrl = freezed,
    Object? repostedAt = freezed,
  }) {
    return _then(
      _$FeedTrackModelImpl(
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
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        access: null == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as String,
        isReposted: null == isReposted
            ? _value.isReposted
            : isReposted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        playCount: null == playCount
            ? _value.playCount
            : playCount // ignore: cast_nullable_to_non_nullable
                  as int,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        completedPlayCount: null == completedPlayCount
            ? _value.completedPlayCount
            : completedPlayCount // ignore: cast_nullable_to_non_nullable
                  as int,
        repostCount: null == repostCount
            ? _value.repostCount
            : repostCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        uploadDate: freezed == uploadDate
            ? _value.uploadDate
            : uploadDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        secretToken: freezed == secretToken
            ? _value.secretToken
            : secretToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackDurationSeconds: null == trackDurationSeconds
            ? _value.trackDurationSeconds
            : trackDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        isARepost: null == isARepost
            ? _value.isARepost
            : isARepost // ignore: cast_nullable_to_non_nullable
                  as bool,
        repostedByUsername: freezed == repostedByUsername
            ? _value.repostedByUsername
            : repostedByUsername // ignore: cast_nullable_to_non_nullable
                  as String?,
        repostedByDisplayName: freezed == repostedByDisplayName
            ? _value.repostedByDisplayName
            : repostedByDisplayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        repostedByAvatarUrl: freezed == repostedByAvatarUrl
            ? _value.repostedByAvatarUrl
            : repostedByAvatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        repostedAt: freezed == repostedAt
            ? _value.repostedAt
            : repostedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$FeedTrackModelImpl extends _FeedTrackModel {
  const _$FeedTrackModelImpl({
    required this.id,
    required this.title,
    required final Map<String, dynamic> artist,
    this.trackUrl,
    this.trackPreviewUrl,
    this.coverUrl,
    this.waveformUrl,
    this.genre = '',
    this.slug = '',
    this.access = 'PLAYABLE',
    this.isReposted = false,
    this.isLiked = false,
    final List<String> tags = const <String>[],
    this.releaseDate,
    this.playCount = 0,
    this.likeCount = 0,
    @JsonKey(name: 'CompletedPlayCount') this.completedPlayCount = 0,
    this.repostCount = 0,
    this.commentCount = 0,
    this.uploadDate,
    this.description,
    this.secretToken,
    this.trackDurationSeconds = 0,
    this.isARepost = false,
    this.repostedByUsername,
    this.repostedByDisplayName,
    this.repostedByAvatarUrl,
    this.repostedAt,
  }) : _artist = artist,
       _tags = tags,
       super._();

  factory _$FeedTrackModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedTrackModelImplFromJson(json);

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
  final String? trackUrl;
  @override
  final String? trackPreviewUrl;
  @override
  final String? coverUrl;
  @override
  final String? waveformUrl;
  @override
  @JsonKey()
  final String genre;
  @override
  @JsonKey()
  final String slug;
  @override
  @JsonKey()
  final String access;
  @override
  @JsonKey()
  final bool isReposted;
  @override
  @JsonKey()
  final bool isLiked;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? releaseDate;
  @override
  @JsonKey()
  final int playCount;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey(name: 'CompletedPlayCount')
  final int completedPlayCount;
  @override
  @JsonKey()
  final int repostCount;
  @override
  @JsonKey()
  final int commentCount;
  @override
  final String? uploadDate;
  @override
  final String? description;
  @override
  final String? secretToken;
  @override
  @JsonKey()
  final int trackDurationSeconds;
  // Repost envelope fields
  @override
  @JsonKey()
  final bool isARepost;
  @override
  final String? repostedByUsername;
  @override
  final String? repostedByDisplayName;
  @override
  final String? repostedByAvatarUrl;
  @override
  final String? repostedAt;

  @override
  String toString() {
    return 'FeedTrackModel(id: $id, title: $title, artist: $artist, trackUrl: $trackUrl, trackPreviewUrl: $trackPreviewUrl, coverUrl: $coverUrl, waveformUrl: $waveformUrl, genre: $genre, slug: $slug, access: $access, isReposted: $isReposted, isLiked: $isLiked, tags: $tags, releaseDate: $releaseDate, playCount: $playCount, likeCount: $likeCount, completedPlayCount: $completedPlayCount, repostCount: $repostCount, commentCount: $commentCount, uploadDate: $uploadDate, description: $description, secretToken: $secretToken, trackDurationSeconds: $trackDurationSeconds, isARepost: $isARepost, repostedByUsername: $repostedByUsername, repostedByDisplayName: $repostedByDisplayName, repostedByAvatarUrl: $repostedByAvatarUrl, repostedAt: $repostedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedTrackModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._artist, _artist) &&
            (identical(other.trackUrl, trackUrl) ||
                other.trackUrl == trackUrl) &&
            (identical(other.trackPreviewUrl, trackPreviewUrl) ||
                other.trackPreviewUrl == trackPreviewUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.waveformUrl, waveformUrl) ||
                other.waveformUrl == waveformUrl) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.isReposted, isReposted) ||
                other.isReposted == isReposted) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.completedPlayCount, completedPlayCount) ||
                other.completedPlayCount == completedPlayCount) &&
            (identical(other.repostCount, repostCount) ||
                other.repostCount == repostCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.uploadDate, uploadDate) ||
                other.uploadDate == uploadDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.secretToken, secretToken) ||
                other.secretToken == secretToken) &&
            (identical(other.trackDurationSeconds, trackDurationSeconds) ||
                other.trackDurationSeconds == trackDurationSeconds) &&
            (identical(other.isARepost, isARepost) ||
                other.isARepost == isARepost) &&
            (identical(other.repostedByUsername, repostedByUsername) ||
                other.repostedByUsername == repostedByUsername) &&
            (identical(other.repostedByDisplayName, repostedByDisplayName) ||
                other.repostedByDisplayName == repostedByDisplayName) &&
            (identical(other.repostedByAvatarUrl, repostedByAvatarUrl) ||
                other.repostedByAvatarUrl == repostedByAvatarUrl) &&
            (identical(other.repostedAt, repostedAt) ||
                other.repostedAt == repostedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_artist),
    trackUrl,
    trackPreviewUrl,
    coverUrl,
    waveformUrl,
    genre,
    slug,
    access,
    isReposted,
    isLiked,
    const DeepCollectionEquality().hash(_tags),
    releaseDate,
    playCount,
    likeCount,
    completedPlayCount,
    repostCount,
    commentCount,
    uploadDate,
    description,
    secretToken,
    trackDurationSeconds,
    isARepost,
    repostedByUsername,
    repostedByDisplayName,
    repostedByAvatarUrl,
    repostedAt,
  ]);

  /// Create a copy of FeedTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedTrackModelImplCopyWith<_$FeedTrackModelImpl> get copyWith =>
      __$$FeedTrackModelImplCopyWithImpl<_$FeedTrackModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedTrackModelImplToJson(this);
  }
}

abstract class _FeedTrackModel extends FeedTrackModel {
  const factory _FeedTrackModel({
    required final int id,
    required final String title,
    required final Map<String, dynamic> artist,
    final String? trackUrl,
    final String? trackPreviewUrl,
    final String? coverUrl,
    final String? waveformUrl,
    final String genre,
    final String slug,
    final String access,
    final bool isReposted,
    final bool isLiked,
    final List<String> tags,
    final String? releaseDate,
    final int playCount,
    final int likeCount,
    @JsonKey(name: 'CompletedPlayCount') final int completedPlayCount,
    final int repostCount,
    final int commentCount,
    final String? uploadDate,
    final String? description,
    final String? secretToken,
    final int trackDurationSeconds,
    final bool isARepost,
    final String? repostedByUsername,
    final String? repostedByDisplayName,
    final String? repostedByAvatarUrl,
    final String? repostedAt,
  }) = _$FeedTrackModelImpl;
  const _FeedTrackModel._() : super._();

  factory _FeedTrackModel.fromJson(Map<String, dynamic> json) =
      _$FeedTrackModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  Map<String, dynamic> get artist;
  @override
  String? get trackUrl;
  @override
  String? get trackPreviewUrl;
  @override
  String? get coverUrl;
  @override
  String? get waveformUrl;
  @override
  String get genre;
  @override
  String get slug;
  @override
  String get access;
  @override
  bool get isReposted;
  @override
  bool get isLiked;
  @override
  List<String> get tags;
  @override
  String? get releaseDate;
  @override
  int get playCount;
  @override
  int get likeCount;
  @override
  @JsonKey(name: 'CompletedPlayCount')
  int get completedPlayCount;
  @override
  int get repostCount;
  @override
  int get commentCount;
  @override
  String? get uploadDate;
  @override
  String? get description;
  @override
  String? get secretToken;
  @override
  int get trackDurationSeconds; // Repost envelope fields
  @override
  bool get isARepost;
  @override
  String? get repostedByUsername;
  @override
  String? get repostedByDisplayName;
  @override
  String? get repostedByAvatarUrl;
  @override
  String? get repostedAt;

  /// Create a copy of FeedTrackModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedTrackModelImplCopyWith<_$FeedTrackModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
