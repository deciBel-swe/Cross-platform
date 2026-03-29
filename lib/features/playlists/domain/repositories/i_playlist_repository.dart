import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/playlist.dart';
import '../entities/playlist_metadata.dart';

abstract class IPlaylistRepository {
  /// Creates a new playlist using the provided metadata.
  Future<Either<Failure, Playlist>> createPlaylist(PlaylistMetadata metadata);

  /// Updates an existing playlist's metadata.
  Future<Either<Failure, Playlist>> updatePlaylist(
    int playlistId,
    PlaylistMetadata metadata,
  );

  /// Deletes a playlist by its ID.
  Future<Either<Failure, void>> deletePlaylist(int playlistId);
}
