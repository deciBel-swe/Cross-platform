// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PublicProfileModel _$PublicProfileModelFromJson(Map<String, dynamic> json) {
  return _PublicProfileModel.fromJson(json);
}

/// @nodoc
mixin _$PublicProfileModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get tier => throw _privateConstructorUsedError;
  PublicProfileDetailsModel? get profile => throw _privateConstructorUsedError;
  SocialLinksModel? get socialLinks => throw _privateConstructorUsedError;
  PublicStatsModel get stats => throw _privateConstructorUsedError;

  /// Whether the current logged-in user follows this profile's user.
  bool get isFollowing => throw _privateConstructorUsedError;

  /// Whether this profile's user follows the current logged-in user.
  bool get isFollowedBy => throw _privateConstructorUsedError;

  /// Whether the current logged-in user has blocked this profile's user.
  bool get isBlocked => throw _privateConstructorUsedError;

  /// Serializes this PublicProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicProfileModelCopyWith<PublicProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicProfileModelCopyWith<$Res> {
  factory $PublicProfileModelCopyWith(
    PublicProfileModel value,
    $Res Function(PublicProfileModel) then,
  ) = _$PublicProfileModelCopyWithImpl<$Res, PublicProfileModel>;
  @useResult
  $Res call({
    int id,
    String username,
    String tier,
    PublicProfileDetailsModel? profile,
    SocialLinksModel? socialLinks,
    PublicStatsModel stats,
    bool isFollowing,
    bool isFollowedBy,
    bool isBlocked,
  });

  $PublicProfileDetailsModelCopyWith<$Res>? get profile;
  $SocialLinksModelCopyWith<$Res>? get socialLinks;
  $PublicStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class _$PublicProfileModelCopyWithImpl<$Res, $Val extends PublicProfileModel>
    implements $PublicProfileModelCopyWith<$Res> {
  _$PublicProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? tier = null,
    Object? profile = freezed,
    Object? socialLinks = freezed,
    Object? stats = null,
    Object? isFollowing = null,
    Object? isFollowedBy = null,
    Object? isBlocked = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as String,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as PublicProfileDetailsModel?,
            socialLinks: freezed == socialLinks
                ? _value.socialLinks
                : socialLinks // ignore: cast_nullable_to_non_nullable
                      as SocialLinksModel?,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as PublicStatsModel,
            isFollowing: null == isFollowing
                ? _value.isFollowing
                : isFollowing // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFollowedBy: null == isFollowedBy
                ? _value.isFollowedBy
                : isFollowedBy // ignore: cast_nullable_to_non_nullable
                      as bool,
            isBlocked: null == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PublicProfileDetailsModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $PublicProfileDetailsModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SocialLinksModelCopyWith<$Res>? get socialLinks {
    if (_value.socialLinks == null) {
      return null;
    }

    return $SocialLinksModelCopyWith<$Res>(_value.socialLinks!, (value) {
      return _then(_value.copyWith(socialLinks: value) as $Val);
    });
  }

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PublicStatsModelCopyWith<$Res> get stats {
    return $PublicStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PublicProfileModelImplCopyWith<$Res>
    implements $PublicProfileModelCopyWith<$Res> {
  factory _$$PublicProfileModelImplCopyWith(
    _$PublicProfileModelImpl value,
    $Res Function(_$PublicProfileModelImpl) then,
  ) = __$$PublicProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String username,
    String tier,
    PublicProfileDetailsModel? profile,
    SocialLinksModel? socialLinks,
    PublicStatsModel stats,
    bool isFollowing,
    bool isFollowedBy,
    bool isBlocked,
  });

  @override
  $PublicProfileDetailsModelCopyWith<$Res>? get profile;
  @override
  $SocialLinksModelCopyWith<$Res>? get socialLinks;
  @override
  $PublicStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$PublicProfileModelImplCopyWithImpl<$Res>
    extends _$PublicProfileModelCopyWithImpl<$Res, _$PublicProfileModelImpl>
    implements _$$PublicProfileModelImplCopyWith<$Res> {
  __$$PublicProfileModelImplCopyWithImpl(
    _$PublicProfileModelImpl _value,
    $Res Function(_$PublicProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? tier = null,
    Object? profile = freezed,
    Object? socialLinks = freezed,
    Object? stats = null,
    Object? isFollowing = null,
    Object? isFollowedBy = null,
    Object? isBlocked = null,
  }) {
    return _then(
      _$PublicProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as String,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as PublicProfileDetailsModel?,
        socialLinks: freezed == socialLinks
            ? _value.socialLinks
            : socialLinks // ignore: cast_nullable_to_non_nullable
                  as SocialLinksModel?,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as PublicStatsModel,
        isFollowing: null == isFollowing
            ? _value.isFollowing
            : isFollowing // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFollowedBy: null == isFollowedBy
            ? _value.isFollowedBy
            : isFollowedBy // ignore: cast_nullable_to_non_nullable
                  as bool,
        isBlocked: null == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicProfileModelImpl implements _PublicProfileModel {
  const _$PublicProfileModelImpl({
    required this.id,
    required this.username,
    this.tier = 'FREE',
    this.profile,
    this.socialLinks,
    required this.stats,
    this.isFollowing = false,
    this.isFollowedBy = false,
    this.isBlocked = false,
  });

  factory _$PublicProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicProfileModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  @JsonKey()
  final String tier;
  @override
  final PublicProfileDetailsModel? profile;
  @override
  final SocialLinksModel? socialLinks;
  @override
  final PublicStatsModel stats;

  /// Whether the current logged-in user follows this profile's user.
  @override
  @JsonKey()
  final bool isFollowing;

  /// Whether this profile's user follows the current logged-in user.
  @override
  @JsonKey()
  final bool isFollowedBy;

  /// Whether the current logged-in user has blocked this profile's user.
  @override
  @JsonKey()
  final bool isBlocked;

  @override
  String toString() {
    return 'PublicProfileModel(id: $id, username: $username, tier: $tier, profile: $profile, socialLinks: $socialLinks, stats: $stats, isFollowing: $isFollowing, isFollowedBy: $isFollowedBy, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.socialLinks, socialLinks) ||
                other.socialLinks == socialLinks) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isFollowedBy, isFollowedBy) ||
                other.isFollowedBy == isFollowedBy) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    tier,
    profile,
    socialLinks,
    stats,
    isFollowing,
    isFollowedBy,
    isBlocked,
  );

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicProfileModelImplCopyWith<_$PublicProfileModelImpl> get copyWith =>
      __$$PublicProfileModelImplCopyWithImpl<_$PublicProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicProfileModelImplToJson(this);
  }
}

abstract class _PublicProfileModel implements PublicProfileModel {
  const factory _PublicProfileModel({
    required final int id,
    required final String username,
    final String tier,
    final PublicProfileDetailsModel? profile,
    final SocialLinksModel? socialLinks,
    required final PublicStatsModel stats,
    final bool isFollowing,
    final bool isFollowedBy,
    final bool isBlocked,
  }) = _$PublicProfileModelImpl;

  factory _PublicProfileModel.fromJson(Map<String, dynamic> json) =
      _$PublicProfileModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String get tier;
  @override
  PublicProfileDetailsModel? get profile;
  @override
  SocialLinksModel? get socialLinks;
  @override
  PublicStatsModel get stats;

  /// Whether the current logged-in user follows this profile's user.
  @override
  bool get isFollowing;

  /// Whether this profile's user follows the current logged-in user.
  @override
  bool get isFollowedBy;

  /// Whether the current logged-in user has blocked this profile's user.
  @override
  bool get isBlocked;

  /// Create a copy of PublicProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicProfileModelImplCopyWith<_$PublicProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PublicProfileDetailsModel _$PublicProfileDetailsModelFromJson(
  Map<String, dynamic> json,
) {
  return _PublicProfileDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$PublicProfileDetailsModel {
  String? get bio => throw _privateConstructorUsedError;

  /// Capitalised key in the API response (e.g. `"Location": "Cairo"`).
  @JsonKey(name: 'Location')
  String? get location => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get coverPhotoUrl => throw _privateConstructorUsedError;
  List<String> get favoriteGenres => throw _privateConstructorUsedError;

  /// Serializes this PublicProfileDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicProfileDetailsModelCopyWith<PublicProfileDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicProfileDetailsModelCopyWith<$Res> {
  factory $PublicProfileDetailsModelCopyWith(
    PublicProfileDetailsModel value,
    $Res Function(PublicProfileDetailsModel) then,
  ) = _$PublicProfileDetailsModelCopyWithImpl<$Res, PublicProfileDetailsModel>;
  @useResult
  $Res call({
    String? bio,
    @JsonKey(name: 'Location') String? location,
    String? avatarUrl,
    String? coverPhotoUrl,
    List<String> favoriteGenres,
  });
}

/// @nodoc
class _$PublicProfileDetailsModelCopyWithImpl<
  $Res,
  $Val extends PublicProfileDetailsModel
>
    implements $PublicProfileDetailsModelCopyWith<$Res> {
  _$PublicProfileDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? location = freezed,
    Object? avatarUrl = freezed,
    Object? coverPhotoUrl = freezed,
    Object? favoriteGenres = null,
  }) {
    return _then(
      _value.copyWith(
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverPhotoUrl: freezed == coverPhotoUrl
                ? _value.coverPhotoUrl
                : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            favoriteGenres: null == favoriteGenres
                ? _value.favoriteGenres
                : favoriteGenres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicProfileDetailsModelImplCopyWith<$Res>
    implements $PublicProfileDetailsModelCopyWith<$Res> {
  factory _$$PublicProfileDetailsModelImplCopyWith(
    _$PublicProfileDetailsModelImpl value,
    $Res Function(_$PublicProfileDetailsModelImpl) then,
  ) = __$$PublicProfileDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? bio,
    @JsonKey(name: 'Location') String? location,
    String? avatarUrl,
    String? coverPhotoUrl,
    List<String> favoriteGenres,
  });
}

/// @nodoc
class __$$PublicProfileDetailsModelImplCopyWithImpl<$Res>
    extends
        _$PublicProfileDetailsModelCopyWithImpl<
          $Res,
          _$PublicProfileDetailsModelImpl
        >
    implements _$$PublicProfileDetailsModelImplCopyWith<$Res> {
  __$$PublicProfileDetailsModelImplCopyWithImpl(
    _$PublicProfileDetailsModelImpl _value,
    $Res Function(_$PublicProfileDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? location = freezed,
    Object? avatarUrl = freezed,
    Object? coverPhotoUrl = freezed,
    Object? favoriteGenres = null,
  }) {
    return _then(
      _$PublicProfileDetailsModelImpl(
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverPhotoUrl: freezed == coverPhotoUrl
            ? _value.coverPhotoUrl
            : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        favoriteGenres: null == favoriteGenres
            ? _value._favoriteGenres
            : favoriteGenres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicProfileDetailsModelImpl implements _PublicProfileDetailsModel {
  const _$PublicProfileDetailsModelImpl({
    this.bio,
    @JsonKey(name: 'Location') this.location,
    this.avatarUrl,
    this.coverPhotoUrl,
    final List<String> favoriteGenres = const [],
  }) : _favoriteGenres = favoriteGenres;

  factory _$PublicProfileDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicProfileDetailsModelImplFromJson(json);

  @override
  final String? bio;

  /// Capitalised key in the API response (e.g. `"Location": "Cairo"`).
  @override
  @JsonKey(name: 'Location')
  final String? location;
  @override
  final String? avatarUrl;
  @override
  final String? coverPhotoUrl;
  final List<String> _favoriteGenres;
  @override
  @JsonKey()
  List<String> get favoriteGenres {
    if (_favoriteGenres is EqualUnmodifiableListView) return _favoriteGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteGenres);
  }

  @override
  String toString() {
    return 'PublicProfileDetailsModel(bio: $bio, location: $location, avatarUrl: $avatarUrl, coverPhotoUrl: $coverPhotoUrl, favoriteGenres: $favoriteGenres)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicProfileDetailsModelImpl &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.coverPhotoUrl, coverPhotoUrl) ||
                other.coverPhotoUrl == coverPhotoUrl) &&
            const DeepCollectionEquality().equals(
              other._favoriteGenres,
              _favoriteGenres,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bio,
    location,
    avatarUrl,
    coverPhotoUrl,
    const DeepCollectionEquality().hash(_favoriteGenres),
  );

  /// Create a copy of PublicProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicProfileDetailsModelImplCopyWith<_$PublicProfileDetailsModelImpl>
  get copyWith =>
      __$$PublicProfileDetailsModelImplCopyWithImpl<
        _$PublicProfileDetailsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicProfileDetailsModelImplToJson(this);
  }
}

abstract class _PublicProfileDetailsModel implements PublicProfileDetailsModel {
  const factory _PublicProfileDetailsModel({
    final String? bio,
    @JsonKey(name: 'Location') final String? location,
    final String? avatarUrl,
    final String? coverPhotoUrl,
    final List<String> favoriteGenres,
  }) = _$PublicProfileDetailsModelImpl;

  factory _PublicProfileDetailsModel.fromJson(Map<String, dynamic> json) =
      _$PublicProfileDetailsModelImpl.fromJson;

  @override
  String? get bio;

  /// Capitalised key in the API response (e.g. `"Location": "Cairo"`).
  @override
  @JsonKey(name: 'Location')
  String? get location;
  @override
  String? get avatarUrl;
  @override
  String? get coverPhotoUrl;
  @override
  List<String> get favoriteGenres;

  /// Create a copy of PublicProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicProfileDetailsModelImplCopyWith<_$PublicProfileDetailsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PublicStatsModel _$PublicStatsModelFromJson(Map<String, dynamic> json) {
  return _PublicStatsModel.fromJson(json);
}

/// @nodoc
mixin _$PublicStatsModel {
  int get followersCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  int get trackCount => throw _privateConstructorUsedError;

  /// Serializes this PublicStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicStatsModelCopyWith<PublicStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicStatsModelCopyWith<$Res> {
  factory $PublicStatsModelCopyWith(
    PublicStatsModel value,
    $Res Function(PublicStatsModel) then,
  ) = _$PublicStatsModelCopyWithImpl<$Res, PublicStatsModel>;
  @useResult
  $Res call({int followersCount, int followingCount, int trackCount});
}

/// @nodoc
class _$PublicStatsModelCopyWithImpl<$Res, $Val extends PublicStatsModel>
    implements $PublicStatsModelCopyWith<$Res> {
  _$PublicStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followersCount = null,
    Object? followingCount = null,
    Object? trackCount = null,
  }) {
    return _then(
      _value.copyWith(
            followersCount: null == followersCount
                ? _value.followersCount
                : followersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            trackCount: null == trackCount
                ? _value.trackCount
                : trackCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublicStatsModelImplCopyWith<$Res>
    implements $PublicStatsModelCopyWith<$Res> {
  factory _$$PublicStatsModelImplCopyWith(
    _$PublicStatsModelImpl value,
    $Res Function(_$PublicStatsModelImpl) then,
  ) = __$$PublicStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int followersCount, int followingCount, int trackCount});
}

/// @nodoc
class __$$PublicStatsModelImplCopyWithImpl<$Res>
    extends _$PublicStatsModelCopyWithImpl<$Res, _$PublicStatsModelImpl>
    implements _$$PublicStatsModelImplCopyWith<$Res> {
  __$$PublicStatsModelImplCopyWithImpl(
    _$PublicStatsModelImpl _value,
    $Res Function(_$PublicStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followersCount = null,
    Object? followingCount = null,
    Object? trackCount = null,
  }) {
    return _then(
      _$PublicStatsModelImpl(
        followersCount: null == followersCount
            ? _value.followersCount
            : followersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        trackCount: null == trackCount
            ? _value.trackCount
            : trackCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicStatsModelImpl implements _PublicStatsModel {
  const _$PublicStatsModelImpl({
    this.followersCount = 0,
    this.followingCount = 0,
    this.trackCount = 0,
  });

  factory _$PublicStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int followersCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @JsonKey()
  final int trackCount;

  @override
  String toString() {
    return 'PublicStatsModel(followersCount: $followersCount, followingCount: $followingCount, trackCount: $trackCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicStatsModelImpl &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.trackCount, trackCount) ||
                other.trackCount == trackCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, followersCount, followingCount, trackCount);

  /// Create a copy of PublicStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicStatsModelImplCopyWith<_$PublicStatsModelImpl> get copyWith =>
      __$$PublicStatsModelImplCopyWithImpl<_$PublicStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicStatsModelImplToJson(this);
  }
}

abstract class _PublicStatsModel implements PublicStatsModel {
  const factory _PublicStatsModel({
    final int followersCount,
    final int followingCount,
    final int trackCount,
  }) = _$PublicStatsModelImpl;

  factory _PublicStatsModel.fromJson(Map<String, dynamic> json) =
      _$PublicStatsModelImpl.fromJson;

  @override
  int get followersCount;
  @override
  int get followingCount;
  @override
  int get trackCount;

  /// Create a copy of PublicStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicStatsModelImplCopyWith<_$PublicStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
