import 'package:flutter/material.dart';

class ReactionButton extends StatelessWidget {
  const ReactionButton({super.key, required this.emoji, this.onTap});

  final String emoji;
  final VoidCallback? onTap;

  /// Builds a tappable quick reaction label.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(emoji, style: const TextStyle(fontSize: 18)),
    );
  }
}
