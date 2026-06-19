import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../providers/playlist_social_provider.dart';
import 'social_action_button.dart';

class PlaylistLikeButton extends ConsumerWidget {
  const PlaylistLikeButton({
    super.key,
    required this.playlist,
    this.iconSize,
    this.fontSize,
    this.isVertical = false,
  });

  final Playlist playlist;
  final double? iconSize;
  final double? fontSize;
  final bool isVertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistSocial = ref.watch(playlistSocialProvider(playlist.id));

    final socialData = playlistSocial.valueOrNull;

    final isLiked = socialData?.isLiked ?? playlist.isLiked;
    final isLoading = playlistSocial.isLoading;

    return SocialActionButton(
      isActive: isLiked,
      count: null,
      isLoading: isLoading,
      activeIcon: Icons.favorite,
      inactiveIcon: Icons.favorite_border,
      activeColor: AppColors.primary,
      onToggle: () =>
          ref.read(playlistSocialProvider(playlist.id).notifier).toggleLike(),
      identifier: 'playlist_like_button',
      iconSize: iconSize ?? AppConstants.iconSizeMedium,
      fontSize: fontSize ?? AppConstants.fontSizeRegular,
      isVertical: isVertical,
    );
  }
}
