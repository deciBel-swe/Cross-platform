library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';

/// Reusable mobile feed track card matching the native-style post layout.
class MobileFeedTrackCard extends StatelessWidget {
  const MobileFeedTrackCard({
    super.key,
    required this.trackId,
    required this.title,
    required this.artist,
    required this.duration,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.commentCount,
    required this.gradientColors,
  });

  final int trackId;
  final String title;
  final String artist;
  final String duration;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final int commentCount;
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
              child: _MobileRightActions(
                trackId: trackId,
                initialLikeCount: likeCount,
                initialRepostCount: repostCount,
                initialIsLiked: isLiked,
                initialIsReposted: isReposted,
                commentCount: commentCount,
              ),
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

class _MobileRightActions extends ConsumerWidget {
  const _MobileRightActions({
    required this.trackId,
    required this.initialLikeCount,
    required this.initialRepostCount,
    required this.initialIsLiked,
    required this.initialIsReposted,
    required this.commentCount,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final bool initialIsLiked;
  final bool initialIsReposted;
  final int commentCount;

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Icon(Icons.volume_off_outlined, color: AppColors.textPrimary),
        const SizedBox(height: AppDimensions.paddingMd),

        LikeButton(
          trackId: trackId,
          isLiked: initialIsLiked,
          likeCount: initialLikeCount,
          iconSize: 32,
          fontSize: 14,
        ),

        const SizedBox(height: AppDimensions.paddingMd),

        RepostButton(
          trackId: trackId,
          isReposted: initialIsReposted,
          repostCount: initialRepostCount,
          iconSize: 32,
          fontSize: 14,
        ),

        const SizedBox(height: AppDimensions.paddingMd),

        // COMMENT BUTTON
        GestureDetector(
          onTap: () {
            // Future feature: Open comments bottom sheet
          },
          child: Column(
            children: [
              const Icon(
                Icons.mode_comment_outlined,
                color: AppColors.textPrimary,
                size: 32,
              ),
              const SizedBox(height: AppDimensions.paddingXs),
              Text(
                _formatCount(commentCount),
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
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
