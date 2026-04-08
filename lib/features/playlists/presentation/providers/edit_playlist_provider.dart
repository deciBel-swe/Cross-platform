import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../notifiers/edit_playlist_notifier.dart';

final editPlaylistProvider = AsyncNotifierProvider.autoDispose
    .family<EditPlaylistNotifier, List<Track>, Playlist>(
  EditPlaylistNotifier.new,
);