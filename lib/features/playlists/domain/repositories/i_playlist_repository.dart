import '../entities/playlist.dart';
import '../entities/playlist_metadata.dart';

abstract class IPlaylistRepository {
  /// Creates a new playlist using the provided metadata.
  Future<Playlist> createPlaylist(PlaylistMetadata metadata);

  /// Updates an existing playlist's metadata.
  Future<Playlist> updatePlaylist(int playlistId, PlaylistMetadata metadata);

  /// Deletes a playlist by its ID.
  Future<void> deletePlaylist(int playlistId);
}
