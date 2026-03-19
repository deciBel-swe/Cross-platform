// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String,
  bio: json['bio'] as String?,
  tier: json['tier'] as String,
  followersCount: (json['followersCount'] as num).toInt(),
  followingCount: (json['followingCount'] as num).toInt(),
  tracksCount: (json['tracksCount'] as num).toInt(),
  isVerified: json['isVerified'] as bool,
  socialLinks: json['socialLinks'] == null
      ? null
      : SocialLinksModel.fromJson(json['socialLinks'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserProfileModelImplToJson(
  _$UserProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'displayName': instance.displayName,
  'email': instance.email,
  'bio': instance.bio,
  'tier': instance.tier,
  'followersCount': instance.followersCount,
  'followingCount': instance.followingCount,
  'tracksCount': instance.tracksCount,
  'isVerified': instance.isVerified,
  'socialLinks': instance.socialLinks,
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
