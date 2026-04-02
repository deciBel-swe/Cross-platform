import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/comment.dart';
import '../providers/track_comment_provider.dart';

class ActiveCommentsOverlay extends ConsumerWidget {
  const ActiveCommentsOverlay({super.key, required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get current active comments for the exact second
    final activeComments = ref.watch(currentActiveCommentsProvider(trackId));

    if (activeComments.isEmpty) {
      return const SizedBox.shrink();
    }

    // 2. Only take the first comment to avoid vertical stacking
    final commentToDisplay = activeComments.first;

    return _buildSingleCommentBubble(context, commentToDisplay);
  }

  Widget _buildSingleCommentBubble(BuildContext context, Comment comment) {
    return TweenAnimationBuilder<double>(
      // Key ensures the animation runs again if the comment changes within the same second
      key: ValueKey(comment.commentid),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)), // Slight upward floating effect
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            backgroundImage:
                comment.user.avatarUrl != null &&
                    comment.user.avatarUrl!.isNotEmpty
                ? NetworkImage(comment.user.avatarUrl!)
                : null,
            child:
                (comment.user.avatarUrl == null ||
                    comment.user.avatarUrl!.isEmpty)
                ? const Icon(Icons.person, size: 18, color: Colors.white54)
                : null,
          ),

          const SizedBox(width: 8),

          // Comment/Reaction Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(
                0xFF181818,
              ), // Dark background matching the image
              borderRadius: BorderRadius.circular(14), // Highly rounded corners
            ),
            child: Text(
              comment.body,
              style: const TextStyle(
                color: Colors.white,
                fontSize:
                    16, // Larger font size to make emojis pop like the screenshot
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
