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
    final paginatedData = state.repliesByCommentId[comment.commentid];
    final replies = paginatedData?.content ?? [];

    final isThisCommentLoading = state.loadingReplyIds.contains(
      comment.commentid,
    );

    final isInitialLoading =
        isThisCommentLoading && isExpanded && replies.isEmpty;
    final isPaginating =
        isThisCommentLoading && isExpanded && replies.isNotEmpty;

    final hasRepliesToFetch = comment.replycount > 0 || replies.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Initial State: Only show "Show replies" if not expanded and we expect data
        if (!isExpanded && hasRepliesToFetch)
          _buildActionButton(
            onTap: () => ref
                .read(trackCommentsProvider(trackId).notifier)
                .loadReplies(comment.commentid, page: 0),
            label: 'Show replies',
            showLine: true,
          ),

        // Loader during initial fetch
        if (isInitialLoading)
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

        // 2. Expanded State: Show the list ONLY if there is data
        if (isExpanded && replies.isNotEmpty) ...[
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) =>
                CommentReplyItem(reply: replies[index]),
          ),

          // Pagination: Show More if not the last page
          if (paginatedData != null && !(paginatedData.isLast ?? true))
            isPaginating
                ? const Padding(
                    padding: EdgeInsets.only(left: 72, top: 12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : _buildActionButton(
                    onTap: () {
                      final nextPage = (paginatedData.pageNumber ?? 0) + 1;
                      ref
                          .read(trackCommentsProvider(trackId).notifier)
                          .loadReplies(comment.commentid, page: nextPage);
                    },
                    label: 'Show more replies',
                    showLine: true,
                  ),

          // 3. Hide Button: Only appears if there is data actually shown
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
