import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/comment.dart';
import '../notifiers/track_comment_notifier.dart';
import 'comment_reply_item.dart';

class CommentRepliesSection extends ConsumerWidget {
  const CommentRepliesSection({
    super.key,
    required this.comment,
    required this.trackId,
  });
  final Comment comment;
  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trackCommentsProvider(trackId));

    final isExpanded = state.expandedCommentIds.contains(comment.commentid);
    final replies = state.repliesByCommentId[comment.commentid] ?? [];
    final isLoading = state.isLoadingReplies && isExpanded && replies.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isExpanded && comment.replycount > 0)
          _buildActionButton(
            onTap: () => ref
                .read(trackCommentsProvider(trackId).notifier)
                .loadReplies(comment.commentid),
            label: 'View ${comment.replycount} replies',
            showLine: true,
          ),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(left: 72, top: 12, bottom: 12),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey,
              ),
            ),
          ),

        if (isExpanded) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) =>
                CommentReplyItem(reply: replies[index]),
          ),

          _buildActionButton(
            onTap: () => ref
                .read(trackCommentsProvider(trackId).notifier)
                .collapseReplies(comment.commentid),
            label: 'Hide replies',
            showLine: false,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String label,
    required bool showLine,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 72, top: 8, bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (showLine) ...[
              Container(width: 20, height: 1, color: Colors.grey[700]),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
