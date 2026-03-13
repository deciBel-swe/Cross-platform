/// Individual feed entry — user action + inline track card.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single entry in the activity feed.
class FeedItem extends StatefulWidget {
  const FeedItem({
    super.key,
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    this.gradientColors,
  });

  final String userName;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final List<Color>? gradientColors;

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [AppColors.surfaceLight, AppColors.surfaceContainer];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- User info row ----
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.first,
                  child: Text(
                    widget.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.userName,
                          style: AppTextStyles.cardTitle,
                        ),
                        TextSpan(
                          text: ' ${widget.action}',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(widget.timeAgo, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSm),

            // ---- Inline track ----
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  // Mini artwork
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white38,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingSm),
                  // Track info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trackTitle,
                          style: AppTextStyles.cardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.trackArtist,
                          style: AppTextStyles.cardSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Waveform placeholder
                  SizedBox(
                    width: 120,
                    height: 32,
                    child: CustomPaint(painter: _WaveformPainter()),
                  ),
                  const SizedBox(width: AppDimensions.paddingSm),
                  // Play button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fake waveform painter for visual placeholder.
class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textTertiary
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const barCount = 20;
    final barWidth = size.width / barCount;
    for (var i = 0; i < barCount; i++) {
      final height = (size.height * 0.3) +
          (size.height * 0.7 * _pseudoRandom(i));
      final x = i * barWidth + barWidth / 2;
      final top = (size.height - height) / 2;
      canvas.drawLine(Offset(x, top), Offset(x, top + height), paint);
    }
  }

  double _pseudoRandom(int i) {
    // Simple deterministic pseudo-random for consistent look.
    return ((i * 7 + 3) % 11) / 11;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
