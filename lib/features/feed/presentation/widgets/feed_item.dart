/// Individual feed entry — user action + rich inline track post.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../library_profile/presentation/widgets/waveform_painter.dart';

/// A single mocked entry in the activity feed.
class FeedItem extends StatelessWidget {
  const FeedItem({
    super.key,
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.genre,
    required this.likes,
    required this.reposts,
    required this.plays,
    required this.comments,
    required this.duration,
    required this.waveformPeaks,
    this.gradientColors,
  });

  final String userName;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final String genre;
  final String likes;
  final String reposts;
  final String plays;
  final String comments;
  final String duration;
  final List<double> waveformPeaks;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        const [AppColors.surfaceLight, AppColors.surfaceContainer];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(colors: colors, userName: userName),
              const SizedBox(width: AppDimensions.paddingSm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: userName, style: AppTextStyles.cardTitle),
                      TextSpan(
                        text: ' $action $timeAgo',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ArtworkTile(colors: colors, title: trackTitle),
              const SizedBox(width: AppDimensions.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const _PlayButton(),
                        const SizedBox(width: AppDimensions.paddingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trackArtist,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                trackTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontSize: 33,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _GenreChip(genre: genre),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingMd),
                    _WaveformStrip(peaks: waveformPeaks, duration: duration),
                    const SizedBox(height: AppDimensions.paddingMd),
                    Row(
                      children: [
                        _MetricPill(
                          icon: Icons.favorite,
                          value: likes,
                          iconColor: AppColors.textPrimary,
                        ),
                        const SizedBox(width: AppDimensions.paddingSm),
                        _MetricPill(
                          icon: Icons.repeat,
                          value: reposts,
                          iconColor: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.paddingSm),
                        const _IconSquareButton(icon: Icons.ios_share_outlined),
                        const SizedBox(width: AppDimensions.paddingSm),
                        const _IconSquareButton(
                          icon: Icons.content_copy_outlined,
                        ),
                        const SizedBox(width: AppDimensions.paddingSm),
                        const _IconSquareButton(icon: Icons.more_horiz),
                        const Spacer(),
                        Icon(
                          Icons.play_arrow,
                          size: 14,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: AppDimensions.paddingXs),
                        Text(
                          plays,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingMd),
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 14,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: AppDimensions.paddingXs),
                        Text(
                          comments,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.colors, required this.userName});

  final List<Color> colors;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
      ),
      child: Center(
        child: Text(
          userName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ArtworkTile extends StatelessWidget {
  const _ArtworkTile({required this.colors, required this.title});

  final List<Color> colors;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162,
      height: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          title.substring(0, title.length > 1 ? 2 : 1).toUpperCase(),
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant,
      ),
      child: const Icon(
        Icons.play_arrow,
        color: AppColors.textSecondary,
        size: 34,
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.genre});

  final String genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSm,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '#$genre',
        style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _WaveformStrip extends StatelessWidget {
  const _WaveformStrip({required this.peaks, required this.duration});

  final List<double> peaks;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WaveformPainter(
                peaks: peaks,
                progress: 0,
                playedColor: AppColors.primary,
                dragColor: AppColors.borderLight,
                unplayedColor: AppColors.surfaceVariant,
                centerLineColor: AppColors.borderDark,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: Text(
              duration,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: AppDimensions.paddingSm),
          Text(value, style: AppTextStyles.cardTitle),
        ],
      ),
    );
  }
}

class _IconSquareButton extends StatelessWidget {
  const _IconSquareButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 18),
    );
  }
}
