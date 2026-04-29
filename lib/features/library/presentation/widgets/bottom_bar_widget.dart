import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final VoidCallback onAddToPlaylistPressed;
  final ValueChanged<BuildContext> onMoreOptionsPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
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
              text: _formatCount(commentCount),
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
            child: Builder(
              builder: (buttonContext) {
                return _buildSimpleIconButton(
                  icon: Icons.more_vert,
                  onTap: () => onMoreOptionsPressed(buttonContext),
                );
              },
            ),
          ),
        ],
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
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: activeColor),
              const SizedBox(width: 4.0),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onTap,
        splashColor: Colors.black,
        highlightColor: Colors.black,
      ),
    );
  }
}
