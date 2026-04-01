/// SoundCloud-style square track card with artwork and hover overlay.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A square card displaying track artwork, title, and artist.
///
/// Shows a play button overlay on hover (desktop).
class TrackCard extends StatefulWidget {
  const TrackCard({
    super.key,
    required this.title,
    required this.artist,
    this.gradientColors,
    this.onTap,
  });

  final String title;
  final String artist;

  /// Optional custom gradient for the artwork placeholder.
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors =
        widget.gradientColors ??
        [AppColors.surfaceLight, AppColors.surfaceContainer];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: AppDimensions.trackCardSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Artwork ----
              _Artwork(isHovered: _isHovered, gradientColors: colors),
              const SizedBox(height: AppDimensions.paddingSm),
              // ---- Title ----
              Text(
                widget.title,
                style: AppTextStyles.cardTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // ---- Artist ----
              Text(
                widget.artist,
                style: AppTextStyles.cardSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square artwork placeholder with gradient and play overlay on hover.
class _Artwork extends StatelessWidget {
  const _Artwork({required this.isHovered, required this.gradientColors});

  final bool isHovered;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: SizedBox(
        width: AppDimensions.trackCardArtSize,
        height: AppDimensions.trackCardArtSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
              ),
              child: const Center(
                child: Icon(Icons.music_note, color: Colors.white24, size: 48),
              ),
            ),

            // Hover overlay with play button
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHovered ? 1.0 : 0.0,
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
