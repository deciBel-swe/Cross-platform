// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  id: (json['id'] as num).toInt(),
  role: json['Role'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  emailVerified: json['emailVerified'] as bool,
  tier: $enumDecode(_$UserTierEnumMap, json['tier']),
  profileDetails: ProfileDetailsModel.fromJson(
    json['profile'] as Map<String, dynamic>,
  ),
  socialLinks: json['socialLinks'] == null
      ? null
      : SocialLinksModel.fromJson(json['socialLinks'] as Map<String, dynamic>),
  privacySettings: PrivacySettingsModel.fromJson(
    json['privacySettings'] as Map<String, dynamic>,
  ),
  stats: UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'Role': instance.role,
  'email': instance.email,
  'username': instance.username,
  'emailVerified': instance.emailVerified,
  'tier': _$UserTierEnumMap[instance.tier]!,
  'profile': instance.profileDetails,
  'socialLinks': instance.socialLinks,
  'privacySettings': instance.privacySettings,
  'stats': instance.stats,
};

const _$UserTierEnumMap = {
  UserTier.free: 'FREE',
  UserTier.pro: 'PRO',
  UserTier.artist: 'ARTIST',
};

_$ProfileDetailsModelImpl _$$ProfileDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileDetailsModelImpl(
  bio: json['bio'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  profilePic: json['profilePic'] as String?,
  coverPic: json['coverPic'] as String?,
  favoriteGenres:
      (json['favoriteGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProfileDetailsModelImplToJson(
  _$ProfileDetailsModelImpl instance,
) => <String, dynamic>{
  'bio': instance.bio,
  'city': instance.city,
  'country': instance.country,
  'profilePic': instance.profilePic,
  'coverPic': instance.coverPic,
  'favoriteGenres': instance.favoriteGenres,
};

_$PrivacySettingsModelImpl _$$PrivacySettingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PrivacySettingsModelImpl(
  isPrivate: json['isPrivate'] as bool,
  showHistory: json['showHistory'] as bool,
);

Map<String, dynamic> _$$PrivacySettingsModelImplToJson(
  _$PrivacySettingsModelImpl instance,
) => <String, dynamic>{
  'isPrivate': instance.isPrivate,
  'showHistory': instance.showHistory,
};

_$UserStatsModelImpl _$$UserStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsModelImpl(
      followers: (json['followers'] as num).toInt(),
      following: (json['following'] as num).toInt(),
      tracksCount: (json['tracksCount'] as num).toInt(),
    );

Map<String, dynamic> _$$UserStatsModelImplToJson(
  _$UserStatsModelImpl instance,
) => <String, dynamic>{
  'followers': instance.followers,
  'following': instance.following,
  'tracksCount': instance.tracksCount,
};

_$SocialLinksModelImpl _$$SocialLinksModelImplFromJson(
  Map<String, dynamic> json,
) => _$SocialLinksModelImpl(
  instagram: json['instagram'] as String?,
  twitter: json['twitter'] as String?,
  x: json['x'] as String?,
  youtube: json['youtube'] as String?,
  tiktok: json['tiktok'] as String?,
  linkedin: json['linkedin'] as String?,
  snapchat: json['snapchat'] as String?,
  facebook: json['facebook'] as String?,
  website: json['website'] as String?,
  supportLink: json['supportLink'] as String?,
);

Map<String, dynamic> _$$SocialLinksModelImplToJson(
  _$SocialLinksModelImpl instance,
) => <String, dynamic>{
  'instagram': instance.instagram,
  'twitter': instance.twitter,
  'x': instance.x,
  'youtube': instance.youtube,
  'tiktok': instance.tiktok,
  'linkedin': instance.linkedin,
  'snapchat': instance.snapchat,
  'facebook': instance.facebook,
  'website': instance.website,
  'supportLink': instance.supportLink,
};
