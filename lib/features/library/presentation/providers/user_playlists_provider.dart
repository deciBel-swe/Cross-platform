import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart';

/// Fetches and caches the user's list of playlists.
final userPlaylistsProvider =
    AsyncNotifierProvider.autoDispose<UserPlaylistsNotifier, List<Playlist>>(
      UserPlaylistsNotifier.new,
    );

class UserPlaylistsNotifier extends AutoDisposeAsyncNotifier<List<Playlist>> {
  @override
  Future<List<Playlist>> build() async {
    final repository = ref.read(playlistRepositoryProvider);

    final result = await repository.getUserPlaylists(page: 0, size: 20);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (playlists) => playlists,
    );
  }
}
