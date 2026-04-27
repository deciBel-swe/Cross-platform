import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/data/datasources/library_remote_datasource.dart';
import '../../../library/data/models/paginated_tracks_model.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/data/models/track_peaks_model.dart';
import '../../../library/domain/entities/paginated_tracks.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_edit_request.dart';
import '../../../library/domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';

@Environment('prod')
@LazySingleton(as: TrackRepository)
class TrackRepositoryImpl implements TrackRepository {
  const TrackRepositoryImpl(this._remote);

  final LibraryRemoteDatasource _remote;

  @override
  Future<Either<Failure, PaginatedTracks>> fetchMyTracks({
    required int page,
    required int size,
  }) async {
    try {
      final model = await _remote.fetchMyTracks(page: page, size: size);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

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
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Track>> fetchTrackById(int id) async {
    try {
      final model = await _remote.fetchTrackById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> resolveTrackIdentifier(
    String trackIdentifier,
  ) async {
    try {
      final trackId = await _remote.resolveTrackIdentifier(trackIdentifier);
      return Right(trackId);
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> fetchTrackStatusById(int id) async {
    try {
      // Pass-through to backend status endpoint; provider handles polling decisions.
      final status = await _remote.fetchTrackStatusById(id);
      return Right(status);
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, TrackPeaks>> fetchTrackPeaksById(int id) async {
    try {
      final model = await _remote.fetchTrackPeaks(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, Track>> updateTrackMetadata({
    required int trackId,
    required TrackEditRequest request,
  }) async {
    try {
      final model = await _remote.updateTrackMetadata(
        trackId: trackId,
        title: request.title,
        genre: request.genre,
        description: request.description,
        tags: request.tags,
        releaseDate: request.releaseDate,
        isPrivate: request.isPrivate,
        coverImage: request.coverImage,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTrack(int trackId) async {
    try {
      await _remote.deleteTrack(trackId);
      return const Right(true);
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTrackCover(int trackId) async {
    try {
      await _remote.deleteTrackCover(trackId);
      return const Right(true);
    } catch (e) {
      return Left(_toFailure(e));
    }
  }

  Failure _toFailure(Object error) {
    if (error is DioException &&
        (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            (error.type == DioExceptionType.unknown &&
                error.error is SocketException))) {
      return const NetworkFailure(
        'No internet connection. Offline content is still available.',
      );
    }

    return ServerFailure(error.toString());
  }
}
