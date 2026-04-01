import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engagement/domain/models/track_action_data.dart';
import '../../../engagement/presentation/notifiers/track_action_notifier.dart';

class BottomBarWidget extends ConsumerWidget {
  const BottomBarWidget({
    super.key,
    required this.trackId,
    required this.initialLikeCount,
    required this.initialRepostCount,
    required this.commentCount,
    required this.onCommentPressed,
    required this.onSharePressed,
    required this.onMoreOptionsPressed,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final int commentCount;
  final VoidCallback onCommentPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onMoreOptionsPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackSocialState = ref.watch(trackSocialProvider);
    final socialData = trackSocialState.trackStates[trackId.toString()];

    final isLiked = socialData?.isLiked ?? false;
    final likeCount = socialData?.likeCount ?? initialLikeCount;

    final isReposted = socialData?.isReposted ?? false;
    final repostCount = socialData?.repostCount ?? initialRepostCount;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _buildTextIconButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                text: _formatCount(likeCount),
                onTap: () => ref.read(trackSocialProvider.notifier).toggleAction(
                  trackId, 
                  SocialActionType.like,
                  initialLikeCount: initialLikeCount,
                  initialRepostCount: initialRepostCount,
                  initialIsLiked: isLiked,
                  initialIsReposted: isReposted,
                ),
                activeColor: isLiked ? Colors.red : Colors.white,
              ),
            ),
            Expanded(
              child: _buildTextIconButton(
                icon: Icons.repeat,
                text: _formatCount(repostCount),
                onTap: () => ref.read(trackSocialProvider.notifier).toggleAction(
                  trackId, 
                  SocialActionType.repost,
                  initialLikeCount: initialLikeCount,
                  initialRepostCount: initialRepostCount,
                  initialIsLiked: isLiked,
                  initialIsReposted: isReposted,
                ),
                activeColor: isReposted ? const Color(0xFFFF5500) : Colors.white,
              ),
            ),
            Expanded(
              child: _buildTextIconButton(
                icon: Icons.chat_bubble_outline,
                text: _formatCount(commentCount),
                onTap: onCommentPressed,
                activeColor: Colors.white,
              ),
            ),
            Expanded(
              child: _buildSimpleIconButton(
                icon: Icons.share_outlined,
                onTap: onSharePressed,
              ),
            ),
            Expanded(
              child: _buildSimpleIconButton(
                icon: Icons.more_vert,
                onTap: onMoreOptionsPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  Widget _buildTextIconButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Center(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: activeColor),
              const SizedBox(width: 6.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Center(
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
        splashColor: Colors.black,
        highlightColor: Colors.black,
      ),
    );
  }
}
