import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/right_side_panel.dart';
import '../../domain/entities/track.dart';
import '../providers/track_comment_provider.dart';
import '../utils/mention_text_editing_controller.dart';
import '../utils/track_comment_formatters.dart';
import 'track_comment_tile.dart';
import 'track_comments_context_tile.dart';
import 'track_comments_header.dart';
import 'track_comments_input_area.dart';

class TrackCommentsBottomSheet extends ConsumerStatefulWidget {
  const TrackCommentsBottomSheet({
    super.key,
    required this.trackId,
    required this.track,
    this.asSidePanel = false,
  });
  final int trackId;
  final Track track;
  final bool asSidePanel;

  /// Opens comments as a side panel on desktop and as a sheet elsewhere.
  static Future<void> show(
    BuildContext context, {
    required int trackId,
    required Track track,
  }) {
    if (isDesktopPanelLayout(context)) {
      return showRightSidePanel<void>(
        context: context,
        child: TrackCommentsBottomSheet(
          trackId: trackId,
          track: track,
          asSidePanel: true,
        ),
      );
    }

    return showModalBottomSheet<void>(
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

  /// Creates the state that owns the input controller.
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

  /// Captures the starting timestamp and wires input changes to the notifier.
  @override
  void initState() {
    super.initState();
    final notifier = ref.read(trackCommentsProvider(widget.trackId).notifier);
    _staticSeconds = notifier.currentPlaybackSecond();
    _staticFormattedTime = TrackCommentFormatters.formatTimestamp(
      _staticSeconds,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.selectTimestamp(_staticSeconds);
    });

    _commentController.addListener(() {
      notifier.clearReplyModeIfInputIsEmpty(_commentController.text);
    });
  }

  /// Disposes the comment input resources.
  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Builds the comments panel content.
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
        borderRadius: widget.asSidePanel
            ? const BorderRadius.horizontal(left: Radius.circular(18))
            : const BorderRadius.vertical(top: Radius.circular(24)),
        border: widget.asSidePanel
            ? const Border(left: BorderSide(color: Colors.white12, width: 0.5))
            : null,
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
