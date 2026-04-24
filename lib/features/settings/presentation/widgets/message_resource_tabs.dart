import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/presentation/notifiers/liked_tracks_notifier.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart';
import 'message_resource_items.dart';
import 'message_resource_states.dart';

class MessageLikedTracksTab extends ConsumerWidget {
  const MessageLikedTracksTab({
    super.key,
    required this.isSelected,
    required this.onSelect,
  });

  final bool Function(String type, int id) isSelected;
  final void Function(String type, int id) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedAsync = ref.watch(likedTracksProvider);

    return likedAsync.when(
      data: (tracks) {
        if (tracks.isEmpty) {
          return const MessageResourceEmptyState(text: 'No liked tracks yet.');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];

            return MessageTrackResourceTile(
              track: track,
              selected: isSelected('TRACK', track.id),
              onTap: () => onSelect('TRACK', track.id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          MessageResourceErrorState(text: 'Failed to load likes.\n$error'),
    );
  }
}

class MessageUploadsTab extends ConsumerWidget {
  const MessageUploadsTab({
    super.key,
    required this.isSelected,
    required this.onSelect,
  });

  final bool Function(String type, int id) isSelected;
  final void Function(String type, int id) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadsAsync = ref.watch(uploadsProvider);

    return uploadsAsync.when(
      data: (tracks) {
        if (tracks.isEmpty) {
          return const MessageResourceEmptyState(text: 'No uploads yet.');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];

            return MessageTrackResourceTile(
              track: track,
              selected: isSelected('TRACK', track.id),
              onTap: () => onSelect('TRACK', track.id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          MessageResourceErrorState(text: 'Failed to load uploads.\n$error'),
    );
  }
}

class MessagePlaylistsTab extends ConsumerWidget {
  const MessagePlaylistsTab({
    super.key,
    required this.isSelected,
    required this.onSelect,
  });

  final bool Function(String type, int id) isSelected;
  final void Function(String type, int id) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(userPlaylistsProvider);

    return playlistsAsync.when(
      data: (playlists) {
        if (playlists.isEmpty) {
          return const MessageResourceEmptyState(text: 'No playlists yet.');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];

            return MessagePlaylistResourceTile(
              playlist: playlist,
              selected: isSelected('PLAYLIST', playlist.id),
              onTap: () => onSelect('PLAYLIST', playlist.id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          MessageResourceErrorState(text: 'Failed to load playlists.\n$error'),
    );
  }
}
