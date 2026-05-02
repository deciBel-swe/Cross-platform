import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrackCommentAvatar extends StatelessWidget {
  const TrackCommentAvatar({super.key, required this.avatarUrl});

  final String? avatarUrl;

  /// Builds a circular avatar with a fallback person icon.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidUrl = avatarUrl != null && avatarUrl!.isNotEmpty;

    return CircleAvatar(
      radius: 18,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      backgroundImage: hasValidUrl
          ? CachedNetworkImageProvider(avatarUrl!)
          : null,
      onBackgroundImageError: hasValidUrl
          ? (exception, stackTrace) => debugPrint('Image failed: $exception')
          : null,
      child: !hasValidUrl
          ? Icon(
              Icons.person,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : null,
    );
  }
}
