import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import 'playlist_details_provider.dart';
import 'user_playlists_provider.dart';

class EditPlaylistNotifier
    extends AutoDisposeFamilyAsyncNotifier<void, Playlist> {
  late List<Track> _currentTracks;
  late List<Track> _initialTracks;

  @override
  FutureOr<void> build(Playlist arg) {
    _initialTracks = List.from(arg.tracks);
    _currentTracks = List.from(arg.tracks);
  }

  // Safely compares the IDs to know if the order actually changed
  bool get hasChanges {
    if (_currentTracks.length != _initialTracks.length) return true;
    for (int i = 0; i < _currentTracks.length; i++) {
      if (_currentTracks[i].id != _initialTracks[i].id) return true;
    }
    return false;
  }

  List<Track> get currentTracks => _currentTracks;

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final track = _currentTracks.removeAt(oldIndex);
    _currentTracks.insert(newIndex, track);

    // Force Riverpod to rebuild the UI by re-assigning the state
    state = const AsyncData(null);
  }

  Future<bool> saveChanges() async {
    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);
    final trackIds = _currentTracks.map((t) => t.id).toList();

    final result = await repository.reorderTracks(arg.id, trackIds);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (updatedPlaylist) {
        _initialTracks = List.from(_currentTracks);
        state = const AsyncData(null);
        ref.invalidate(playlistDetailsProvider(arg.id));
        return true;
      },
    );
  }
}

final editPlaylistProvider = AsyncNotifierProvider.autoDispose
    .family<EditPlaylistNotifier, void, Playlist>(EditPlaylistNotifier.new);
