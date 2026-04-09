import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/track.dart';
import '../notifiers/track_comment_notifier.dart';
import '../utils/mention_text_editing_controller.dart';
import 'track_comment_tile.dart';
import 'track_comments_context_tile.dart';
import 'track_comments_header.dart';
import 'track_comments_input_area.dart';

class TrackCommentsBottomSheet extends ConsumerStatefulWidget {
  const TrackCommentsBottomSheet({
    super.key,
    required this.trackId,
    required this.track,
  });
  final int trackId;
  final Track track;

  static Future<void> show(
    BuildContext context, {
    required int trackId,
    required Track track,
  }) {
    return showModalBottomSheet(
      useSafeArea: true,
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

  final MentionTextEditingController _commentController =
      MentionTextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final audioState = ref.read(trackAudioProvider);
    _staticSeconds = (audioState.duration.inSeconds * audioState.progress)
        .round();
    final m = _staticSeconds ~/ 60;
    final s = _staticSeconds % 60;
    _staticFormattedTime = '$m:${s.toString().padLeft(2, '0')}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackCommentsProvider(widget.trackId).notifier)
          .selectTimestamp(_staticSeconds);
    });

    _commentController.addListener(() {
      if (_commentController.text.isEmpty) {
        final state = ref.read(trackCommentsProvider(widget.trackId));
        if (state.activeReplyCommentId != null) {
          ref
              .read(trackCommentsProvider(widget.trackId).notifier)
              .clearReplyMode();
        }
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commentsState = ref.watch(trackCommentsProvider(widget.trackId));
    final notifier = ref.read(trackCommentsProvider(widget.trackId).notifier);

    ref.listen(trackCommentsProvider(widget.trackId), (prev, next) {
      if (prev?.activeReplyCommentId != null &&
          next.activeReplyCommentId == null) {
        _commentController.clear();
      }

      if (next.replyPrefillText != null &&
          next.replyPrefillText != prev?.replyPrefillText) {
        _commentController.text = next.replyPrefillText!;
        _commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length),
        );
        _focusNode.requestFocus();
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          TrackCommentsHeader(
            trackId: widget.trackId,
            commentCount: commentsState.comments.length,
          ),
          const Divider(height: 1, color: Colors.white12),
          TrackCommentsContextTile(track: widget.track),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: commentsState.comments.length,
              itemBuilder: (context, index) => TrackCommentTile(
                key: ValueKey(commentsState.comments[index].commentid),
                comment: commentsState.comments[index],
                trackId: widget.trackId,
              ),
            ),
          ),
          TrackCommentsInputArea(
            controller: _commentController,
            focusNode: _focusNode,
            notifier: notifier,
            staticFormattedTime: _staticFormattedTime,
            isReplying: commentsState.activeReplyCommentId != null,
          ),
        ],
      ),
    );
  }
}
