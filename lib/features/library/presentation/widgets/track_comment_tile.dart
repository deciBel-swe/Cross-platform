import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/comment.dart';
import '../notifiers/track_comment_notifier.dart';
import 'comment_header.dart';
import 'comment_replies_section.dart';
import 'track_comment_avatar.dart';
import 'track_comment_formatters.dart';
import 'track_comment_options_sheet.dart';

class TrackCommentTile extends ConsumerWidget {
  const TrackCommentTile({
    super.key,
    required this.comment,
    required this.trackId,
  });

  final Comment comment;
  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider).value;

    final isOwner =
        authState is AuthAuthenticated && authState.user.id == comment.user.id;

    final timeFormatted = TrackCommentFormatters.formatTimeAgo(
      comment.createdAt,
    );
    final timestampSeconds = comment.timestampSeconds ?? 0;
    final timestampFormatted = TrackCommentFormatters.formatTimestamp(
      timestampSeconds,
    );
    const undoDuration = Duration(seconds: 4);

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
                      onTimestampTap: () {
                        ref
                            .read(trackAudioProvider.notifier)
                            .seek(Duration(seconds: timestampSeconds));
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(comment.body, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => ref
                              .read(trackCommentsProvider(trackId).notifier)
                              .setReplyingTo(comment),
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
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(context);

                              final shouldDelete =
                                  await showTrackCommentOptionsSheet(
                                    context,
                                    theme,
                                  );

                              if (shouldDelete == true) {
                                await Future<void>.delayed(
                                  const Duration(milliseconds: 250),
                                );

                                if (!context.mounted) return;

                                final notifier = ref.read(
                                  trackCommentsProvider(trackId).notifier,
                                );
                                final deletedComment = comment;

                                notifier.requestDeletion(
                                  deletedComment,
                                  undoDuration,
                                );

                                messenger.clearSnackBars();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Comment deleted',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    behavior: SnackBarBehavior.floating,
                                    duration: undoDuration,
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                      left: 16,
                                      right: 16,
                                    ),
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
                                await Future<void>.delayed(undoDuration);
                                messenger.clearSnackBars();
                              }
                            },
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
            ],
          ),
          CommentRepliesSection(comment: comment, trackId: trackId),
        ],
      ),
    );
  }
}
