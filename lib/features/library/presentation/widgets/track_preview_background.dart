import 'dart:ui';

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
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B2233), Color(0xFF07141F), Color(0xFF000000)],
          ),
        ),
        child: imageUrl == null || imageUrl!.isEmpty
            ? null
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl!, fit: BoxFit.cover),

                  if (isBlurred)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(color: Colors.black.withOpacity(0.18)),
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
