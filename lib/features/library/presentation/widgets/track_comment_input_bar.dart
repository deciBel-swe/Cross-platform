import 'package:flutter/material.dart';

class CommentReactionBar extends StatefulWidget {
  const CommentReactionBar({super.key, this.onSendTap, this.onReactionTap});

  final ValueChanged<String>? onSendTap;
  final ValueChanged<String>? onReactionTap;

  @override
  State<CommentReactionBar> createState() => _CommentReactionBarState();
}

class _CommentReactionBarState extends State<CommentReactionBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ValueListenableBuilder ensures the UI updates the exact millisecond the text changes
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final hasText = value.text.trim().isNotEmpty;

        return Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Drop a commen...',
                            hintStyle: TextStyle(color: Colors.white38),
                          ),
                        ),
                      ),
                      // Emojis disappear smoothly when text is present
                      if (!hasText) ...[
                        const SizedBox(width: 8),
                        _ReactionButton(
                          emoji: '🔥',
                          onTap: () => widget.onReactionTap?.call('🔥'),
                        ),
                        const SizedBox(width: 12),
                        _ReactionButton(
                          emoji: '👏',
                          onTap: () => widget.onReactionTap?.call('👏'),
                        ),
                        const SizedBox(width: 12),
                        _ReactionButton(
                          emoji: '🥺',
                          onTap: () => widget.onReactionTap?.call('🥺'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Send button appears when typing
            if (hasText) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (_controller.text.trim().isNotEmpty) {
                    widget.onSendTap?.call(_controller.text.trim());
                    _controller.clear();
                    FocusScope.of(context).unfocus();
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
                    size: 20,
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

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({required this.emoji, this.onTap});

  final String emoji;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
