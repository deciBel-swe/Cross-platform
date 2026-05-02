import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._secureStorageService,
  );

  final IProfileRemoteDataSource _remoteDataSource;
  final IProfileLocalDataSource _localDataSource;
  final SecureStorageService _secureStorageService;

  @override
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  ) async {
    try {
      final model = await _remoteDataSource.updateSocialLinks(links.toModel());
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final model = await _remoteDataSource.getUserProfile();

      // 1. Update local profile cache
      await _localDataSource.cacheUserProfile(model);

      // 2. Sync tier with AuthUser in secure storage for offline availability on restart
      try {
        final cachedAuthUser = await _secureStorageService.getUser();
        if (cachedAuthUser != null && cachedAuthUser.id == model.id) {
          final tierString = _tierToString(model.tier);
          await _secureStorageService.updateUser(
            cachedAuthUser.copyWith(
              tier: tierString,
              displayName: model.displayName,
              avatarUrl: model.profileDetails.profilePic,
            ),
          );
        }
      } catch (e) {
        // Non-fatal error during sync
      }

      return Right(model.toEntity());
    } on NetworkException {
      // Fallback to local cache if network is unavailable
      final localModel = await _localDataSource.getLastUserProfile();
      if (localModel != null) {
        return Right(localModel.toEntity());
      }
      return const Left(NetworkFailure('Offline and no cached profile found.'));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      // General error fallback to local cache
      final localModel = await _localDataSource.getLastUserProfile();
      if (localModel != null) {
        return Right(localModel.toEntity());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  String _tierToString(UserTier tier) {
    switch (tier) {
      case UserTier.pro:
        return 'PRO';
      case UserTier.artistPro:
        return 'ARTIST_PRO';
      case UserTier.free:
        return 'FREE';
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getPublicProfile(int userId) async {
    try {
      final model = await _remoteDataSource.getPublicProfile(userId);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile({
    String? displayName,
    String? bio,
    String? city,
    String? country,
    List<String>? favoriteGenres,
    PublicProfileSocialLinks? socialLinks,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        ...?(displayName != null ? {'displayName': displayName} : null),
        ...?(bio != null ? {'bio': bio} : null),
        ...?(city != null ? {'city': city} : null),
        ...?(country != null ? {'country': country} : null),
        ...?(favoriteGenres != null
            ? {'favoriteGenres': favoriteGenres}
            : null),
        ...?(socialLinks != null
            ? {
                'socialLinks': {
                  for (final platform in socialLinks.nonEmptyPlatforms(
                    includeSupportLink: false,
                  ))
                    platform: socialLinks.valueForPlatform(platform),
                },
              }
            : null),
      };

      final success = await _remoteDataSource.updateProfile(updateData);
      return Right(success);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateImages({
    File? profilePic,
    File? coverPic,
  }) async {
    try {
      final success = await _remoteDataSource.updateProfileImages(
        profilePic: profilePic,
        coverPic: coverPic,
      );

      return Right(success);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
