import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/entities/user_profile.dart'; // Add this import
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
      // 1. Fetch the raw data model from your Dio data source
      final model = await _remoteDataSource.getUserProfile();
      
      // 2. Convert to Domain Entity and return on the Right (Success) side
      return Right(model.toEntity());
      
    } on AuthException catch (e) {
      // Return Auth errors on the Left side
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      // Return Server errors on the Left side
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Catch any unexpected parsing or network errors
      return Left(ServerFailure(e.toString()));
    }
  }
}