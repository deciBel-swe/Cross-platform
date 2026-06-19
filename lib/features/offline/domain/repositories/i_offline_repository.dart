import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../library/domain/entities/track.dart';
import '../../data/datasources/offline_local_data_source.dart';

abstract class IOfflineRepository {
  /// Downloads a track using its [Track.trackUrl] and saves it
  /// locally as data, returning the path to the stored file.
  Future<Either<Failure, String>> downloadTrack(Track track);

  /// Downloads all tracks in [tracks] sequentially and reports
  /// progress via [onProgress] (value from 0.0 to 1.0).
  Future<Either<Failure, void>> downloadTracks(
    List<Track> tracks, {
    void Function(double progress)? onProgress,
  });

  /// Retrieves all offline downloaded tracks.
  Future<Either<Failure, List<Track>>> getDownloadedTracks();

  /// Saves collection (playlist / station) metadata so the Downloads screen
  /// can show grouped views instead of a flat track list.
  Future<Either<Failure, void>> saveCollectionMetadata(
    OfflineCollectionInfo info,
  );

  /// Returns all collections whose track IDs have at least one downloaded file.
  Future<Either<Failure, List<OfflineCollectionInfo>>> getOfflineCollections();

  /// Deletes persisted metadata for a collection [id].
  Future<Either<Failure, void>> deleteCollectionMetadata(int id);

  /// Updates persisted metadata for a collection with [info].
  Future<Either<Failure, void>> updateCollectionMetadata(
    OfflineCollectionInfo info,
  );

  /// Removes a track with [trackId] from the collection with [collectionId].
  Future<Either<Failure, void>> removeTrackFromCollection(
    int collectionId,
    int trackId,
  );
}
