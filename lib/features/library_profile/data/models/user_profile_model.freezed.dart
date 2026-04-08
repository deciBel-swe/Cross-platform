// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Role')
  String get role => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  UserTier get tier => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile')
  ProfileDetailsModel get profileDetails => throw _privateConstructorUsedError;
  SocialLinksModel? get socialLinks => throw _privateConstructorUsedError;
  PrivacySettingsModel get privacySettings =>
      throw _privateConstructorUsedError;
  UserStatsModel get stats => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
    UserProfileModel value,
    $Res Function(UserProfileModel) then,
  ) = _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'Role') String role,
    String email,
    String username,
    String? displayName,
    bool emailVerified,
    UserTier tier,
    @JsonKey(name: 'profile') ProfileDetailsModel profileDetails,
    SocialLinksModel? socialLinks,
    PrivacySettingsModel privacySettings,
    UserStatsModel stats,
  });

  $ProfileDetailsModelCopyWith<$Res> get profileDetails;
  $SocialLinksModelCopyWith<$Res>? get socialLinks;
  $PrivacySettingsModelCopyWith<$Res> get privacySettings;
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? emailVerified = null,
    Object? tier = null,
    Object? profileDetails = null,
    Object? socialLinks = freezed,
    Object? privacySettings = null,
    Object? stats = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            emailVerified: null == emailVerified
                ? _value.emailVerified
                : emailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as UserTier,
            profileDetails: null == profileDetails
                ? _value.profileDetails
                : profileDetails // ignore: cast_nullable_to_non_nullable
                      as ProfileDetailsModel,
            socialLinks: freezed == socialLinks
                ? _value.socialLinks
                : socialLinks // ignore: cast_nullable_to_non_nullable
                      as SocialLinksModel?,
            privacySettings: null == privacySettings
                ? _value.privacySettings
                : privacySettings // ignore: cast_nullable_to_non_nullable
                      as PrivacySettingsModel,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as UserStatsModel,
          )
          as $Val,
    );
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileDetailsModelCopyWith<$Res> get profileDetails {
    return $ProfileDetailsModelCopyWith<$Res>(_value.profileDetails, (value) {
      return _then(_value.copyWith(profileDetails: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
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

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrivacySettingsModelCopyWith<$Res> get privacySettings {
    return $PrivacySettingsModelCopyWith<$Res>(_value.privacySettings, (value) {
      return _then(_value.copyWith(privacySettings: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStatsModelCopyWith<$Res> get stats {
    return $UserStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(
    _$UserProfileModelImpl value,
    $Res Function(_$UserProfileModelImpl) then,
  ) = __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'Role') String role,
    String email,
    String username,
    String? displayName,
    bool emailVerified,
    UserTier tier,
    @JsonKey(name: 'profile') ProfileDetailsModel profileDetails,
    SocialLinksModel? socialLinks,
    PrivacySettingsModel privacySettings,
    UserStatsModel stats,
  });

  @override
  $ProfileDetailsModelCopyWith<$Res> get profileDetails;
  @override
  $SocialLinksModelCopyWith<$Res>? get socialLinks;
  @override
  $PrivacySettingsModelCopyWith<$Res> get privacySettings;
  @override
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(
    _$UserProfileModelImpl _value,
    $Res Function(_$UserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? emailVerified = null,
    Object? tier = null,
    Object? profileDetails = null,
    Object? socialLinks = freezed,
    Object? privacySettings = null,
    Object? stats = null,
  }) {
    return _then(
      _$UserProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        emailVerified: null == emailVerified
            ? _value.emailVerified
            : emailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as UserTier,
        profileDetails: null == profileDetails
            ? _value.profileDetails
            : profileDetails // ignore: cast_nullable_to_non_nullable
                  as ProfileDetailsModel,
        socialLinks: freezed == socialLinks
            ? _value.socialLinks
            : socialLinks // ignore: cast_nullable_to_non_nullable
                  as SocialLinksModel?,
        privacySettings: null == privacySettings
            ? _value.privacySettings
            : privacySettings // ignore: cast_nullable_to_non_nullable
                  as PrivacySettingsModel,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as UserStatsModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl({
    required this.id,
    @JsonKey(name: 'Role') required this.role,
    required this.email,
    required this.username,
    this.displayName,
    required this.emailVerified,
    required this.tier,
    @JsonKey(name: 'profile') required this.profileDetails,
    this.socialLinks,
    required this.privacySettings,
    required this.stats,
  });

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'Role')
  final String role;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? displayName;
  @override
  final bool emailVerified;
  @override
  final UserTier tier;
  @override
  @JsonKey(name: 'profile')
  final ProfileDetailsModel profileDetails;
  @override
  final SocialLinksModel? socialLinks;
  @override
  final PrivacySettingsModel privacySettings;
  @override
  final UserStatsModel stats;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, role: $role, email: $email, username: $username, displayName: $displayName, emailVerified: $emailVerified, tier: $tier, profileDetails: $profileDetails, socialLinks: $socialLinks, privacySettings: $privacySettings, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.profileDetails, profileDetails) ||
                other.profileDetails == profileDetails) &&
            (identical(other.socialLinks, socialLinks) ||
                other.socialLinks == socialLinks) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    email,
    username,
    displayName,
    emailVerified,
    tier,
    profileDetails,
    socialLinks,
    privacySettings,
    stats,
  );

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(this);
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel({
    required final int id,
    @JsonKey(name: 'Role') required final String role,
    required final String email,
    required final String username,
    final String? displayName,
    required final bool emailVerified,
    required final UserTier tier,
    @JsonKey(name: 'profile') required final ProfileDetailsModel profileDetails,
    final SocialLinksModel? socialLinks,
    required final PrivacySettingsModel privacySettings,
    required final UserStatsModel stats,
  }) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'Role')
  String get role;
  @override
  String get email;
  @override
  String get username;
  @override
  String? get displayName;
  @override
  bool get emailVerified;
  @override
  UserTier get tier;
  @override
  @JsonKey(name: 'profile')
  ProfileDetailsModel get profileDetails;
  @override
  SocialLinksModel? get socialLinks;
  @override
  PrivacySettingsModel get privacySettings;
  @override
  UserStatsModel get stats;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileDetailsModel _$ProfileDetailsModelFromJson(Map<String, dynamic> json) {
  return _ProfileDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileDetailsModel {
  String? get bio => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get profilePic => throw _privateConstructorUsedError;
  String? get coverPic => throw _privateConstructorUsedError;
  List<String> get favoriteGenres => throw _privateConstructorUsedError;

  /// Serializes this ProfileDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileDetailsModelCopyWith<ProfileDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileDetailsModelCopyWith<$Res> {
  factory $ProfileDetailsModelCopyWith(
    ProfileDetailsModel value,
    $Res Function(ProfileDetailsModel) then,
  ) = _$ProfileDetailsModelCopyWithImpl<$Res, ProfileDetailsModel>;
  @useResult
  $Res call({
    String? bio,
    String? city,
    String? country,
    String? profilePic,
    String? coverPic,
    List<String> favoriteGenres,
  });
}

/// @nodoc
class _$ProfileDetailsModelCopyWithImpl<$Res, $Val extends ProfileDetailsModel>
    implements $ProfileDetailsModelCopyWith<$Res> {
  _$ProfileDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? profilePic = freezed,
    Object? coverPic = freezed,
    Object? favoriteGenres = null,
  }) {
    return _then(
      _value.copyWith(
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePic: freezed == profilePic
                ? _value.profilePic
                : profilePic // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverPic: freezed == coverPic
                ? _value.coverPic
                : coverPic // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProfileDetailsModelImplCopyWith<$Res>
    implements $ProfileDetailsModelCopyWith<$Res> {
  factory _$$ProfileDetailsModelImplCopyWith(
    _$ProfileDetailsModelImpl value,
    $Res Function(_$ProfileDetailsModelImpl) then,
  ) = __$$ProfileDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? bio,
    String? city,
    String? country,
    String? profilePic,
    String? coverPic,
    List<String> favoriteGenres,
  });
}

/// @nodoc
class __$$ProfileDetailsModelImplCopyWithImpl<$Res>
    extends _$ProfileDetailsModelCopyWithImpl<$Res, _$ProfileDetailsModelImpl>
    implements _$$ProfileDetailsModelImplCopyWith<$Res> {
  __$$ProfileDetailsModelImplCopyWithImpl(
    _$ProfileDetailsModelImpl _value,
    $Res Function(_$ProfileDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bio = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? profilePic = freezed,
    Object? coverPic = freezed,
    Object? favoriteGenres = null,
  }) {
    return _then(
      _$ProfileDetailsModelImpl(
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePic: freezed == profilePic
            ? _value.profilePic
            : profilePic // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverPic: freezed == coverPic
            ? _value.coverPic
            : coverPic // ignore: cast_nullable_to_non_nullable
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
class _$ProfileDetailsModelImpl implements _ProfileDetailsModel {
  const _$ProfileDetailsModelImpl({
    this.bio,
    this.city,
    this.country,
    this.profilePic,
    this.coverPic,
    final List<String> favoriteGenres = const [],
  }) : _favoriteGenres = favoriteGenres;

  factory _$ProfileDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileDetailsModelImplFromJson(json);

  @override
  final String? bio;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final String? profilePic;
  @override
  final String? coverPic;
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
    return 'ProfileDetailsModel(bio: $bio, city: $city, country: $country, profilePic: $profilePic, coverPic: $coverPic, favoriteGenres: $favoriteGenres)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileDetailsModelImpl &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.coverPic, coverPic) ||
                other.coverPic == coverPic) &&
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
    city,
    country,
    profilePic,
    coverPic,
    const DeepCollectionEquality().hash(_favoriteGenres),
  );

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileDetailsModelImplCopyWith<_$ProfileDetailsModelImpl> get copyWith =>
      __$$ProfileDetailsModelImplCopyWithImpl<_$ProfileDetailsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileDetailsModelImplToJson(this);
  }
}

abstract class _ProfileDetailsModel implements ProfileDetailsModel {
  const factory _ProfileDetailsModel({
    final String? bio,
    final String? city,
    final String? country,
    final String? profilePic,
    final String? coverPic,
    final List<String> favoriteGenres,
  }) = _$ProfileDetailsModelImpl;

  factory _ProfileDetailsModel.fromJson(Map<String, dynamic> json) =
      _$ProfileDetailsModelImpl.fromJson;

  @override
  String? get bio;
  @override
  String? get city;
  @override
  String? get country;
  @override
  String? get profilePic;
  @override
  String? get coverPic;
  @override
  List<String> get favoriteGenres;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileDetailsModelImplCopyWith<_$ProfileDetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrivacySettingsModel _$PrivacySettingsModelFromJson(Map<String, dynamic> json) {
  return _PrivacySettingsModel.fromJson(json);
}

/// @nodoc
mixin _$PrivacySettingsModel {
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get showHistory => throw _privateConstructorUsedError;

  /// Serializes this PrivacySettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacySettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacySettingsModelCopyWith<PrivacySettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacySettingsModelCopyWith<$Res> {
  factory $PrivacySettingsModelCopyWith(
    PrivacySettingsModel value,
    $Res Function(PrivacySettingsModel) then,
  ) = _$PrivacySettingsModelCopyWithImpl<$Res, PrivacySettingsModel>;
  @useResult
  $Res call({bool isPrivate, bool showHistory});
}

/// @nodoc
class _$PrivacySettingsModelCopyWithImpl<
  $Res,
  $Val extends PrivacySettingsModel
>
    implements $PrivacySettingsModelCopyWith<$Res> {
  _$PrivacySettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacySettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPrivate = null, Object? showHistory = null}) {
    return _then(
      _value.copyWith(
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            showHistory: null == showHistory
                ? _value.showHistory
                : showHistory // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrivacySettingsModelImplCopyWith<$Res>
    implements $PrivacySettingsModelCopyWith<$Res> {
  factory _$$PrivacySettingsModelImplCopyWith(
    _$PrivacySettingsModelImpl value,
    $Res Function(_$PrivacySettingsModelImpl) then,
  ) = __$$PrivacySettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPrivate, bool showHistory});
}

/// @nodoc
class __$$PrivacySettingsModelImplCopyWithImpl<$Res>
    extends _$PrivacySettingsModelCopyWithImpl<$Res, _$PrivacySettingsModelImpl>
    implements _$$PrivacySettingsModelImplCopyWith<$Res> {
  __$$PrivacySettingsModelImplCopyWithImpl(
    _$PrivacySettingsModelImpl _value,
    $Res Function(_$PrivacySettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrivacySettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isPrivate = null, Object? showHistory = null}) {
    return _then(
      _$PrivacySettingsModelImpl(
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        showHistory: null == showHistory
            ? _value.showHistory
            : showHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacySettingsModelImpl implements _PrivacySettingsModel {
  const _$PrivacySettingsModelImpl({
    required this.isPrivate,
    required this.showHistory,
  });

  factory _$PrivacySettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacySettingsModelImplFromJson(json);

  @override
  final bool isPrivate;
  @override
  final bool showHistory;

  @override
  String toString() {
    return 'PrivacySettingsModel(isPrivate: $isPrivate, showHistory: $showHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacySettingsModelImpl &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.showHistory, showHistory) ||
                other.showHistory == showHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isPrivate, showHistory);

  /// Create a copy of PrivacySettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacySettingsModelImplCopyWith<_$PrivacySettingsModelImpl>
  get copyWith =>
      __$$PrivacySettingsModelImplCopyWithImpl<_$PrivacySettingsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacySettingsModelImplToJson(this);
  }
}

abstract class _PrivacySettingsModel implements PrivacySettingsModel {
  const factory _PrivacySettingsModel({
    required final bool isPrivate,
    required final bool showHistory,
  }) = _$PrivacySettingsModelImpl;

  factory _PrivacySettingsModel.fromJson(Map<String, dynamic> json) =
      _$PrivacySettingsModelImpl.fromJson;

  @override
  bool get isPrivate;
  @override
  bool get showHistory;

  /// Create a copy of PrivacySettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacySettingsModelImplCopyWith<_$PrivacySettingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) {
  return _UserStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UserStatsModel {
  int get followers => throw _privateConstructorUsedError;
  int get following => throw _privateConstructorUsedError;
  int get tracksCount => throw _privateConstructorUsedError;

  /// Serializes this UserStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsModelCopyWith<UserStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsModelCopyWith<$Res> {
  factory $UserStatsModelCopyWith(
    UserStatsModel value,
    $Res Function(UserStatsModel) then,
  ) = _$UserStatsModelCopyWithImpl<$Res, UserStatsModel>;
  @useResult
  $Res call({int followers, int following, int tracksCount});
}

/// @nodoc
class _$UserStatsModelCopyWithImpl<$Res, $Val extends UserStatsModel>
    implements $UserStatsModelCopyWith<$Res> {
  _$UserStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followers = null,
    Object? following = null,
    Object? tracksCount = null,
  }) {
    return _then(
      _value.copyWith(
            followers: null == followers
                ? _value.followers
                : followers // ignore: cast_nullable_to_non_nullable
                      as int,
            following: null == following
                ? _value.following
                : following // ignore: cast_nullable_to_non_nullable
                      as int,
            tracksCount: null == tracksCount
                ? _value.tracksCount
                : tracksCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsModelImplCopyWith<$Res>
    implements $UserStatsModelCopyWith<$Res> {
  factory _$$UserStatsModelImplCopyWith(
    _$UserStatsModelImpl value,
    $Res Function(_$UserStatsModelImpl) then,
  ) = __$$UserStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int followers, int following, int tracksCount});
}

/// @nodoc
class __$$UserStatsModelImplCopyWithImpl<$Res>
    extends _$UserStatsModelCopyWithImpl<$Res, _$UserStatsModelImpl>
    implements _$$UserStatsModelImplCopyWith<$Res> {
  __$$UserStatsModelImplCopyWithImpl(
    _$UserStatsModelImpl _value,
    $Res Function(_$UserStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followers = null,
    Object? following = null,
    Object? tracksCount = null,
  }) {
    return _then(
      _$UserStatsModelImpl(
        followers: null == followers
            ? _value.followers
            : followers // ignore: cast_nullable_to_non_nullable
                  as int,
        following: null == following
            ? _value.following
            : following // ignore: cast_nullable_to_non_nullable
                  as int,
        tracksCount: null == tracksCount
            ? _value.tracksCount
            : tracksCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsModelImpl implements _UserStatsModel {
  const _$UserStatsModelImpl({
    required this.followers,
    required this.following,
    required this.tracksCount,
  });

  factory _$UserStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsModelImplFromJson(json);

  @override
  final int followers;
  @override
  final int following;
  @override
  final int tracksCount;

  @override
  String toString() {
    return 'UserStatsModel(followers: $followers, following: $following, tracksCount: $tracksCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsModelImpl &&
            (identical(other.followers, followers) ||
                other.followers == followers) &&
            (identical(other.following, following) ||
                other.following == following) &&
            (identical(other.tracksCount, tracksCount) ||
                other.tracksCount == tracksCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, followers, following, tracksCount);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      __$$UserStatsModelImplCopyWithImpl<_$UserStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsModelImplToJson(this);
  }
}

abstract class _UserStatsModel implements UserStatsModel {
  const factory _UserStatsModel({
    required final int followers,
    required final int following,
    required final int tracksCount,
  }) = _$UserStatsModelImpl;

  factory _UserStatsModel.fromJson(Map<String, dynamic> json) =
      _$UserStatsModelImpl.fromJson;

  @override
  int get followers;
  @override
  int get following;
  @override
  int get tracksCount;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialLinksModel _$SocialLinksModelFromJson(Map<String, dynamic> json) {
  return _SocialLinksModel.fromJson(json);
}

/// @nodoc
mixin _$SocialLinksModel {
  String? get instagram => throw _privateConstructorUsedError;
  String? get twitter => throw _privateConstructorUsedError;
  String? get x => throw _privateConstructorUsedError;
  String? get youtube => throw _privateConstructorUsedError;
  String? get tiktok => throw _privateConstructorUsedError;
  String? get linkedin => throw _privateConstructorUsedError;
  String? get snapchat => throw _privateConstructorUsedError;
  String? get facebook => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get supportLink => throw _privateConstructorUsedError;

  /// Serializes this SocialLinksModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialLinksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialLinksModelCopyWith<SocialLinksModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLinksModelCopyWith<$Res> {
  factory $SocialLinksModelCopyWith(
    SocialLinksModel value,
    $Res Function(SocialLinksModel) then,
  ) = _$SocialLinksModelCopyWithImpl<$Res, SocialLinksModel>;
  @useResult
  $Res call({
    String? instagram,
    String? twitter,
    String? x,
    String? youtube,
    String? tiktok,
    String? linkedin,
    String? snapchat,
    String? facebook,
    String? website,
    String? supportLink,
  });
}

/// @nodoc
class _$SocialLinksModelCopyWithImpl<$Res, $Val extends SocialLinksModel>
    implements $SocialLinksModelCopyWith<$Res> {
  _$SocialLinksModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialLinksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? x = freezed,
    Object? youtube = freezed,
    Object? tiktok = freezed,
    Object? linkedin = freezed,
    Object? snapchat = freezed,
    Object? facebook = freezed,
    Object? website = freezed,
    Object? supportLink = freezed,
  }) {
    return _then(
      _value.copyWith(
            instagram: freezed == instagram
                ? _value.instagram
                : instagram // ignore: cast_nullable_to_non_nullable
                      as String?,
            twitter: freezed == twitter
                ? _value.twitter
                : twitter // ignore: cast_nullable_to_non_nullable
                      as String?,
            x: freezed == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as String?,
            youtube: freezed == youtube
                ? _value.youtube
                : youtube // ignore: cast_nullable_to_non_nullable
                      as String?,
            tiktok: freezed == tiktok
                ? _value.tiktok
                : tiktok // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkedin: freezed == linkedin
                ? _value.linkedin
                : linkedin // ignore: cast_nullable_to_non_nullable
                      as String?,
            snapchat: freezed == snapchat
                ? _value.snapchat
                : snapchat // ignore: cast_nullable_to_non_nullable
                      as String?,
            facebook: freezed == facebook
                ? _value.facebook
                : facebook // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            supportLink: freezed == supportLink
                ? _value.supportLink
                : supportLink // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocialLinksModelImplCopyWith<$Res>
    implements $SocialLinksModelCopyWith<$Res> {
  factory _$$SocialLinksModelImplCopyWith(
    _$SocialLinksModelImpl value,
    $Res Function(_$SocialLinksModelImpl) then,
  ) = __$$SocialLinksModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? instagram,
    String? twitter,
    String? x,
    String? youtube,
    String? tiktok,
    String? linkedin,
    String? snapchat,
    String? facebook,
    String? website,
    String? supportLink,
  });
}

/// @nodoc
class __$$SocialLinksModelImplCopyWithImpl<$Res>
    extends _$SocialLinksModelCopyWithImpl<$Res, _$SocialLinksModelImpl>
    implements _$$SocialLinksModelImplCopyWith<$Res> {
  __$$SocialLinksModelImplCopyWithImpl(
    _$SocialLinksModelImpl _value,
    $Res Function(_$SocialLinksModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocialLinksModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? x = freezed,
    Object? youtube = freezed,
    Object? tiktok = freezed,
    Object? linkedin = freezed,
    Object? snapchat = freezed,
    Object? facebook = freezed,
    Object? website = freezed,
    Object? supportLink = freezed,
  }) {
    return _then(
      _$SocialLinksModelImpl(
        instagram: freezed == instagram
            ? _value.instagram
            : instagram // ignore: cast_nullable_to_non_nullable
                  as String?,
        twitter: freezed == twitter
            ? _value.twitter
            : twitter // ignore: cast_nullable_to_non_nullable
                  as String?,
        x: freezed == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as String?,
        youtube: freezed == youtube
            ? _value.youtube
            : youtube // ignore: cast_nullable_to_non_nullable
                  as String?,
        tiktok: freezed == tiktok
            ? _value.tiktok
            : tiktok // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkedin: freezed == linkedin
            ? _value.linkedin
            : linkedin // ignore: cast_nullable_to_non_nullable
                  as String?,
        snapchat: freezed == snapchat
            ? _value.snapchat
            : snapchat // ignore: cast_nullable_to_non_nullable
                  as String?,
        facebook: freezed == facebook
            ? _value.facebook
            : facebook // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        supportLink: freezed == supportLink
            ? _value.supportLink
            : supportLink // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLinksModelImpl implements _SocialLinksModel {
  const _$SocialLinksModelImpl({
    this.instagram,
    this.twitter,
    this.x,
    this.youtube,
    this.tiktok,
    this.linkedin,
    this.snapchat,
    this.facebook,
    this.website,
    this.supportLink,
  });

  factory _$SocialLinksModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLinksModelImplFromJson(json);

  @override
  final String? instagram;
  @override
  final String? twitter;
  @override
  final String? x;
  @override
  final String? youtube;
  @override
  final String? tiktok;
  @override
  final String? linkedin;
  @override
  final String? snapchat;
  @override
  final String? facebook;
  @override
  final String? website;
  @override
  final String? supportLink;

  @override
  String toString() {
    return 'SocialLinksModel(instagram: $instagram, twitter: $twitter, x: $x, youtube: $youtube, tiktok: $tiktok, linkedin: $linkedin, snapchat: $snapchat, facebook: $facebook, website: $website, supportLink: $supportLink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLinksModelImpl &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.twitter, twitter) || other.twitter == twitter) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.youtube, youtube) || other.youtube == youtube) &&
            (identical(other.tiktok, tiktok) || other.tiktok == tiktok) &&
            (identical(other.linkedin, linkedin) ||
                other.linkedin == linkedin) &&
            (identical(other.snapchat, snapchat) ||
                other.snapchat == snapchat) &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.supportLink, supportLink) ||
                other.supportLink == supportLink));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    instagram,
    twitter,
    x,
    youtube,
    tiktok,
    linkedin,
    snapchat,
    facebook,
    website,
    supportLink,
  );

  /// Create a copy of SocialLinksModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLinksModelImplCopyWith<_$SocialLinksModelImpl> get copyWith =>
      __$$SocialLinksModelImplCopyWithImpl<_$SocialLinksModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLinksModelImplToJson(this);
  }
}

abstract class _SocialLinksModel implements SocialLinksModel {
  const factory _SocialLinksModel({
    final String? instagram,
    final String? twitter,
    final String? x,
    final String? youtube,
    final String? tiktok,
    final String? linkedin,
    final String? snapchat,
    final String? facebook,
    final String? website,
    final String? supportLink,
  }) = _$SocialLinksModelImpl;

  factory _SocialLinksModel.fromJson(Map<String, dynamic> json) =
      _$SocialLinksModelImpl.fromJson;

  @override
  String? get instagram;
  @override
  String? get twitter;
  @override
  String? get x;
  @override
  String? get youtube;
  @override
  String? get tiktok;
  @override
  String? get linkedin;
  @override
  String? get snapchat;
  @override
  String? get facebook;
  @override
  String? get website;
  @override
  String? get supportLink;

  /// Create a copy of SocialLinksModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialLinksModelImplCopyWith<_$SocialLinksModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
