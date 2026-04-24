import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/track_engager.dart';
import '../../domain/models/track_action_data.dart';
import '../providers/track_social_provider.dart';
import 'social_action_button.dart';
import 'track_engagers_bottom_sheet.dart';

class LikeButton extends ConsumerWidget {
  const LikeButton({
    super.key,
    required this.trackId,
    required this.isLiked,
    required this.likeCount,
    this.iconSize,
    this.fontSize,
    this.isVertical = false,
  });

  final int trackId;
  final bool isLiked;
  final int likeCount;
  final double? iconSize;
  final double? fontSize;
  final bool isVertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackSocial = ref.watch(trackSocialProvider(trackId));

    // Derive state components from AsyncValue
    final socialData = trackSocial.valueOrNull;

    // Use fetched data if available, otherwise fallback to initial props
    final isLiked = socialData?.isLiked ?? this.isLiked;
    final likeCount = socialData?.likeCount ?? this.likeCount;
    final isLoading = trackSocial.isLoading;

    return SocialActionButton(
      isActive: isLiked,
      count: likeCount,
      isLoading: isLoading,
      activeIcon: Icons.favorite,
      inactiveIcon: Icons.favorite_border,
      activeColor: AppColors.primary,
      onToggle: () => ref
          .read(trackSocialProvider(trackId).notifier)
          .toggleAction(SocialActionType.like),
      identifier: 'like_button',
      onCountTap: () => showTrackEngagersSheet(
        context,
        trackId: trackId,
        type: EngagerType.likers,
      ),
      iconSize: iconSize ?? AppConstants.iconSizeMedium,
      fontSize: fontSize ?? AppConstants.fontSizeRegular,
      isVertical: isVertical,
    );
  }
}
