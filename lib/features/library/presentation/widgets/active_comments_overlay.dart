import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/comment.dart';
import '../providers/track_comment_provider.dart';
import 'track_comment_avatar.dart';

class ActiveCommentsOverlay extends ConsumerWidget {
  const ActiveCommentsOverlay({super.key, required this.trackId});

  final int trackId;

  /// Builds the overlay for the currently active timed comment.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentToDisplay = ref.watch(currentActiveCommentProvider(trackId));

    if (commentToDisplay == null) {
      return const SizedBox.shrink();
    }

    return _buildSingleCommentBubble(context, commentToDisplay);
  }

  /// Builds an animated bubble for a single comment.
  Widget _buildSingleCommentBubble(BuildContext context, Comment comment) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(comment.commentid),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TrackCommentAvatar(avatarUrl: comment.user.avatarUrl),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              comment.body,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
