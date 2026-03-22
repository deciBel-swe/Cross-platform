import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/paginated_tracks.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/library_remote_datasource.dart';
import '../models/paginated_tracks_model.dart';
import '../models/track_model.dart';
import '../models/track_peaks_model.dart';

@Environment('prod')
@LazySingleton(as: TrackRepository)
class TrackRepositoryImpl implements TrackRepository {
  const TrackRepositoryImpl(this._remote);

  final LibraryRemoteDatasource _remote;

  @override
  Future<Either<Failure, PaginatedTracks>> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    try {
      final model = await _remote.fetchTracks(
        userId: userId,
        page: page,
        size: size,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    try {
      final model = await _remote.fetchTrackById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) async {
    try {
      final model = await _remote.fetchTrackPeaks(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
