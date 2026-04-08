import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/track_comment_notifier.dart';
import '../utils/mention_text_editing_controller.dart';
import 'comment_reaction_bar.dart';

class TrackPreviewInputSection extends ConsumerStatefulWidget {
  const TrackPreviewInputSection({super.key, required this.trackId});

  final int trackId;

  @override
  ConsumerState<TrackPreviewInputSection> createState() =>
      _TrackPreviewInputSectionState();
}

class _TrackPreviewInputSectionState
    extends ConsumerState<TrackPreviewInputSection> {
  final TextEditingController _commentController =
      MentionTextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (commentsState.activeReplyCommentId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Replying...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _commentController.clear();
                      notifier.clearReplyMode();
                      _focusNode.unfocus();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          CommentReactionBar(
            controller: _commentController,
            focusNode: _focusNode,
            onSendTap: (content) {
              notifier.handleSubmit(content);
              _commentController.clear();
              _focusNode.unfocus();
            },
            onReactionTap: (emoji) {
              notifier.handleSubmit(emoji);
              _commentController.clear();
              _focusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
