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

  final int trackId;
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
          .mergeTrack(
            widget.trackId,
            isReposted: widget.isReposted,
            repostCount: widget.repostCount,
          );
    });
  }

  void _handleTap(BuildContext context, bool isCurrentlyReposted) {
    if (isCurrentlyReposted) {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius * 2),
          ),
          title: const Text(
            AppConstants.repostRemoveTitle,
            style: TextStyle(color: AppColors.onPrimary),
          ),
          content: const Text(
            AppConstants.repostRemoveMessage,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                AppConstants.cancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                AppConstants.remove,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true) {
          ref
              .read(trackSocialProvider.notifier)
              .toggleAction(widget.trackId, SocialActionType.repost);
        }
      });
    } else {
      ref
          .read(trackSocialProvider.notifier)
          .toggleAction(widget.trackId, SocialActionType.repost);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(trackSocialProvider);
    final trackData = providerState.trackStates[widget.trackId.toString()];
    final isCurrentlyReposted = trackData?.isReposted ?? widget.isReposted;
    final isLoading = providerState.loadingKeys.contains(
      'repost_${widget.trackId}',
    );

    return SocialActionButton(
      isActive: isCurrentlyReposted,
      count: trackData?.repostCount ?? widget.repostCount,
      isLoading: isLoading,
      activeIcon: Icons.repeat,
      inactiveIcon: Icons.repeat,
      activeColor: AppColors.primary,
      onToggle: () => _handleTap(context, isCurrentlyReposted),
      iconSize: widget.iconSize ?? AppConstants.iconSizeMedium,
      fontSize: widget.fontSize ?? AppConstants.fontSizeRegular,
    );
  }
}
