import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/repositories/i_offline_repository.dart';
import '../datasources/offline_local_data_source.dart';

@LazySingleton(as: IOfflineRepository)
class OfflineRepositoryImpl implements IOfflineRepository {
  OfflineRepositoryImpl(this._localDataSource);

  final OfflineLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, String>> downloadTrack(Track track) async {
    try {
      final path = await _localDataSource.downloadAndSave(track);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure('Failed to download track: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Track>>> getDownloadedTracks() async {
    try {
      final tracks = await _localDataSource.getOfflineTracks();
      return Right(tracks);
    } catch (e) {
      return Left(ServerFailure('Failed to load offline tracks: $e'));
    }
  }
}
