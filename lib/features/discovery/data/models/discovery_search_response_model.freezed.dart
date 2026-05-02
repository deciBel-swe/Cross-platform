// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_search_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscoverySearchResponseModel _$DiscoverySearchResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _DiscoverySearchResponseModel.fromJson(json);
}

/// @nodoc
mixin _$DiscoverySearchResponseModel {
  List<DiscoveryUserModel> get users => throw _privateConstructorUsedError;
  List<DiscoveryTrackModel> get tracks => throw _privateConstructorUsedError;
  List<DiscoveryPlaylistModel> get playlists =>
      throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this DiscoverySearchResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscoverySearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscoverySearchResponseModelCopyWith<DiscoverySearchResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoverySearchResponseModelCopyWith<$Res> {
  factory $DiscoverySearchResponseModelCopyWith(
    DiscoverySearchResponseModel value,
    $Res Function(DiscoverySearchResponseModel) then,
  ) =
      _$DiscoverySearchResponseModelCopyWithImpl<
        $Res,
        DiscoverySearchResponseModel
      >;
  @useResult
  $Res call({
    List<DiscoveryUserModel> users,
    List<DiscoveryTrackModel> tracks,
    List<DiscoveryPlaylistModel> playlists,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class _$DiscoverySearchResponseModelCopyWithImpl<
  $Res,
  $Val extends DiscoverySearchResponseModel
>
    implements $DiscoverySearchResponseModelCopyWith<$Res> {
  _$DiscoverySearchResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscoverySearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? tracks = null,
    Object? playlists = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? isLast = null,
  }) {
    return _then(
      _value.copyWith(
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<DiscoveryUserModel>,
            tracks: null == tracks
                ? _value.tracks
                : tracks // ignore: cast_nullable_to_non_nullable
                      as List<DiscoveryTrackModel>,
            playlists: null == playlists
                ? _value.playlists
                : playlists // ignore: cast_nullable_to_non_nullable
                      as List<DiscoveryPlaylistModel>,
            pageNumber: null == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            totalElements: null == totalElements
                ? _value.totalElements
                : totalElements // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            isLast: null == isLast
                ? _value.isLast
                : isLast // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscoverySearchResponseModelImplCopyWith<$Res>
    implements $DiscoverySearchResponseModelCopyWith<$Res> {
  factory _$$DiscoverySearchResponseModelImplCopyWith(
    _$DiscoverySearchResponseModelImpl value,
    $Res Function(_$DiscoverySearchResponseModelImpl) then,
  ) = __$$DiscoverySearchResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DiscoveryUserModel> users,
    List<DiscoveryTrackModel> tracks,
    List<DiscoveryPlaylistModel> playlists,
    int pageNumber,
    int pageSize,
    int totalElements,
    int totalPages,
    bool isLast,
  });
}

/// @nodoc
class __$$DiscoverySearchResponseModelImplCopyWithImpl<$Res>
    extends
        _$DiscoverySearchResponseModelCopyWithImpl<
          $Res,
          _$DiscoverySearchResponseModelImpl
        >
    implements _$$DiscoverySearchResponseModelImplCopyWith<$Res> {
  __$$DiscoverySearchResponseModelImplCopyWithImpl(
    _$DiscoverySearchResponseModelImpl _value,
    $Res Function(_$DiscoverySearchResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscoverySearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? tracks = null,
    Object? playlists = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? isLast = null,
  }) {
    return _then(
      _$DiscoverySearchResponseModelImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<DiscoveryUserModel>,
        tracks: null == tracks
            ? _value._tracks
            : tracks // ignore: cast_nullable_to_non_nullable
                  as List<DiscoveryTrackModel>,
        playlists: null == playlists
            ? _value._playlists
            : playlists // ignore: cast_nullable_to_non_nullable
                  as List<DiscoveryPlaylistModel>,
        pageNumber: null == pageNumber
            ? _value.pageNumber
            : pageNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        totalElements: null == totalElements
            ? _value.totalElements
            : totalElements // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        isLast: null == isLast
            ? _value.isLast
            : isLast // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscoverySearchResponseModelImpl
    implements _DiscoverySearchResponseModel {
  const _$DiscoverySearchResponseModelImpl({
    final List<DiscoveryUserModel> users = const <DiscoveryUserModel>[],
    final List<DiscoveryTrackModel> tracks = const <DiscoveryTrackModel>[],
    final List<DiscoveryPlaylistModel> playlists =
        const <DiscoveryPlaylistModel>[],
    this.pageNumber = 0,
    this.pageSize = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
  }) : _users = users,
       _tracks = tracks,
       _playlists = playlists;

  factory _$DiscoverySearchResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$DiscoverySearchResponseModelImplFromJson(json);

  final List<DiscoveryUserModel> _users;
  @override
  @JsonKey()
  List<DiscoveryUserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<DiscoveryTrackModel> _tracks;
  @override
  @JsonKey()
  List<DiscoveryTrackModel> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  final List<DiscoveryPlaylistModel> _playlists;
  @override
  @JsonKey()
  List<DiscoveryPlaylistModel> get playlists {
    if (_playlists is EqualUnmodifiableListView) return _playlists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playlists);
  }

  @override
  @JsonKey()
  final int pageNumber;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int totalElements;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final bool isLast;

  @override
  String toString() {
    return 'DiscoverySearchResponseModel(users: $users, tracks: $tracks, playlists: $playlists, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoverySearchResponseModelImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other._tracks, _tracks) &&
            const DeepCollectionEquality().equals(
              other._playlists,
              _playlists,
            ) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.isLast, isLast) || other.isLast == isLast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_tracks),
    const DeepCollectionEquality().hash(_playlists),
    pageNumber,
    pageSize,
    totalElements,
    totalPages,
    isLast,
  );

  /// Create a copy of DiscoverySearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoverySearchResponseModelImplCopyWith<
    _$DiscoverySearchResponseModelImpl
  >
  get copyWith =>
      __$$DiscoverySearchResponseModelImplCopyWithImpl<
        _$DiscoverySearchResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscoverySearchResponseModelImplToJson(this);
  }
}

abstract class _DiscoverySearchResponseModel
    implements DiscoverySearchResponseModel {
  const factory _DiscoverySearchResponseModel({
    final List<DiscoveryUserModel> users,
    final List<DiscoveryTrackModel> tracks,
    final List<DiscoveryPlaylistModel> playlists,
    final int pageNumber,
    final int pageSize,
    final int totalElements,
    final int totalPages,
    final bool isLast,
  }) = _$DiscoverySearchResponseModelImpl;

  factory _DiscoverySearchResponseModel.fromJson(Map<String, dynamic> json) =
      _$DiscoverySearchResponseModelImpl.fromJson;

  @override
  List<DiscoveryUserModel> get users;
  @override
  List<DiscoveryTrackModel> get tracks;
  @override
  List<DiscoveryPlaylistModel> get playlists;
  @override
  int get pageNumber;
  @override
  int get pageSize;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get isLast;

  /// Create a copy of DiscoverySearchResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscoverySearchResponseModelImplCopyWith<
    _$DiscoverySearchResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
