import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onSharePressed,
    required this.onPlaylistAddPressed,
    required this.onMoreOptionsPressed,
  });

  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onPlaylistAddPressed;
  final VoidCallback onMoreOptionsPressed;

  @override
  Widget build(BuildContext context) {
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
                text: '$likeCount',
                onTap: onLikePressed,
                activeColor: isLiked ? Colors.red : Colors.white,
              ),
            ),
            Expanded(
              child: _buildTextIconButton(
                icon: Icons.chat_bubble_outline,
                text: '$commentCount',
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
                icon: Icons.playlist_play,
                onTap: onPlaylistAddPressed,
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
