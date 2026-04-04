import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import 'playlist_options_bottom_sheet.dart';

/// A list tile representing a single playlist.
class PlaylistTile extends StatelessWidget {
  const PlaylistTile({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          _PlaylistCoverArt(coverArtPath: playlist.coverArt),
          const SizedBox(width: 12),
          Expanded(child: _PlaylistDetails(playlist: playlist)),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () => PlaylistOptionsBottomSheet.show(context, playlist),
          ),
        ],
      ),
    );
  }
}

class _PlaylistCoverArt extends StatelessWidget {
  const _PlaylistCoverArt({this.coverArtPath});

  final String? coverArtPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: (coverArtPath != null && coverArtPath!.trim().isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(
                File(coverArtPath!), 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const Icon(Icons.music_note, color: AppColors.textMuted),
              ),
            )
          : const Icon(Icons.music_note, color: AppColors.textMuted),
    );
  }
}

class _PlaylistDetails extends StatelessWidget {
  const _PlaylistDetails({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          playlist.owner.username.toUpperCase(),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Playlist • ${playlist.tracks.length} Tracks',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(width: 4),
            Icon(
              playlist.isPrivate ? Icons.lock : Icons.public,
              color: AppColors.textMuted,
              size: 12,
            ),
          ],
        ),
      ],
    );
  }
}
