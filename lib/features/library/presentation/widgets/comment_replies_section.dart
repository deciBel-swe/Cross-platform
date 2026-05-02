import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/comment.dart';
import '../providers/track_comment_provider.dart';
import 'comment_reply_item.dart';

class CommentRepliesSection extends ConsumerWidget {
  const CommentRepliesSection({
    super.key,
    required this.comment,
    required this.trackId,
  });

  final Comment comment;
  final int trackId;

  /// Builds the reply list and pagination controls for a comment.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(trackCommentsProvider(trackId));
    final notifier = ref.read(trackCommentsProvider(trackId).notifier);
    final isExpanded = notifier.isRepliesExpanded(comment);
    final paginatedData = notifier.paginatedRepliesFor(comment);
    final replies = notifier.repliesFor(comment);
    final isInitialLoading = notifier.isInitialRepliesLoading(comment);
    final isPaginating = notifier.isPaginatingReplies(comment);
    final hasRepliesToFetch = notifier.hasRepliesToFetch(comment);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isExpanded && hasRepliesToFetch)
          _buildActionButton(
            onTap: () => notifier.loadReplies(comment.commentid, page: 0),
            label: 'Show replies',
            showLine: true,
          ),

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

        if (isExpanded && replies.isNotEmpty) ...[
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) =>
                CommentReplyItem(reply: replies[index]),
          ),

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
                      final nextPage = notifier.nextRepliesPage(comment);
                      notifier.loadReplies(comment.commentid, page: nextPage);
                    },
                    label: 'Show more replies',
                    showLine: true,
                  ),

          _buildActionButton(
            onTap: () => notifier.collapseReplies(comment.commentid),
            label: 'Hide replies',
            showLine: false,
          ),
        ],
      ],
    );
  }

  /// Builds a reply section action row.
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
