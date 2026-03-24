import 'package:flutter/material.dart';

class UploadTrackCardContainer extends StatelessWidget {
  const UploadTrackCardContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
