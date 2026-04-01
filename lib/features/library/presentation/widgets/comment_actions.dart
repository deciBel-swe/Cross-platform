import 'package:flutter/material.dart';

class CommentActions extends StatelessWidget {
  const CommentActions();

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
