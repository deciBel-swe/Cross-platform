import 'package:flutter/material.dart';

import '../../../../core/widgets/decibel_cached_image.dart';
import '../../domain/entities/track.dart';

/// Displays a brief overview of the current track at the top of the comments section.
class TrackCommentsContextTile extends StatelessWidget {
  const TrackCommentsContextTile({super.key, required this.track});

  final Track track;

  /// Builds the track context row above comments.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artistName = track.artist.displayName ?? track.artist.username;

    return Semantics(
      container: true,
      label: 'Commenting on ${track.title} by $artistName',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                  ? DecibelCachedImage(
                      imageUrl: track.coverUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: 48,
                        height: 48,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.music_note,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artistName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
