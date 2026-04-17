import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/number_formatter.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';

class BottomBarWidget extends ConsumerWidget {
  const BottomBarWidget({
    super.key,
    required this.trackId,
    required this.initialLikeCount,
    required this.initialRepostCount,
    required this.isLiked,
    required this.isReposted,
    required this.commentCount,
    required this.onCommentPressed,
    required this.onSharePressed,
    required this.onAddToPlaylistPressed,
    required this.onMoreOptionsPressed,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final bool isLiked;
  final bool isReposted;
  final int commentCount;
  final VoidCallback onCommentPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onAddToPlaylistPressed; // 2. Add this
  final VoidCallback onMoreOptionsPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
            child: LikeButton(
              trackId: trackId,
              isLiked: isLiked,
              likeCount: initialLikeCount,
            ),
          ),
          Expanded(
            child: RepostButton(
              trackId: trackId,
              isReposted: isReposted,
              repostCount: initialRepostCount,
            ),
          ),
          Expanded(
            child: _buildTextIconButton(
              icon: Icons.chat_bubble_outline,
              text: NumberFormatter.formatCompact(commentCount),
              onTap: onCommentPressed,
              activeColor: Colors.white,
            ),
          ),
          Expanded(
            child: _buildSimpleIconButton(
              icon: Icons.playlist_add_outlined,
              onTap: onAddToPlaylistPressed,
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
    );
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
              Icon(icon, size: 20, color: activeColor),
              const SizedBox(width: 6.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
        icon: Icon(icon, size: 20, color: Colors.white),
        iconSize: 20,
        onPressed: onTap,
        splashColor: Colors.black,
        highlightColor: Colors.black,
      ),
    );
  }
}
