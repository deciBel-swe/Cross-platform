import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart';

/// Handles the side-effect of adding a track to a playlist.
final addToPlaylistProvider =
    AsyncNotifierProvider<AddToPlaylistNotifier, void>(
      AddToPlaylistNotifier.new,
    );

class AddToPlaylistNotifier extends AsyncNotifier<void> {
  bool _mounted = true;

  /// Registers disposal tracking for pending add requests.
  @override
  FutureOr<void> build() {
    ref.onDispose(() => _mounted = false);
  }

  /// Adds a track to a playlist and returns true on success.
  Future<bool> addTrack({
    required int playlistId,
    required int trackId,
    Track? track,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);

    final result = await repository.addTrackToPlaylist(playlistId, trackId);

    if (!_mounted) return false;

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);

        if (track != null) {
          ref
              .read(userPlaylistsProvider.notifier)
              .addTrackLocally(playlistId, track);
        }

        return true;
      },
    );
  }
}
