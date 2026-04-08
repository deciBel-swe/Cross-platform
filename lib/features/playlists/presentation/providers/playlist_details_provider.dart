import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/playlist.dart';
import '../notifiers/playlist_details_notifier.dart';

/// A StateProvider to hold the temporary dragged order before hitting Save
final pendingTracksProvider = StateProvider.autoDispose<List<int>?>(
  (ref) => null,
);

final playlistDetailsProvider = AsyncNotifierProvider.autoDispose
    .family<PlaylistDetailsNotifier, Playlist, int>(
  PlaylistDetailsNotifier.new,
);