// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedTrack {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get artistId => throw _privateConstructorUsedError;
  String get artistUsername => throw _privateConstructorUsedError;
  String? get artistDisplayName => throw _privateConstructorUsedError;
  String? get artistAvatarUrl => throw _privateConstructorUsedError;
  String? get trackUrl => throw _privateConstructorUsedError;
  String? get trackPreviewUrl => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get waveformUrl => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  String get access => throw _privateConstructorUsedError;
  bool get isReposted => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get releaseDate => throw _privateConstructorUsedError;
  int get playCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get repostCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  DateTime get uploadDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get secretToken => throw _privateConstructorUsedError;
  int get trackDurationSeconds =>
      throw _privateConstructorUsedError; // Repost envelope
  bool get isARepost => throw _privateConstructorUsedError;
  String? get repostedByUsername => throw _privateConstructorUsedError;
  String? get repostedByDisplayName => throw _privateConstructorUsedError;
  String? get repostedByAvatarUrl => throw _privateConstructorUsedError;
  DateTime? get repostedAt => throw _privateConstructorUsedError;

  /// Create a copy of FeedTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedTrackCopyWith<FeedTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedTrackCopyWith<$Res> {
  factory $FeedTrackCopyWith(FeedTrack value, $Res Function(FeedTrack) then) =
      _$FeedTrackCopyWithImpl<$Res, FeedTrack>;
  @useResult
  $Res call({
    int id,
    String title,
    int artistId,
    String artistUsername,
    String? artistDisplayName,
    String? artistAvatarUrl,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    String access,
    bool isReposted,
    bool isLiked,
    List<String> tags,
    DateTime releaseDate,
    int playCount,
    int likeCount,
    int repostCount,
    int commentCount,
    bool isPrivate,
    DateTime uploadDate,
    String? description,
    String? secretToken,
    int trackDurationSeconds,
    bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    DateTime? repostedAt,
  });
}

/// @nodoc
class _$FeedTrackCopyWithImpl<$Res, $Val extends FeedTrack>
    implements $FeedTrackCopyWith<$Res> {
  _$FeedTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artistId = null,
    Object? artistUsername = null,
    Object? artistDisplayName = freezed,
    Object? artistAvatarUrl = freezed,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? access = null,
    Object? isReposted = null,
    Object? isLiked = null,
    Object? tags = null,
    Object? releaseDate = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? isPrivate = null,
    Object? uploadDate = null,
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
            artistId: null == artistId
                ? _value.artistId
                : artistId // ignore: cast_nullable_to_non_nullable
                      as int,
            artistUsername: null == artistUsername
                ? _value.artistUsername
                : artistUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            artistDisplayName: freezed == artistDisplayName
                ? _value.artistDisplayName
                : artistDisplayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            artistAvatarUrl: freezed == artistAvatarUrl
                ? _value.artistAvatarUrl
                : artistAvatarUrl // ignore: cast_nullable_to_non_nullable
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
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
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
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            uploadDate: null == uploadDate
                ? _value.uploadDate
                : uploadDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedTrackImplCopyWith<$Res>
    implements $FeedTrackCopyWith<$Res> {
  factory _$$FeedTrackImplCopyWith(
    _$FeedTrackImpl value,
    $Res Function(_$FeedTrackImpl) then,
  ) = __$$FeedTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    int artistId,
    String artistUsername,
    String? artistDisplayName,
    String? artistAvatarUrl,
    String? trackUrl,
    String? trackPreviewUrl,
    String? coverUrl,
    String? waveformUrl,
    String genre,
    String access,
    bool isReposted,
    bool isLiked,
    List<String> tags,
    DateTime releaseDate,
    int playCount,
    int likeCount,
    int repostCount,
    int commentCount,
    bool isPrivate,
    DateTime uploadDate,
    String? description,
    String? secretToken,
    int trackDurationSeconds,
    bool isARepost,
    String? repostedByUsername,
    String? repostedByDisplayName,
    String? repostedByAvatarUrl,
    DateTime? repostedAt,
  });
}

/// @nodoc
class __$$FeedTrackImplCopyWithImpl<$Res>
    extends _$FeedTrackCopyWithImpl<$Res, _$FeedTrackImpl>
    implements _$$FeedTrackImplCopyWith<$Res> {
  __$$FeedTrackImplCopyWithImpl(
    _$FeedTrackImpl _value,
    $Res Function(_$FeedTrackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedTrack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artistId = null,
    Object? artistUsername = null,
    Object? artistDisplayName = freezed,
    Object? artistAvatarUrl = freezed,
    Object? trackUrl = freezed,
    Object? trackPreviewUrl = freezed,
    Object? coverUrl = freezed,
    Object? waveformUrl = freezed,
    Object? genre = null,
    Object? access = null,
    Object? isReposted = null,
    Object? isLiked = null,
    Object? tags = null,
    Object? releaseDate = null,
    Object? playCount = null,
    Object? likeCount = null,
    Object? repostCount = null,
    Object? commentCount = null,
    Object? isPrivate = null,
    Object? uploadDate = null,
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
      _$FeedTrackImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        artistId: null == artistId
            ? _value.artistId
            : artistId // ignore: cast_nullable_to_non_nullable
                  as int,
        artistUsername: null == artistUsername
            ? _value.artistUsername
            : artistUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        artistDisplayName: freezed == artistDisplayName
            ? _value.artistDisplayName
            : artistDisplayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        artistAvatarUrl: freezed == artistAvatarUrl
            ? _value.artistAvatarUrl
            : artistAvatarUrl // ignore: cast_nullable_to_non_nullable
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
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
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
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        uploadDate: null == uploadDate
            ? _value.uploadDate
            : uploadDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$FeedTrackImpl extends _FeedTrack {
  const _$FeedTrackImpl({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistUsername,
    this.artistDisplayName,
    this.artistAvatarUrl,
    this.trackUrl,
    this.trackPreviewUrl,
    this.coverUrl,
    this.waveformUrl,
    required this.genre,
    required this.access,
    required this.isReposted,
    required this.isLiked,
    required final List<String> tags,
    required this.releaseDate,
    required this.playCount,
    required this.likeCount,
    required this.repostCount,
    required this.commentCount,
    required this.isPrivate,
    required this.uploadDate,
    this.description,
    this.secretToken,
    required this.trackDurationSeconds,
    this.isARepost = false,
    this.repostedByUsername,
    this.repostedByDisplayName,
    this.repostedByAvatarUrl,
    this.repostedAt,
  }) : _tags = tags,
       super._();

  @override
  final int id;
  @override
  final String title;
  @override
  final int artistId;
  @override
  final String artistUsername;
  @override
  final String? artistDisplayName;
  @override
  final String? artistAvatarUrl;
  @override
  final String? trackUrl;
  @override
  final String? trackPreviewUrl;
  @override
  final String? coverUrl;
  @override
  final String? waveformUrl;
  @override
  final String genre;
  @override
  final String access;
  @override
  final bool isReposted;
  @override
  final bool isLiked;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime releaseDate;
  @override
  final int playCount;
  @override
  final int likeCount;
  @override
  final int repostCount;
  @override
  final int commentCount;
  @override
  final bool isPrivate;
  @override
  final DateTime uploadDate;
  @override
  final String? description;
  @override
  final String? secretToken;
  @override
  final int trackDurationSeconds;
  // Repost envelope
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
  final DateTime? repostedAt;

  @override
  String toString() {
    return 'FeedTrack(id: $id, title: $title, artistId: $artistId, artistUsername: $artistUsername, artistDisplayName: $artistDisplayName, artistAvatarUrl: $artistAvatarUrl, trackUrl: $trackUrl, trackPreviewUrl: $trackPreviewUrl, coverUrl: $coverUrl, waveformUrl: $waveformUrl, genre: $genre, access: $access, isReposted: $isReposted, isLiked: $isLiked, tags: $tags, releaseDate: $releaseDate, playCount: $playCount, likeCount: $likeCount, repostCount: $repostCount, commentCount: $commentCount, isPrivate: $isPrivate, uploadDate: $uploadDate, description: $description, secretToken: $secretToken, trackDurationSeconds: $trackDurationSeconds, isARepost: $isARepost, repostedByUsername: $repostedByUsername, repostedByDisplayName: $repostedByDisplayName, repostedByAvatarUrl: $repostedByAvatarUrl, repostedAt: $repostedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedTrackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.artistUsername, artistUsername) ||
                other.artistUsername == artistUsername) &&
            (identical(other.artistDisplayName, artistDisplayName) ||
                other.artistDisplayName == artistDisplayName) &&
            (identical(other.artistAvatarUrl, artistAvatarUrl) ||
                other.artistAvatarUrl == artistAvatarUrl) &&
            (identical(other.trackUrl, trackUrl) ||
                other.trackUrl == trackUrl) &&
            (identical(other.trackPreviewUrl, trackPreviewUrl) ||
                other.trackPreviewUrl == trackPreviewUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.waveformUrl, waveformUrl) ||
                other.waveformUrl == waveformUrl) &&
            (identical(other.genre, genre) || other.genre == genre) &&
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
            (identical(other.repostCount, repostCount) ||
                other.repostCount == repostCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
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

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    artistId,
    artistUsername,
    artistDisplayName,
    artistAvatarUrl,
    trackUrl,
    trackPreviewUrl,
    coverUrl,
    waveformUrl,
    genre,
    access,
    isReposted,
    isLiked,
    const DeepCollectionEquality().hash(_tags),
    releaseDate,
    playCount,
    likeCount,
    repostCount,
    commentCount,
    isPrivate,
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

  /// Create a copy of FeedTrack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedTrackImplCopyWith<_$FeedTrackImpl> get copyWith =>
      __$$FeedTrackImplCopyWithImpl<_$FeedTrackImpl>(this, _$identity);
}

abstract class _FeedTrack extends FeedTrack {
  const factory _FeedTrack({
    required final int id,
    required final String title,
    required final int artistId,
    required final String artistUsername,
    final String? artistDisplayName,
    final String? artistAvatarUrl,
    final String? trackUrl,
    final String? trackPreviewUrl,
    final String? coverUrl,
    final String? waveformUrl,
    required final String genre,
    required final String access,
    required final bool isReposted,
    required final bool isLiked,
    required final List<String> tags,
    required final DateTime releaseDate,
    required final int playCount,
    required final int likeCount,
    required final int repostCount,
    required final int commentCount,
    required final bool isPrivate,
    required final DateTime uploadDate,
    final String? description,
    final String? secretToken,
    required final int trackDurationSeconds,
    final bool isARepost,
    final String? repostedByUsername,
    final String? repostedByDisplayName,
    final String? repostedByAvatarUrl,
    final DateTime? repostedAt,
  }) = _$FeedTrackImpl;
  const _FeedTrack._() : super._();

  @override
  int get id;
  @override
  String get title;
  @override
  int get artistId;
  @override
  String get artistUsername;
  @override
  String? get artistDisplayName;
  @override
  String? get artistAvatarUrl;
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
  String get access;
  @override
  bool get isReposted;
  @override
  bool get isLiked;
  @override
  List<String> get tags;
  @override
  DateTime get releaseDate;
  @override
  int get playCount;
  @override
  int get likeCount;
  @override
  int get repostCount;
  @override
  int get commentCount;
  @override
  bool get isPrivate;
  @override
  DateTime get uploadDate;
  @override
  String? get description;
  @override
  String? get secretToken;
  @override
  int get trackDurationSeconds; // Repost envelope
  @override
  bool get isARepost;
  @override
  String? get repostedByUsername;
  @override
  String? get repostedByDisplayName;
  @override
  String? get repostedByAvatarUrl;
  @override
  DateTime? get repostedAt;

  /// Create a copy of FeedTrack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedTrackImplCopyWith<_$FeedTrackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
