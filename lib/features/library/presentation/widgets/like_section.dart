import 'package:flutter/material.dart';

class LikeSection extends StatelessWidget {
  const LikeSection({super.key, required this.count});
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
