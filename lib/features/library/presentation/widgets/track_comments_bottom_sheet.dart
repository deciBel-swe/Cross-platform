import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/track.dart';
import '../notifiers/track_comment_notifier.dart';
import 'track_comment_input_bar.dart';
import 'track_comment_tile.dart';
import 'track_comments_context_tile.dart';
import 'track_comments_header.dart';

/// The main entry point for the comments bottom sheet overlay.
class TrackCommentsBottomSheet extends ConsumerStatefulWidget {
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
  ConsumerState<TrackCommentsBottomSheet> createState() =>
      _TrackCommentsBottomSheetState();
}

class _TrackCommentsBottomSheetState
    extends ConsumerState<TrackCommentsBottomSheet> {
  late final int _staticSeconds;
  late final String _staticFormattedTime;

  @override
  void initState() {
    super.initState();

    // 1. Capture the exact audio position ONCE when the sheet opens
    final audioState = ref.read(trackAudioProvider);

    if (audioState.duration != Duration.zero) {
      _staticSeconds = (audioState.duration.inSeconds * audioState.progress)
          .round();
    } else {
      _staticSeconds = 0;
    }

    // 2. Format it into mm:ss securely
    final m = _staticSeconds ~/ 60;
    final s = _staticSeconds % 60;
    _staticFormattedTime = '$m:${s.toString().padLeft(2, '0')}';

    // 3. Pre-select this timestamp in the Notifier so it's ready for the API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackCommentsProvider(widget.trackId).notifier)
          .selectTimestamp(_staticSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final commentsState = ref.watch(trackCommentsProvider(widget.trackId));

    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  TrackCommentsHeader(
                    trackId: widget.trackId,
                    commentCount: commentsState.comments.length,
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  TrackCommentsContextTile(track: widget.track),
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
                                trackId: widget.trackId,
                              );
                            },
                          ),
                  ),

                  // Input Bar Area
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: CommentReactionBar(
                        timestamp: _staticFormattedTime,
                        onSendTap: (content) {
                          ref
                              .read(
                                trackCommentsProvider(widget.trackId).notifier,
                              )
                              .postComment(content);
                        },
                        onReactionTap: (emoji) {
                          ref
                              .read(
                                trackCommentsProvider(widget.trackId).notifier,
                              )
                              .postComment(emoji);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
