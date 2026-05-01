import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../domain/repositories/playlist_social_repository.dart';
import '../providers/playlist_social_provider.dart';

class UserLikedPlaylistsNotifier
    extends AutoDisposeAsyncNotifier<List<Playlist>> {
  IPlaylistSocialRepository get _repository =>
      ref.read(playlistSocialRepositoryProvider);

  @override
  FutureOr<List<Playlist>> build() async {
    final authState = ref.watch(authStateProvider).value;
    if (authState is AuthAuthenticated) {
      final username = authState.user.username;
      final result = await _repository.getLikedPlaylists(
        username,
        page: 0,
        size: 20,
      );
      return result.fold((failure) {
        if (failure is NetworkFailure) {
          return const <Playlist>[];
        }
        throw failure;
      }, (playlists) => playlists);
    }
    return [];
  }

  void removePlaylistLocal(int playlistId) {
    final currentList = state.valueOrNull;
    if (currentList == null) return;

    final updatedList = currentList.where((p) => p.id != playlistId).toList();
    state = AsyncData(updatedList);
  }
}
