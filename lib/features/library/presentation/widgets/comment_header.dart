import 'package:flutter/material.dart';

///  sub-widget for the header row
class CommentHeader extends StatelessWidget {
  const CommentHeader({
    super.key,
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
