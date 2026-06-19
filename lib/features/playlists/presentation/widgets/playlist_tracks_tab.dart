import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../domain/entities/playlist.dart';
import '../providers/edit_playlist_provider.dart';

/// The "Tracks" tab showing the list of songs inside the playlist.
class PlaylistTracksTab extends ConsumerWidget {
  const PlaylistTracksTab({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editPlaylistProvider(playlist));

    final notifier = ref.read(editPlaylistProvider(playlist).notifier);
    final currentTracks = state.value ?? [];

    if (currentTracks.isEmpty) {
      return const Center(
        child: Text(
          'No tracks yet. Add some!',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ReorderableListView.builder(
        itemCount: currentTracks.length,
        buildDefaultDragHandles: false, // We provide our own drag handle below
        onReorder: notifier.reorder,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, index) {
          final track = currentTracks[index];

          return Dismissible(
            key: ValueKey('dismiss_${track.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColors.errors,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24.0),
              child: const Icon(Icons.delete, color: AppColors.onPrimary),
            ),
            onDismissed: (direction) {
              notifier.removeTrackLocally(index);
            },
            child: Row(
              children: [
                // --- 1. Your Existing Reusable TrackTile ---
                Expanded(
                  child: TrackTile(
                    track: track,
                    onTap: () {
                      ref
                          .read(trackAudioProvider.notifier)
                          .playTrack(
                            track: track,
                            queue: currentTracks,
                            autoPlay: true,
                          );
                    },
                  ),
                ),
                // --- 2. The Drag Handle for Reordering ---
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.drag_indicator,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
