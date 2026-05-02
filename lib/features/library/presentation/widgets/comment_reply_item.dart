import 'package:flutter/material.dart';
import '../../domain/entities/comment_reply.dart';

class CommentReplyItem extends StatelessWidget {
  const CommentReplyItem({super.key, required this.reply});
  final CommentReply reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 56, top: 12, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,

            foregroundImage:
                reply.user.avatarUrl != null && reply.user.avatarUrl!.isNotEmpty
                ? NetworkImage(reply.user.avatarUrl!)
                : null,

            child: Icon(
              Icons.person,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reply.user.username,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('2w', style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  reply.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reply',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
