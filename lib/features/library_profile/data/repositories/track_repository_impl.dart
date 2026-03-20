import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/track_remote_data_source.dart';

@LazySingleton(as: TrackRepository)
class TrackRepositoryImpl implements TrackRepository {
  const TrackRepositoryImpl(this._remoteDataSource);

  final ITrackRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Track>>> getUserTracks(int userId) async {
    try {
      // 1. Fetch DTOs from the remote data source
      final dtos = await _remoteDataSource.getUserTracks(userId);
      
      // 2. Map DTOs to Entities using .toEntity()
      final tracks = dtos.map((dto) => dto.toEntity()).toList();
      
      // 3. Return Right (Success)
      return Right(tracks);
      
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}