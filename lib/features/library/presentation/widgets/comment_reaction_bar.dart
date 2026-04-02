import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final hasText = value.text.trim().isNotEmpty;

        return Row(
          children: [
            _UserAvatar(imageUrl: userAvatarUrl),
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
                        _ReactionButton(
                          emoji: '🔥',
                          onTap: () => onReactionTap?.call('🔥'),
                        ),
                        const SizedBox(width: 12),
                        _ReactionButton(
                          emoji: '👏',
                          onTap: () => onReactionTap?.call('👏'),
                        ),
                        const SizedBox(width: 12),
                        _ReactionButton(
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

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.trim().isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white54,
                );
              },
            )
          : const Icon(Icons.person, size: 20, color: Colors.white54),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({required this.emoji, this.onTap});

  final String emoji;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(emoji, style: const TextStyle(fontSize: 18)),
    );
  }
}

class MentionTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!text.startsWith('@')) {
      return TextSpan(text: text, style: style);
    }

    final int firstSpaceIndex = text.indexOf(' ');

    if (firstSpaceIndex == -1) {
      return TextSpan(
        text: text,
        style: style?.copyWith(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final String mention = text.substring(0, firstSpaceIndex);
    final String rest = text.substring(firstSpaceIndex);

    return TextSpan(
      style: style,
      children: [
        TextSpan(
          text: mention,
          style: style?.copyWith(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(text: rest, style: style),
      ],
    );
  }
}
