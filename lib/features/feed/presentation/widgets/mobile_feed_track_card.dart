library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Reusable mobile feed track card matching the native-style post layout.
class MobileFeedTrackCard extends StatelessWidget {
  const MobileFeedTrackCard({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.likes,
    required this.comments,
    required this.gradientColors,
  });

  final String title;
  final String artist;
  final String duration;
  final String likes;
  final String comments;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.45),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      size: 96,
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppDimensions.paddingMd,
              right: AppDimensions.paddingMd,
              child: _MobileRightActions(likes: likes, comments: comments),
            ),
            Positioned(
              left: AppDimensions.paddingMd,
              right: AppDimensions.paddingMd,
              bottom: AppDimensions.paddingMd,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppColors.textPrimary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      duration,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
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

class _MobileRightActions extends StatelessWidget {
  const _MobileRightActions({required this.likes, required this.comments});

  final String likes;
  final String comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.volume_off_outlined, color: AppColors.textPrimary),
        const SizedBox(height: AppDimensions.paddingMd),
        const Icon(
          Icons.favorite_border,
          color: AppColors.textPrimary,
          size: 32,
        ),
        const SizedBox(height: AppDimensions.paddingXs),
        Text(
          likes,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        const Icon(
          Icons.mode_comment_outlined,
          color: AppColors.textPrimary,
          size: 32,
        ),
        const SizedBox(height: AppDimensions.paddingXs),
        Text(
          comments,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        const Icon(
          Icons.add_box_outlined,
          color: AppColors.textPrimary,
          size: 32,
        ),
        const SizedBox(height: AppDimensions.paddingXs),
        Text(
          'Add',
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
