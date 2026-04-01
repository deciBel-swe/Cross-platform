import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/comment.dart';

/// Displays a single comment, including user info, timestamp, and content.
class TrackCommentTile extends ConsumerWidget {
  const TrackCommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timeFormatted = _formatTimeAgo(comment.createdAt);

    // Ensure we handle null timestamp safely
    final timestampSeconds = comment.timestampSeconds ?? 0;
    final timestampFormatted = _formatTimestamp(timestampSeconds);

    // Logic for Image Handling
    final avatarUrl = comment.user.avatarUrl;
    final hasValidUrl = avatarUrl != null && avatarUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,

            // 1. Only provide the provider if the URL is valid
            backgroundImage: hasValidUrl ? NetworkImage(avatarUrl) : null,

            // If there is no image, there MUST be no error handler.
            onBackgroundImageError: hasValidUrl
                ? (exception, stackTrace) {
                    debugPrint('Image failed: $exception');
                  }
                : null,

            // 3. Fallback UI
            child: !hasValidUrl
                ? Icon(
                    Icons.person,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CommentHeader(
                  username: comment.user.username,
                  timestamp: timestampFormatted,
                  timeAgo: timeFormatted,
                  onTimestampTap: () {
                    ref
                        .read(trackAudioProvider.notifier)
                        .seek(Duration(seconds: timestampSeconds));
                  },
                ),
                const SizedBox(height: 6),
                Text(comment.body, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                const _CommentActions(),
              ],
            ),
          ),
          const _LikeSection(count: '0'),
        ],
      ),
    );
  }

  // Formatting helpers kept private to the widget
  String _formatTimestamp(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 7) return '${difference.inDays ~/ 7}w';
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Just now';
  }
}

/// Private sub-widget for the header row to keep main build clean
class _CommentHeader extends StatelessWidget {
  const _CommentHeader({
    required this.username,
    required this.timestamp,
    required this.timeAgo,
    required this.onTimestampTap,
  });

  final String username;
  final String timestamp;
  final String timeAgo;
  final VoidCallback onTimestampTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fadedTextStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return Row(
      children: [
        Text(
          username,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(width: 6),
        Text("at", style: fadedTextStyle),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTimestampTap,
          child: Text(
            timestamp,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text('• $timeAgo', style: fadedTextStyle),
      ],
    );
  }
}

class _CommentActions extends StatelessWidget {
  const _CommentActions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Row(
      children: [
        Text('Reply', style: actionStyle),
        const SizedBox(width: 16),
        Icon(
          Icons.more_vert,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ],
    );
  }
}

class _LikeSection extends StatelessWidget {
  const _LikeSection({required this.count});
  final String count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 18),
          color: color,
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          onPressed: () {},
        ),
        const SizedBox(height: 4),
        Text(count, style: theme.textTheme.labelSmall?.copyWith(color: color)),
      ],
    );
  }
}
