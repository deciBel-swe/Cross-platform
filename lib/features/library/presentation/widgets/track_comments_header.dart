import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays the top bar of the comments bottom sheet, showing the total count.
class TrackCommentsHeader extends StatelessWidget {
  const TrackCommentsHeader({super.key, required this.commentCount});

  final int commentCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: () => context.pop(),
          ),
          Text(
            '$commentCount comments',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: () {
              // TODO(decibel): Implement sort/filter options
            },
          ),
        ],
      ),
    );
  }
}
