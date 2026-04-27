/// SoundCloud-style square track card with artwork and hover overlay.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';

/// A square card displaying track artwork, title, and artist.
///
/// Shows a play button overlay on hover (desktop).
class TrackCard extends StatefulWidget {
  const TrackCard({
    super.key,
    required this.title,
    required this.artist,
    this.imageUrl,
    this.gradientColors,
    this.tagLabel,
    this.supportingText,
    this.onTap,
  });

  final String title;
  final String artist;

  /// Optional cover art URL for the track.
  final String? imageUrl;

  /// Optional custom gradient for the artwork placeholder.
  final List<Color>? gradientColors;
  final String? tagLabel;
  final String? supportingText;
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

    return Semantics(
      button: widget.onTap != null,
      enabled: widget.onTap != null,
      label: 'Play ${widget.title} by ${widget.artist}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: AppDimensions.trackCardSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Artwork ----
                _Artwork(
                  isHovered: _isHovered,
                  gradientColors: colors,
                  imageUrl: widget.imageUrl,
                  tagLabel: widget.tagLabel,
                ),
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
                if (widget.supportingText != null &&
                    widget.supportingText!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.supportingText!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Square artwork placeholder with gradient and play overlay on hover.
class _Artwork extends StatelessWidget {
  const _Artwork({
    required this.isHovered,
    required this.gradientColors,
    this.imageUrl,
    this.tagLabel,
  });

  final bool isHovered;
  final List<Color> gradientColors;
  final String? imageUrl;
  final String? tagLabel;

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
            // Image or gradient background
            if (imageUrl != null && imageUrl!.isNotEmpty)
              DecibelCachedImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: _buildGradientPlaceholder(),
                errorWidget: _buildGradientPlaceholder(),
              )
            else
              _buildGradientPlaceholder(),

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
            if (tagLabel != null && tagLabel!.trim().isNotEmpty)
              Positioned(
                left: AppDimensions.paddingSm,
                top: AppDimensions.paddingSm,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      tagLabel!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
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

  Widget _buildGradientPlaceholder() {
    return DecoratedBox(
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
    );
  }
}
