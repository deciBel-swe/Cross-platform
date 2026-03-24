import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  UserProfile _profile = const UserProfile(
    id: 101,
    role: 'USER',
    email: 'mock.user@decibel.app',
    username: 'mock_user_free',
    emailVerified: true,
    tier: UserTier.free,
    profileDetails: UserProfileDetails(
      bio: 'Mock profile for backend-free development mode.',
      city: 'Cairo',
      country: 'Egypt',
      profilePic: null,
      coverPic: null,
      favoriteGenres: <String>['Lo-fi', 'House'],
    ),
    socialLinks: PublicProfileSocialLinks(
      instagram: 'https://instagram.com/mock_user_free',
      twitter: 'https://x.com/mock_user_free',
      website: 'https://decibel.app/mock_user_free',
      supportLink: 'https://decibel.app/support',
    ),
    privacySettings: PrivacySettings(isPrivate: false, showHistory: true),
    stats: UserStats(followers: 42, following: 15, tracksCount: 3),
  );

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    return Right(_profile);
  }

  @override
  Future<Either<Failure, bool>> updateProfile({
    String? bio,
    String? city,
    String? country,
    List<String>? favoriteGenres,
    PublicProfileSocialLinks? socialLinks,
  }) async {
    final currentDetails = _profile.profileDetails;

    _profile = UserProfile(
      id: _profile.id,
      role: _profile.role,
      email: _profile.email,
      username: _profile.username,
      emailVerified: _profile.emailVerified,
      tier: _profile.tier,
      profileDetails: UserProfileDetails(
        bio: bio ?? currentDetails.bio,
        city: city ?? currentDetails.city,
        country: country ?? currentDetails.country,
        profilePic: currentDetails.profilePic,
        coverPic: currentDetails.coverPic,
        favoriteGenres: favoriteGenres ?? currentDetails.favoriteGenres,
      ),
      socialLinks: socialLinks ?? _profile.socialLinks,
      privacySettings: _profile.privacySettings,
      stats: _profile.stats,
    );

    return const Right(true);
  }

  @override
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  ) async {
    _profile = UserProfile(
      id: _profile.id,
      role: _profile.role,
      email: _profile.email,
      username: _profile.username,
      emailVerified: _profile.emailVerified,
      tier: _profile.tier,
      profileDetails: _profile.profileDetails,
      socialLinks: links,
      privacySettings: _profile.privacySettings,
      stats: _profile.stats,
    );

    return Right(links);
  }

  @override
  Future<Either<Failure, bool>> updateImages({
    File? profilePic,
    File? coverPic,
  }) async {
    final currentDetails = _profile.profileDetails;

    _profile = UserProfile(
      id: _profile.id,
      role: _profile.role,
      email: _profile.email,
      username: _profile.username,
      emailVerified: _profile.emailVerified,
      tier: _profile.tier,
      profileDetails: UserProfileDetails(
        bio: currentDetails.bio,
        city: currentDetails.city,
        country: currentDetails.country,
        profilePic: profilePic != null
            ? Uri.file(profilePic.path).toString()
            : currentDetails.profilePic,
        coverPic: coverPic != null
            ? Uri.file(coverPic.path).toString()
            : currentDetails.coverPic,
        favoriteGenres: currentDetails.favoriteGenres,
      ),
      socialLinks: _profile.socialLinks,
      privacySettings: _profile.privacySettings,
      stats: _profile.stats,
    );

    return const Right(true);
  }
}
