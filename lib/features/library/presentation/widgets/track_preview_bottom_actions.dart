import 'package:flutter/material.dart';

import '../../domain/entities/track.dart';

/// Bottom actions row for the track preview screen.
class TrackPreviewBottomActions extends StatelessWidget {
  const TrackPreviewBottomActions({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomActionItem(
              icon: Icons.favorite_border,
              label: _formatCount(track.likeCount),
              color: theme.colorScheme.onSurface,
            ),
            _BottomActionItem(
              icon: Icons.mode_comment_outlined,
              label: '0',
              color: theme.colorScheme.onSurface,
            ),
            _BottomActionItem(
              icon: Icons.share_outlined,
              color: theme.colorScheme.onSurface,
            ),
            _BottomActionItem(
              icon: Icons.playlist_add_outlined,
              color: theme.colorScheme.onSurface,
            ),
            _BottomActionItem(
              icon: Icons.more_horiz,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }
}

class _BottomActionItem extends StatelessWidget {
  const _BottomActionItem({
    required this.icon,
    required this.color,
    this.label,
  });

  final IconData icon;
  final Color color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ],
    );
  }
}
