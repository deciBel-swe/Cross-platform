import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/track_engager.dart';
import '../../domain/models/track_action_data.dart';
import '../notifiers/track_action_notifier.dart';
import 'social_action_button.dart';
import 'track_engagers_bottom_sheet.dart';

class LikeButton extends ConsumerStatefulWidget {
  const LikeButton({
    super.key,
    required this.trackId,
    required this.isLiked,
    required this.likeCount,
    this.iconSize,
    this.fontSize,
  });
  final int trackId;
  final bool isLiked;
  final int likeCount;
  final double? iconSize;
  final double? fontSize;

  @override
  ConsumerState<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackSocialProvider.notifier)
          .mergeTrack(
            widget.trackId,
            isLiked: widget.isLiked,
            likeCount: widget.likeCount,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(trackSocialProvider);
    final trackData = providerState.trackStates[widget.trackId.toString()];
    final isLoading = providerState.loadingKeys.contains(
      'like_${widget.trackId}',
    );

    return SocialActionButton(
      isActive: trackData?.isLiked ?? widget.isLiked,
      count: trackData?.likeCount ?? widget.likeCount,
      isLoading: isLoading,
      activeIcon: Icons.favorite,
      inactiveIcon: Icons.favorite_border,
      activeColor: AppColors.primary,
      onToggle: () => ref
          .read(trackSocialProvider.notifier)
          .toggleAction(widget.trackId, SocialActionType.like),
      onCountTap: () => showTrackEngagersSheet(
        context,
        trackId: widget.trackId,
        type: EngagerType.likers,
      ),
      iconSize: widget.iconSize ?? AppConstants.iconSizeMedium,
      fontSize: widget.fontSize ?? AppConstants.fontSizeRegular,
    );
  }
}
