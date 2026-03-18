import 'package:flutter/material.dart';

class UploadTrackCardCoverArt extends StatelessWidget {
  const UploadTrackCardCoverArt({
    super.key,
    required this.isProcessing,
    this.url,
  });

  final String? url;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        image: url != null && !isProcessing
            ? DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)
            : null,
      ),
      child: isProcessing
          ? const Center(child: CircularProgressIndicator())
          : (url == null ? const Icon(Icons.music_note) : null),
    );
  }
}
