import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/track.dart';
import '../notifiers/track_comment_notifier.dart';
import '../state/track_audio_state.dart';
import 'track_comment_input_bar.dart';
import 'track_comment_tile.dart';
import 'track_comments_context_tile.dart';
import 'track_comments_header.dart';

/// The main entry point for the comments bottom sheet overlay.
class TrackCommentsBottomSheet extends ConsumerWidget {
  const TrackCommentsBottomSheet({
    super.key,
    required this.trackId,
    required this.track,
  });

  final int trackId;
  final Track track;

  /// Helper method to display this bottom sheet from anywhere.
  static Future<void> show(
    BuildContext context, {
    required int trackId,
    required Track track,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TrackCommentsBottomSheet(trackId: trackId, track: track),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final commentsState = ref.watch(trackCommentsProvider(trackId));
    final audioState = ref.watch(trackAudioProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              TrackCommentsHeader(commentCount: commentsState.comments.length),
              const Divider(height: 1, color: Colors.white12),
              TrackCommentsContextTile(track: track),
              const Divider(height: 1, color: Colors.white12),
              Expanded(
                child: commentsState.comments.isEmpty
                    ? Center(
                        child: Text(
                          'Be the first to comment!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: commentsState.comments.length,
                        itemBuilder: (context, index) {
                          final comment = commentsState.comments[index];
                          return TrackCommentTile(
                            key: ValueKey(comment.commentid),
                            comment: comment,
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: CommentReactionBar(
                    onSendTap: (content) {
                      _postComment(ref, content, audioState);
                    },
                    onReactionTap: (emoji) {
                      _postComment(ref, emoji, audioState);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _postComment(WidgetRef ref, String content, TrackAudioState audioState) {
    final notifier = ref.read(trackCommentsProvider(trackId).notifier);
    final currentSeconds = (audioState.duration.inSeconds * audioState.progress)
        .round();

    notifier.selectTimestamp(currentSeconds);
    notifier.postComment(content);
  }
}
