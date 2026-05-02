import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Background image layer for the track preview screen.
/// Supports optional blur on the background image only.
class TrackPreviewBackground extends StatelessWidget {
  const TrackPreviewBackground({
    super.key,
    this.imageUrl,
    this.isBlurred = false,
  });

  final String? imageUrl;
  final bool isBlurred;

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        imageProvider = CachedNetworkImageProvider(imageUrl!);
      } else {
        imageProvider = FileImage(File(imageUrl!));
      }
    }

    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B2233), Color(0xFF07141F), Color(0xFF000000)],
          ),
        ),
        child: imageProvider == null
            ? null
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(),
                  ),

                  if (isBlurred)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.18),
                        ),
                      ),
                    ),

                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.30),
                          Color.fromRGBO(0, 0, 0, 0.55),
                          Color.fromRGBO(0, 0, 0, 0.85),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
