import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/track_engager.dart';
import '../../domain/models/track_action_data.dart';
import '../providers/track_social_provider.dart';
import 'social_action_button.dart';
import 'track_engagers_bottom_sheet.dart';

class RepostButton extends ConsumerWidget {
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

  void _handleTap(
    BuildContext context,
    WidgetRef ref,
    bool isCurrentlyReposted,
  ) {
    if (isCurrentlyReposted) {
      showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.buttonRadius * 2,
                ),
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
                  onPressed: () => ctx.pop(false),
                  child: const Text(
                    AppConstants.cancel,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () => ctx.pop(true),
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
              .read(trackSocialProvider(trackId).notifier)
              .toggleAction(SocialActionType.repost);
        }
      });
    } else {
      ref
          .read(trackSocialProvider(trackId).notifier)
          .toggleAction(SocialActionType.repost);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackSocial = ref.watch(trackSocialProvider(trackId));

    // Derive state components from AsyncValue
    final socialData = trackSocial.valueOrNull;

    // Use fetched data if available, otherwise fallback to initial props
    final isCurrentlyReposted = socialData?.isReposted ?? isReposted;
    final repostCount = socialData?.repostCount ?? this.repostCount;
    final isLoading = trackSocial.isLoading;

    return SocialActionButton(
      isActive: isCurrentlyReposted,
      count: repostCount,
      isLoading: isLoading,
      activeIcon: Icons.repeat,
      inactiveIcon: Icons.repeat,
      activeColor: AppColors.primary,
      onToggle: () => _handleTap(context, ref, isCurrentlyReposted),
      identifier: 'repost_button',
      onCountTap:
          () => showTrackEngagersSheet(
            context,
            trackId: trackId,
            type: EngagerType.reposters,
          ),
      iconSize: iconSize ?? AppConstants.iconSizeMedium,
      fontSize: fontSize ?? AppConstants.fontSizeRegular,
    );
  }
}
