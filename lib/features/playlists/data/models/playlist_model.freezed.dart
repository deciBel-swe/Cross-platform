// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return _PlaylistModel.fromJson(json);
}

/// @nodoc
mixin _$PlaylistModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  @JsonKey(name: 'coverArtUrl')
  String? get coverArt => throw _privateConstructorUsedError;
  OwnerModel? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'trackSummaryDto')
  @PlaylistTracksConverter()
  List<TrackModel> get tracks => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  int get trackCount => throw _privateConstructorUsedError;
  String? get playlistSlug => throw _privateConstructorUsedError;
  String? get firstTrackWaveformUrl => throw _privateConstructorUsedError;
  String? get secretToken => throw _privateConstructorUsedError;
  String? get access => throw _privateConstructorUsedError;
  List<String>? get genres => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PlaylistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaylistModelCopyWith<PlaylistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistModelCopyWith<$Res> {
  factory $PlaylistModelCopyWith(
    PlaylistModel value,
    $Res Function(PlaylistModel) then,
  ) = _$PlaylistModelCopyWithImpl<$Res, PlaylistModel>;
  @useResult
  $Res call({
    int id,
    String title,
    String? description,
    String type,
    bool isPrivate,
    bool isLiked,
    @JsonKey(name: 'coverArtUrl') String? coverArt,
    OwnerModel? owner,
    @JsonKey(name: 'trackSummaryDto')
    @PlaylistTracksConverter()
    List<TrackModel> tracks,
    int totalDurationSeconds,
    int trackCount,
    String? playlistSlug,
    String? firstTrackWaveformUrl,
    String? secretToken,
    String? access,
    List<String>? genres,
    DateTime? createdAt,
  });

  $OwnerModelCopyWith<$Res>? get owner;
}

/// @nodoc
class _$PlaylistModelCopyWithImpl<$Res, $Val extends PlaylistModel>
    implements $PlaylistModelCopyWith<$Res> {
  _$PlaylistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? isPrivate = null,
    Object? isLiked = null,
    Object? coverArt = freezed,
    Object? owner = freezed,
    Object? tracks = null,
    Object? totalDurationSeconds = null,
    Object? trackCount = null,
    Object? playlistSlug = freezed,
    Object? firstTrackWaveformUrl = freezed,
    Object? secretToken = freezed,
    Object? access = freezed,
    Object? genres = freezed,
    Object? createdAt = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            coverArt: freezed == coverArt
                ? _value.coverArt
                : coverArt // ignore: cast_nullable_to_non_nullable
                      as String?,
            owner: freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as OwnerModel?,
            tracks: null == tracks
                ? _value.tracks
                : tracks // ignore: cast_nullable_to_non_nullable
                      as List<TrackModel>,
            totalDurationSeconds: null == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            trackCount: null == trackCount
                ? _value.trackCount
                : trackCount // ignore: cast_nullable_to_non_nullable
                      as int,
            playlistSlug: freezed == playlistSlug
                ? _value.playlistSlug
                : playlistSlug // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstTrackWaveformUrl: freezed == firstTrackWaveformUrl
                ? _value.firstTrackWaveformUrl
                : firstTrackWaveformUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            secretToken: freezed == secretToken
                ? _value.secretToken
                : secretToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            access: freezed == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as String?,
            genres: freezed == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OwnerModelCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $OwnerModelCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaylistModelImplCopyWith<$Res>
    implements $PlaylistModelCopyWith<$Res> {
  factory _$$PlaylistModelImplCopyWith(
    _$PlaylistModelImpl value,
    $Res Function(_$PlaylistModelImpl) then,
  ) = __$$PlaylistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String? description,
    String type,
    bool isPrivate,
    bool isLiked,
    @JsonKey(name: 'coverArtUrl') String? coverArt,
    OwnerModel? owner,
    @JsonKey(name: 'trackSummaryDto')
    @PlaylistTracksConverter()
    List<TrackModel> tracks,
    int totalDurationSeconds,
    int trackCount,
    String? playlistSlug,
    String? firstTrackWaveformUrl,
    String? secretToken,
    String? access,
    List<String>? genres,
    DateTime? createdAt,
  });

  @override
  $OwnerModelCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$PlaylistModelImplCopyWithImpl<$Res>
    extends _$PlaylistModelCopyWithImpl<$Res, _$PlaylistModelImpl>
    implements _$$PlaylistModelImplCopyWith<$Res> {
  __$$PlaylistModelImplCopyWithImpl(
    _$PlaylistModelImpl _value,
    $Res Function(_$PlaylistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? isPrivate = null,
    Object? isLiked = null,
    Object? coverArt = freezed,
    Object? owner = freezed,
    Object? tracks = null,
    Object? totalDurationSeconds = null,
    Object? trackCount = null,
    Object? playlistSlug = freezed,
    Object? firstTrackWaveformUrl = freezed,
    Object? secretToken = freezed,
    Object? access = freezed,
    Object? genres = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PlaylistModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        coverArt: freezed == coverArt
            ? _value.coverArt
            : coverArt // ignore: cast_nullable_to_non_nullable
                  as String?,
        owner: freezed == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as OwnerModel?,
        tracks: null == tracks
            ? _value._tracks
            : tracks // ignore: cast_nullable_to_non_nullable
                  as List<TrackModel>,
        totalDurationSeconds: null == totalDurationSeconds
            ? _value.totalDurationSeconds
            : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        trackCount: null == trackCount
            ? _value.trackCount
            : trackCount // ignore: cast_nullable_to_non_nullable
                  as int,
        playlistSlug: freezed == playlistSlug
            ? _value.playlistSlug
            : playlistSlug // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstTrackWaveformUrl: freezed == firstTrackWaveformUrl
            ? _value.firstTrackWaveformUrl
            : firstTrackWaveformUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        secretToken: freezed == secretToken
            ? _value.secretToken
            : secretToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        access: freezed == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as String?,
        genres: freezed == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaylistModelImpl implements _PlaylistModel {
  const _$PlaylistModelImpl({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.isPrivate = false,
    this.isLiked = false,
    @JsonKey(name: 'coverArtUrl') this.coverArt,
    this.owner,
    @JsonKey(name: 'trackSummaryDto')
    @PlaylistTracksConverter()
    final List<TrackModel> tracks = const [],
    this.totalDurationSeconds = 0,
    this.trackCount = 0,
    this.playlistSlug,
    this.firstTrackWaveformUrl,
    this.secretToken,
    this.access,
    final List<String>? genres,
    this.createdAt,
  }) : _tracks = tracks,
       _genres = genres;

  factory _$PlaylistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaylistModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String type;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  @JsonKey(name: 'coverArtUrl')
  final String? coverArt;
  @override
  final OwnerModel? owner;
  final List<TrackModel> _tracks;
  @override
  @JsonKey(name: 'trackSummaryDto')
  @PlaylistTracksConverter()
  List<TrackModel> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  @override
  @JsonKey()
  final int totalDurationSeconds;
  @override
  @JsonKey()
  final int trackCount;
  @override
  final String? playlistSlug;
  @override
  final String? firstTrackWaveformUrl;
  @override
  final String? secretToken;
  @override
  final String? access;
  final List<String>? _genres;
  @override
  List<String>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PlaylistModel(id: $id, title: $title, description: $description, type: $type, isPrivate: $isPrivate, isLiked: $isLiked, coverArt: $coverArt, owner: $owner, tracks: $tracks, totalDurationSeconds: $totalDurationSeconds, trackCount: $trackCount, playlistSlug: $playlistSlug, firstTrackWaveformUrl: $firstTrackWaveformUrl, secretToken: $secretToken, access: $access, genres: $genres, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaylistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.coverArt, coverArt) ||
                other.coverArt == coverArt) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._tracks, _tracks) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.trackCount, trackCount) ||
                other.trackCount == trackCount) &&
            (identical(other.playlistSlug, playlistSlug) ||
                other.playlistSlug == playlistSlug) &&
            (identical(other.firstTrackWaveformUrl, firstTrackWaveformUrl) ||
                other.firstTrackWaveformUrl == firstTrackWaveformUrl) &&
            (identical(other.secretToken, secretToken) ||
                other.secretToken == secretToken) &&
            (identical(other.access, access) || other.access == access) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    type,
    isPrivate,
    isLiked,
    coverArt,
    owner,
    const DeepCollectionEquality().hash(_tracks),
    totalDurationSeconds,
    trackCount,
    playlistSlug,
    firstTrackWaveformUrl,
    secretToken,
    access,
    const DeepCollectionEquality().hash(_genres),
    createdAt,
  );

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistModelImplCopyWith<_$PlaylistModelImpl> get copyWith =>
      __$$PlaylistModelImplCopyWithImpl<_$PlaylistModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaylistModelImplToJson(this);
  }
}

abstract class _PlaylistModel implements PlaylistModel {
  const factory _PlaylistModel({
    required final int id,
    required final String title,
    final String? description,
    required final String type,
    final bool isPrivate,
    final bool isLiked,
    @JsonKey(name: 'coverArtUrl') final String? coverArt,
    final OwnerModel? owner,
    @JsonKey(name: 'trackSummaryDto')
    @PlaylistTracksConverter()
    final List<TrackModel> tracks,
    final int totalDurationSeconds,
    final int trackCount,
    final String? playlistSlug,
    final String? firstTrackWaveformUrl,
    final String? secretToken,
    final String? access,
    final List<String>? genres,
    final DateTime? createdAt,
  }) = _$PlaylistModelImpl;

  factory _PlaylistModel.fromJson(Map<String, dynamic> json) =
      _$PlaylistModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get type;
  @override
  bool get isPrivate;
  @override
  bool get isLiked;
  @override
  @JsonKey(name: 'coverArtUrl')
  String? get coverArt;
  @override
  OwnerModel? get owner;
  @override
  @JsonKey(name: 'trackSummaryDto')
  @PlaylistTracksConverter()
  List<TrackModel> get tracks;
  @override
  int get totalDurationSeconds;
  @override
  int get trackCount;
  @override
  String? get playlistSlug;
  @override
  String? get firstTrackWaveformUrl;
  @override
  String? get secretToken;
  @override
  String? get access;
  @override
  List<String>? get genres;
  @override
  DateTime? get createdAt;

  /// Create a copy of PlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaylistModelImplCopyWith<_$PlaylistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
