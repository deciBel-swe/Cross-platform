import 'dart:io';

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
    ImageProvider? imageProvider;
    if (url != null) {
      if (url!.startsWith('http')) {
        imageProvider = NetworkImage(url!);
      } else {
        imageProvider = FileImage(File(url!));
      }
    }

    final theme = Theme.of(context);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        image: imageProvider != null
            ? DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                onError: (_, __) {}, // Prevent crash on bad URL/File
              )
            : null,
      ),
      child: isProcessing
          ? const Center(child: CircularProgressIndicator())
          : (imageProvider == null ? const Icon(Icons.music_note) : null),
    );
  }
}
