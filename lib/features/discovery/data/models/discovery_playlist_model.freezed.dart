// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_playlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscoveryPlaylistModel _$DiscoveryPlaylistModelFromJson(
  Map<String, dynamic> json,
) {
  return _DiscoveryPlaylistModel.fromJson(json);
}

/// @nodoc
mixin _$DiscoveryPlaylistModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DiscoveryUserModel get owner => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  String? get coverArtUrl => throw _privateConstructorUsedError;
  String? get playlistSlug => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  int get trackCount => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DiscoveryPlaylistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoveryPlaylistModelCopyWith<DiscoveryPlaylistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoveryPlaylistModelCopyWith<$Res> {
  factory $DiscoveryPlaylistModelCopyWith(
    DiscoveryPlaylistModel value,
    $Res Function(DiscoveryPlaylistModel) then,
  ) = _$DiscoveryPlaylistModelCopyWithImpl<$Res, DiscoveryPlaylistModel>;
  @useResult
  $Res call({
    int id,
    String title,
    DiscoveryUserModel owner,
    String type,
    bool isLiked,
    String? description,
    bool isPrivate,
    String? coverArtUrl,
    String? playlistSlug,
    int totalDurationSeconds,
    int trackCount,
    List<String> genres,
    DateTime? createdAt,
  });

  $DiscoveryUserModelCopyWith<$Res> get owner;
}

/// @nodoc
class _$DiscoveryPlaylistModelCopyWithImpl<
  $Res,
  $Val extends DiscoveryPlaylistModel
>
    implements $DiscoveryPlaylistModelCopyWith<$Res> {
  _$DiscoveryPlaylistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? owner = null,
    Object? type = null,
    Object? isLiked = null,
    Object? description = freezed,
    Object? isPrivate = null,
    Object? coverArtUrl = freezed,
    Object? playlistSlug = freezed,
    Object? totalDurationSeconds = null,
    Object? trackCount = null,
    Object? genres = null,
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
            owner: null == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as DiscoveryUserModel,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            coverArtUrl: freezed == coverArtUrl
                ? _value.coverArtUrl
                : coverArtUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            playlistSlug: freezed == playlistSlug
                ? _value.playlistSlug
                : playlistSlug // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalDurationSeconds: null == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            trackCount: null == trackCount
                ? _value.trackCount
                : trackCount // ignore: cast_nullable_to_non_nullable
                      as int,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscoveryUserModelCopyWith<$Res> get owner {
    return $DiscoveryUserModelCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscoveryPlaylistModelImplCopyWith<$Res>
    implements $DiscoveryPlaylistModelCopyWith<$Res> {
  factory _$$DiscoveryPlaylistModelImplCopyWith(
    _$DiscoveryPlaylistModelImpl value,
    $Res Function(_$DiscoveryPlaylistModelImpl) then,
  ) = __$$DiscoveryPlaylistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    DiscoveryUserModel owner,
    String type,
    bool isLiked,
    String? description,
    bool isPrivate,
    String? coverArtUrl,
    String? playlistSlug,
    int totalDurationSeconds,
    int trackCount,
    List<String> genres,
    DateTime? createdAt,
  });

  @override
  $DiscoveryUserModelCopyWith<$Res> get owner;
}

/// @nodoc
class __$$DiscoveryPlaylistModelImplCopyWithImpl<$Res>
    extends
        _$DiscoveryPlaylistModelCopyWithImpl<$Res, _$DiscoveryPlaylistModelImpl>
    implements _$$DiscoveryPlaylistModelImplCopyWith<$Res> {
  __$$DiscoveryPlaylistModelImplCopyWithImpl(
    _$DiscoveryPlaylistModelImpl _value,
    $Res Function(_$DiscoveryPlaylistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? owner = null,
    Object? type = null,
    Object? isLiked = null,
    Object? description = freezed,
    Object? isPrivate = null,
    Object? coverArtUrl = freezed,
    Object? playlistSlug = freezed,
    Object? totalDurationSeconds = null,
    Object? trackCount = null,
    Object? genres = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$DiscoveryPlaylistModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        owner: null == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as DiscoveryUserModel,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        coverArtUrl: freezed == coverArtUrl
            ? _value.coverArtUrl
            : coverArtUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        playlistSlug: freezed == playlistSlug
            ? _value.playlistSlug
            : playlistSlug // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalDurationSeconds: null == totalDurationSeconds
            ? _value.totalDurationSeconds
            : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        trackCount: null == trackCount
            ? _value.trackCount
            : trackCount // ignore: cast_nullable_to_non_nullable
                  as int,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$DiscoveryPlaylistModelImpl implements _DiscoveryPlaylistModel {
  const _$DiscoveryPlaylistModelImpl({
    required this.id,
    required this.title,
    required this.owner,
    this.type = 'PLAYLIST',
    this.isLiked = false,
    this.description,
    this.isPrivate = false,
    this.coverArtUrl,
    this.playlistSlug,
    this.totalDurationSeconds = 0,
    this.trackCount = 0,
    final List<String> genres = const <String>[],
    this.createdAt,
  }) : _genres = genres;

  factory _$DiscoveryPlaylistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscoveryPlaylistModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final DiscoveryUserModel owner;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  final String? coverArtUrl;
  @override
  final String? playlistSlug;
  @override
  @JsonKey()
  final int totalDurationSeconds;
  @override
  @JsonKey()
  final int trackCount;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DiscoveryPlaylistModel(id: $id, title: $title, owner: $owner, type: $type, isLiked: $isLiked, description: $description, isPrivate: $isPrivate, coverArtUrl: $coverArtUrl, playlistSlug: $playlistSlug, totalDurationSeconds: $totalDurationSeconds, trackCount: $trackCount, genres: $genres, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoveryPlaylistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.coverArtUrl, coverArtUrl) ||
                other.coverArtUrl == coverArtUrl) &&
            (identical(other.playlistSlug, playlistSlug) ||
                other.playlistSlug == playlistSlug) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.trackCount, trackCount) ||
                other.trackCount == trackCount) &&
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
    owner,
    type,
    isLiked,
    description,
    isPrivate,
    coverArtUrl,
    playlistSlug,
    totalDurationSeconds,
    trackCount,
    const DeepCollectionEquality().hash(_genres),
    createdAt,
  );

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoveryPlaylistModelImplCopyWith<_$DiscoveryPlaylistModelImpl>
  get copyWith =>
      __$$DiscoveryPlaylistModelImplCopyWithImpl<_$DiscoveryPlaylistModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoveryPlaylistModelImplToJson(this);
  }
}

abstract class _DiscoveryPlaylistModel implements DiscoveryPlaylistModel {
  const factory _DiscoveryPlaylistModel({
    required final int id,
    required final String title,
    required final DiscoveryUserModel owner,
    final String type,
    final bool isLiked,
    final String? description,
    final bool isPrivate,
    final String? coverArtUrl,
    final String? playlistSlug,
    final int totalDurationSeconds,
    final int trackCount,
    final List<String> genres,
    final DateTime? createdAt,
  }) = _$DiscoveryPlaylistModelImpl;

  factory _DiscoveryPlaylistModel.fromJson(Map<String, dynamic> json) =
      _$DiscoveryPlaylistModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  DiscoveryUserModel get owner;
  @override
  String get type;
  @override
  bool get isLiked;
  @override
  String? get description;
  @override
  bool get isPrivate;
  @override
  String? get coverArtUrl;
  @override
  String? get playlistSlug;
  @override
  int get totalDurationSeconds;
  @override
  int get trackCount;
  @override
  List<String> get genres;
  @override
  DateTime? get createdAt;

  /// Create a copy of DiscoveryPlaylistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoveryPlaylistModelImplCopyWith<_$DiscoveryPlaylistModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
