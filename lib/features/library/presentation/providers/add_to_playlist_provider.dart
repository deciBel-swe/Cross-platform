import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../playlists/presentation/providers/user_playlists_provider.dart';

/// Handles the side-effect of adding a track to a playlist.
final addToPlaylistProvider =
    AsyncNotifierProvider.autoDispose<AddToPlaylistNotifier, void>(
      AddToPlaylistNotifier.new,
    );

class AddToPlaylistNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Adds a track to a playlist and returns true on success.
  Future<bool> addTrack({required int playlistId, required int trackId}) async {
    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);

    final result = await repository.addTrackToPlaylist(playlistId, trackId);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}
