import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final IProfileRemoteDataSource _remoteDataSource;

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
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
            ? {'socialLinks': socialLinks.toModel().toJson()}
            : null),
      };

      final success = await _remoteDataSource.updateProfile(updateData);
      return Right(success);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
