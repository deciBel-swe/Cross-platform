import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/comment.dart';
import '../notifiers/track_comment_notifier.dart';
import '../providers/track_comment_provider.dart';
import '../utils/track_comment_formatters.dart';
import 'comment_header.dart';
import 'comment_replies_section.dart';
import 'like_section.dart';
import 'track_comment_avatar.dart';
import 'track_comment_options_sheet.dart';

class TrackCommentTile extends ConsumerWidget {
  const TrackCommentTile({
    super.key,
    required this.comment,
    required this.trackId,
  });

  final Comment comment;
  final int trackId;

  /// Builds a single top-level timed comment row.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.watch(authStateProvider);
    final notifier = ref.read(trackCommentsProvider(trackId).notifier);
    final isOwner = notifier.canManageComment(comment);
    final timeFormatted = TrackCommentFormatters.formatTimeAgo(
      comment.createdAt,
    );
    final timestampSeconds = comment.timestampSeconds ?? 0;
    final timestampFormatted = TrackCommentFormatters.formatTimestamp(
      timestampSeconds,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackCommentAvatar(avatarUrl: comment.user.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommentHeader(
                      username: comment.user.username,
                      timestamp: timestampFormatted,
                      timeAgo: timeFormatted,
                      onTimestampTap: () => notifier.seekToComment(comment),
                    ),
                    const SizedBox(height: 6),
                    Text(comment.body, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => notifier.setReplyingTo(comment),
                          child: Text(
                            'Reply',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isOwner) ...[
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _handleDeleteTap(
                              context: context,
                              theme: theme,
                              notifier: notifier,
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const LikeSection(count: '0'),
            ],
          ),
          CommentRepliesSection(comment: comment, trackId: trackId),
        ],
      ),
    );
  }

  /// Handles delete confirmation and starts the undo window.
  Future<void> _handleDeleteTap({
    required BuildContext context,
    required ThemeData theme,
    required TrackCommentNotifier notifier,
  }) async {
    final shouldDelete = await showTrackCommentOptionsSheet(context, theme);

    if (shouldDelete != true) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) {
      return;
    }

    notifier.requestDeletion(comment, TrackCommentNotifier.deleteUndoDelay);
    await _showUndoSnackBar(
      context: context,
      theme: theme,
      notifier: notifier,
      deletedComment: comment,
    );
  }

  /// Shows the undo snackbar for an optimistically deleted comment.
  Future<void> _showUndoSnackBar({
    required BuildContext context,
    required ThemeData theme,
    required TrackCommentNotifier notifier,
    required Comment deletedComment,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text(
          'Comment deleted',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        duration: TrackCommentNotifier.deleteUndoDelay,
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            notifier.undoDeletion(deletedComment);
            messenger.clearSnackBars();
          },
        ),
      ),
    );
    await Future<void>.delayed(TrackCommentNotifier.deleteUndoDelay);
    messenger.clearSnackBars();
  }
}
