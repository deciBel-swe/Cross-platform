import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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
      if (e is DioException && _isNetworkError(e)) {
        return const Left(
          NetworkFailure('Connect to the internet to download this track.'),
        );
      }
      return Left(ServerFailure('Failed to download track: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> downloadTracks(
    List<Track> tracks, {
    void Function(double progress)? onProgress,
  }) async {
    if (tracks.isEmpty) {
      return const Right(null);
    }

    int completed = 0;
    onProgress?.call(0.0);

    for (final track in tracks) {
      try {
        await _localDataSource.downloadAndSave(track);
      } catch (e) {
        if (e is DioException && _isNetworkError(e)) {
          return const Left(
            NetworkFailure('Connection lost during download. Please retry.'),
          );
        }
        // Non-fatal — skip individual track failures and continue.
      }
      completed++;
      onProgress?.call(completed / tracks.length);
    }

    return const Right(null);
  }

  @override
  Future<Either<Failure, List<Track>>> getDownloadedTracks() async {
    try {
      final tracks = await _localDataSource.getOfflineTracks();
      return Right(tracks);
    } catch (e) {
      return Left(CacheFailure('Failed to load offline tracks: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCollectionMetadata(
    OfflineCollectionInfo info,
  ) async {
    try {
      await _localDataSource.saveCollectionMetadata(info);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save collection metadata: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OfflineCollectionInfo>>>
      getOfflineCollections() async {
    try {
      final collections = await _localDataSource.getOfflineCollections();
      return Right(collections);
    } catch (e) {
      return Left(CacheFailure('Failed to load offline collections: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCollectionMetadata(int id) async {
    try {
      await _localDataSource.deleteCollectionMetadata(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete collection metadata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCollectionMetadata(
    OfflineCollectionInfo info,
  ) async {
    try {
      await _localDataSource.updateCollectionMetadata(info);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update collection metadata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTrackFromCollection(
    int collectionId,
    int trackId,
  ) async {
    try {
      await _localDataSource.removeTrackFromCollection(collectionId, trackId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove track from collection: $e'));
    }
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }
}
