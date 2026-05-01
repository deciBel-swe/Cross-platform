import 'package:flutter/material.dart';

import 'reaction_button.dart';
import 'track_comment_avatar.dart';

class CommentReactionBar extends StatelessWidget {
  const CommentReactionBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSendTap,
    this.onReactionTap,
    this.timestamp,
    this.userAvatarUrl,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? timestamp;
  final String? userAvatarUrl;
  final ValueChanged<String>? onSendTap;
  final ValueChanged<String>? onReactionTap;

  /// Builds the compact comment input and quick reactions row.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final hasText = value.text.trim().isNotEmpty;

        return Row(
          children: [
            TrackCommentAvatar(avatarUrl: userAvatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: timestamp != null
                                ? 'Comment at'
                                : 'Drop a comment...',
                            hintStyle: const TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      if (timestamp != null && !hasText) ...[
                        Text(
                          timestamp!,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else if (!hasText) ...[
                        ReactionButton(
                          emoji: '🔥',
                          onTap: () => onReactionTap?.call('🔥'),
                        ),
                        const SizedBox(width: 12),
                        ReactionButton(
                          emoji: '👏',
                          onTap: () => onReactionTap?.call('👏'),
                        ),
                        const SizedBox(width: 12),
                        ReactionButton(
                          emoji: '🥺',
                          onTap: () => onReactionTap?.call('🥺'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (hasText) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    onSendTap?.call(text);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
