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
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String get tier => throw _privateConstructorUsedError;
  int get followersCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  int get tracksCount => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  SocialLinksModel? get socialLinks => throw _privateConstructorUsedError;

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
    String username,
    String displayName,
    String email,
    String? bio,
    String tier,
    int followersCount,
    int followingCount,
    int tracksCount,
    bool isVerified,
    SocialLinksModel? socialLinks,
  });

  $SocialLinksModelCopyWith<$Res>? get socialLinks;
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
    Object? username = null,
    Object? displayName = null,
    Object? email = null,
    Object? bio = freezed,
    Object? tier = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? tracksCount = null,
    Object? isVerified = null,
    Object? socialLinks = freezed,
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
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as String,
            followersCount: null == followersCount
                ? _value.followersCount
                : followersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tracksCount: null == tracksCount
                ? _value.tracksCount
                : tracksCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            socialLinks: freezed == socialLinks
                ? _value.socialLinks
                : socialLinks // ignore: cast_nullable_to_non_nullable
                      as SocialLinksModel?,
          )
          as $Val,
    );
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
    String username,
    String displayName,
    String email,
    String? bio,
    String tier,
    int followersCount,
    int followingCount,
    int tracksCount,
    bool isVerified,
    SocialLinksModel? socialLinks,
  });

  @override
  $SocialLinksModelCopyWith<$Res>? get socialLinks;
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
    Object? username = null,
    Object? displayName = null,
    Object? email = null,
    Object? bio = freezed,
    Object? tier = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? tracksCount = null,
    Object? isVerified = null,
    Object? socialLinks = freezed,
  }) {
    return _then(
      _$UserProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as String,
        followersCount: null == followersCount
            ? _value.followersCount
            : followersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tracksCount: null == tracksCount
            ? _value.tracksCount
            : tracksCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        socialLinks: freezed == socialLinks
            ? _value.socialLinks
            : socialLinks // ignore: cast_nullable_to_non_nullable
                  as SocialLinksModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.bio,
    required this.tier,
    required this.followersCount,
    required this.followingCount,
    required this.tracksCount,
    required this.isVerified,
    this.socialLinks,
  });

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String? bio;
  @override
  final String tier;
  @override
  final int followersCount;
  @override
  final int followingCount;
  @override
  final int tracksCount;
  @override
  final bool isVerified;
  @override
  final SocialLinksModel? socialLinks;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, username: $username, displayName: $displayName, email: $email, bio: $bio, tier: $tier, followersCount: $followersCount, followingCount: $followingCount, tracksCount: $tracksCount, isVerified: $isVerified, socialLinks: $socialLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.tracksCount, tracksCount) ||
                other.tracksCount == tracksCount) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.socialLinks, socialLinks) ||
                other.socialLinks == socialLinks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    displayName,
    email,
    bio,
    tier,
    followersCount,
    followingCount,
    tracksCount,
    isVerified,
    socialLinks,
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
    required final String username,
    required final String displayName,
    required final String email,
    final String? bio,
    required final String tier,
    required final int followersCount,
    required final int followingCount,
    required final int tracksCount,
    required final bool isVerified,
    final SocialLinksModel? socialLinks,
  }) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String get email;
  @override
  String? get bio;
  @override
  String get tier;
  @override
  int get followersCount;
  @override
  int get followingCount;
  @override
  int get tracksCount;
  @override
  bool get isVerified;
  @override
  SocialLinksModel? get socialLinks;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialLinksModel _$SocialLinksModelFromJson(Map<String, dynamic> json) {
  return _SocialLinksModel.fromJson(json);
}

/// @nodoc
mixin _$SocialLinksModel {
  String? get instagram => throw _privateConstructorUsedError;
  String? get twitter => throw _privateConstructorUsedError;
  @JsonKey(name: 'x')
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
    @JsonKey(name: 'x') String? x,
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
    @JsonKey(name: 'x') String? x,
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
    @JsonKey(name: 'x') this.x,
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
  @JsonKey(name: 'x')
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
    @JsonKey(name: 'x') final String? x,
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
  @JsonKey(name: 'x')
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
