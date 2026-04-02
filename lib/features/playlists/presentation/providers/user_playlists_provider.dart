import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/mock_playlist_repository.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/playlist_metadata.dart';
import '../../domain/repositories/i_playlist_repository.dart';

/// The Tab will update this, and the AppBar Save button will read it

/// Provider that manages the list of user playlists and handles state updates.
final userPlaylistsProvider =
    AsyncNotifierProvider.autoDispose<UserPlaylistsNotifier, List<Playlist>>(
      UserPlaylistsNotifier.new,
    );

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  return MockPlaylistRepository();
});

class UserPlaylistsNotifier extends AutoDisposeAsyncNotifier<List<Playlist>> {
  // Helper to easily get the repository.
  //final repository = getIt<IPlaylistRepository>();
  IPlaylistRepository get _repository => ref.read(playlistRepositoryProvider);

  @override
  FutureOr<List<Playlist>> build() async {
    // Fetch initial data
    final result = await _repository.getUserPlaylists(page: 0, size: 20);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (playlists) => playlists,
    );
  }

  /// Deletes a playlist and instantly updates the UI if the backend call succeeds.
  Future<Either<Failure, void>> deletePlaylist(int playlistId) async {
    final result = await _repository.deletePlaylist(playlistId);

    return result.fold((failure) => Left(failure), (_) {
      //  Remove it from the local state
      if (state.value != null) {
        final updatedList = state.value!
            .where((p) => p.id != playlistId)
            .toList();
        state = AsyncData(updatedList);
      }
      return const Right(null);
    });
  }

  /// Toggles privacy status and instantly updates the UI if the backend call succeeds
  Future<Either<Failure, Playlist>> togglePrivacy(Playlist playlist) async {
    final newPrivacyState = !playlist.isPrivate;

    // Create the metadata object your repository expects
    final metadataToUpdate = PlaylistMetadata(
      title: playlist.title,
      description: playlist.description ?? '',
      isPrivate: newPrivacyState,
    );

    final result = await _repository.updatePlaylist(
      playlist.id,
      metadataToUpdate,
    );

    return result.fold((failure) => Left(failure), (updatedPlaylist) {
      // Swap out the old playlist for the new one
      if (state.value != null) {
        final updatedList = state.value!.map((p) {
          return p.id == updatedPlaylist.id ? updatedPlaylist : p;
        }).toList();
        state = AsyncData(updatedList);
      }
      return Right(updatedPlaylist);
    });
  }
}
