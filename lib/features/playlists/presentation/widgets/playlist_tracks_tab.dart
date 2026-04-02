import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../providers/edit_playlist_provider.dart';

/// The "Tracks" tab showing the list of songs inside the playlist.
class PlaylistTracksTab extends ConsumerWidget {
  const PlaylistTracksTab({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(editPlaylistProvider(playlist));

    final notifier = ref.read(editPlaylistProvider(playlist).notifier);
    final currentTracks = notifier.currentTracks;

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
        buildDefaultDragHandles: false,
        onReorder: notifier.reorder,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, index) {
          final track = currentTracks[index];
          return _PlaylistTrackTile(
            key: ValueKey(track.id),
            track: track,
            index: index,
          );
        },
      ),
    );
  }
}

class _PlaylistTrackTile extends StatelessWidget {
  const _PlaylistTrackTile({
    super.key,
    required this.track,
    required this.index,
  });

  final Track track;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
          image: track.coverUrl != null
              ? DecorationImage(
                  image: NetworkImage(track.coverUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: track.coverUrl == null
            ? const Icon(Icons.music_note, color: AppColors.textMuted)
            : null,
      ),
      title: Text(
        track.title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            track.artist.username,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.pause_circle_filled,
                color: AppColors.textMuted,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                track.state.name,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.drag_indicator, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
