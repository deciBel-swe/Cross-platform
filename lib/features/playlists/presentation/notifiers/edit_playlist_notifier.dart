import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/genre_constants.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import 'playlist_form_notifier.dart';

class EditPlaylistNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Track>, Playlist> {
  late List<Track> _initialTracks;
  final List<Track> _deletedTracks = [];

  List<Track> get deletedTracks => _deletedTracks;
  List<Track> get currentTracks => state.value ?? [];

  @override
  FutureOr<List<Track>> build(Playlist arg) {
    _initialTracks = List.from(arg.tracks);
    return List.from(arg.tracks);
  }

  final genreListProvider = StateProvider<List<String>>((ref) {
  return GenreConstants.genres;
  });

  // Safely compares the IDs to know if the order actually changed
  bool get hasOrderChanged {
    final curr = currentTracks;
    final remainingInitial = _initialTracks
        .where((t) => !_deletedTracks.any((d) => d.id == t.id))
        .toList();
    if (curr.length != remainingInitial.length) return true;
    for (int i = 0; i < curr.length; i++) {
      if (curr[i].id != remainingInitial[i].id) return true;
    }
    return false;
  }

  // The screen has changes if they swiped a track OR reordered them
  bool get hasChanges => hasOrderChanged || _deletedTracks.isNotEmpty;

  void removeTrackLocally(int index) {
    final curr = List<Track>.from(currentTracks);
    _deletedTracks.add(curr[index]);
    curr.removeAt(index);
    state = AsyncData(curr);
  }

  void reorder(int oldIndex, int newIndex) {
    final curr = List<Track>.from(currentTracks);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final track = curr.removeAt(oldIndex);
    curr.insert(newIndex, track);

    // Force Riverpod to rebuild the UI by re-assigning the state
    state = AsyncData(curr);
  }

  Future<bool> saveChanges() async {
    if (!hasOrderChanged) return true;

    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);
    final curr = currentTracks;
    
    final trackIds = curr.map((t) => t.id).toList()
      ..addAll(_deletedTracks.map((t) => t.id));

    final result = await repository.reorderTracks(arg.id, trackIds);

return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        _initialTracks = List.from(curr);
        state = AsyncData(curr);
        return true;
      },
    );
  }
}

final editPlaylistProvider = AsyncNotifierProvider.autoDispose
    .family<EditPlaylistNotifier, List<Track>, Playlist>(EditPlaylistNotifier.new);
