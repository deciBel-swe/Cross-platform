import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../playlists/presentation/providers/playlist_details_provider.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart';
import '../../domain/models/playlist_social_data.dart';
import '../../domain/repositories/playlist_social_repository.dart';
import '../providers/playlist_social_provider.dart';

class PlaylistSocialNotifier
    extends FamilyAsyncNotifier<PlaylistSocialData, int> {
  late final IPlaylistSocialRepository _socialRepository;

  @override
  FutureOr<PlaylistSocialData> build(int arg) async {
    _socialRepository = ref.read(playlistSocialRepositoryProvider);

    // Initial state from the playlist details if available
    final playlist = await ref.read(playlistDetailsProvider(arg).future);

    return PlaylistSocialData(
      isLiked: playlist.isLiked,
      isReposted: playlist.isReposted,
    );
  }

  Future<void> toggleLike() async {
    final currentData = state.valueOrNull;
    if (currentData == null) return;

    final bool wasLiked = currentData.isLiked;

    // 1. Optimistic Update
    state = AsyncData(currentData.copyWith(isLiked: !wasLiked));

    final result = await _socialRepository.toggleLike(arg, wasLiked);

    result.fold(
      (failure) {
        // Revert on error
        state = AsyncData(currentData);
      },
      (isLiked) {
        // Ensure state is synced with server response
        final currentState = state.valueOrNull ?? currentData;
        state = AsyncData(currentState.copyWith(isLiked: isLiked));

        // Update playlist details as well to keep them in sync
        final playlistDetails = ref
            .read(playlistDetailsProvider(arg))
            .valueOrNull;
        if (playlistDetails != null) {
          ref
              .read(playlistDetailsProvider(arg).notifier)
              .updatePlaylistLocally(
                playlistDetails.copyWith(isLiked: isLiked),
              );
        }

        // Sync with liked playlists collection
        if (!isLiked) {
          if (ref.exists(userLikedPlaylistsProvider)) {
            ref
                .read(userLikedPlaylistsProvider.notifier)
                .removePlaylistLocal(arg);
          }
        }
      },
    );
  }

  Future<bool?> toggleRepost({
    bool? currentIsLiked,
    bool? currentIsReposted,
  }) async {
    final currentData =
        state.valueOrNull ??
        (currentIsReposted == null
            ? null
            : PlaylistSocialData(
                isLiked: currentIsLiked ?? false,
                isReposted: currentIsReposted,
              ));
    if (currentData == null) return null;

    final wasReposted = currentData.isReposted;
    state = AsyncData(currentData.copyWith(isReposted: !wasReposted));

    final result = await _socialRepository.toggleRepost(arg, wasReposted);

    return result.fold(
      (failure) {
        state = AsyncData(currentData);
        return null;
      },
      (isReposted) {
        final currentState = state.valueOrNull ?? currentData;
        state = AsyncData(currentState.copyWith(isReposted: isReposted));

        final playlistDetails = ref
            .read(playlistDetailsProvider(arg))
            .valueOrNull;
        if (playlistDetails != null) {
          ref
              .read(playlistDetailsProvider(arg).notifier)
              .updatePlaylistLocally(
                playlistDetails.copyWith(isReposted: isReposted),
              );
        }

        return isReposted;
      },
    );
  }
}
