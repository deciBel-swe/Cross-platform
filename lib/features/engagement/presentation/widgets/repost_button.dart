import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/track_action_data.dart';
import '../notifiers/track_action_notifier.dart';
import 'social_action_button.dart';

class RepostButton extends ConsumerStatefulWidget {
  const RepostButton({
    super.key,
    required this.trackId,
    required this.isReposted,
    required this.repostCount,
    this.iconSize,
    this.fontSize,
  });

  final String trackId;
  final bool isReposted;
  final int repostCount;
  final double? iconSize;
  final double? fontSize;

  @override
  ConsumerState<RepostButton> createState() => _RepostButtonState();
}

class _RepostButtonState extends ConsumerState<RepostButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackSocialProvider.notifier)
          .initializeTrack(
            widget.trackId,
            TrackSocialData(
              isLiked: false,
              likeCount: 0,
              isReposted: widget.isReposted,
              repostCount: widget.repostCount,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(trackSocialProvider);
    final trackData = providerState.trackStates[widget.trackId];
    final isLoading = providerState.loadingKeys.contains(
      'repost_${widget.trackId}',
    );

    return SocialActionButton(
      isActive: trackData?.isReposted ?? widget.isReposted,
      count: trackData?.repostCount ?? widget.repostCount,
      isLoading: isLoading,
      activeIcon: Icons.repeat,
      inactiveIcon: Icons.repeat,
      activeColor: AppColors.primary,
      onToggle: () => ref
          .read(trackSocialProvider.notifier)
          .toggleAction(widget.trackId, SocialActionType.repost),
      iconSize: widget.iconSize ?? AppConstants.iconSizeMedium,
      fontSize: widget.fontSize ?? AppConstants.fontSizeRegular,
    );
  }
}
