import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/playlist.dart';
import '../entities/playlist_metadata.dart';

abstract class IPlaylistRepository {
  /// Fetches a specific playlist by ID, including its full track list.
  Future<Either<Failure, Playlist>> getPlaylistDetails(int playlistId);

  /// Configure the order of the tracks in its playlist
  Future<Either<Failure, Playlist>> reorderTracks(
    int playlistId,
    List<int> trackIds,
  );

  /// Fetches all playlists created by the current user.
  Future<Either<Failure, List<Playlist>>> getUserPlaylists({
    required int page,
    required int size,
  });

  /// Fetches the secret link for a specific playlist
  Future<Either<Failure, String>> getPlaylistSecretLink(int playlistId);

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
