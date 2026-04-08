// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicProfileModelImpl _$$PublicProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$PublicProfileModelImpl(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  tier: json['tier'] as String? ?? 'FREE',
  profile: json['profile'] == null
      ? null
      : PublicProfileDetailsModel.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
  socialLinks: json['socialLinks'] == null
      ? null
      : SocialLinksModel.fromJson(json['socialLinks'] as Map<String, dynamic>),
  stats: PublicStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  isFollowing: json['isFollowing'] as bool? ?? false,
  isFollowedBy: json['isFollowedBy'] as bool? ?? false,
);

Map<String, dynamic> _$$PublicProfileModelImplToJson(
  _$PublicProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'tier': instance.tier,
  'profile': instance.profile,
  'socialLinks': instance.socialLinks,
  'stats': instance.stats,
  'isFollowing': instance.isFollowing,
  'isFollowedBy': instance.isFollowedBy,
};

_$PublicProfileDetailsModelImpl _$$PublicProfileDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PublicProfileDetailsModelImpl(
  bio: json['bio'] as String?,
  location: json['Location'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  coverPhotoUrl: json['coverPhotoUrl'] as String?,
  favoriteGenres:
      (json['favoriteGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PublicProfileDetailsModelImplToJson(
  _$PublicProfileDetailsModelImpl instance,
) => <String, dynamic>{
  'bio': instance.bio,
  'Location': instance.location,
  'avatarUrl': instance.avatarUrl,
  'coverPhotoUrl': instance.coverPhotoUrl,
  'favoriteGenres': instance.favoriteGenres,
};

_$PublicStatsModelImpl _$$PublicStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PublicStatsModelImpl(
  followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
  trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PublicStatsModelImplToJson(
  _$PublicStatsModelImpl instance,
) => <String, dynamic>{
  'followersCount': instance.followersCount,
  'followingCount': instance.followingCount,
  'trackCount': instance.trackCount,
};
