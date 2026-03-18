import 'package:flutter/material.dart';

import 'upload_track_card_cover_art.dart';

class UploadTrackCardHeader extends StatelessWidget {
  const UploadTrackCardHeader({
    super.key,
    required this.title,
    required this.isProcessing,
    this.coverUrl,
    this.trailing,
  });

  final String title;
  final bool isProcessing;
  final String? coverUrl;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        UploadTrackCardCoverArt(url: coverUrl, isProcessing: isProcessing),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
