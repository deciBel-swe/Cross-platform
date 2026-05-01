import 'package:flutter/material.dart';
import '../notifiers/track_comment_notifier.dart';
import '../utils/mention_text_editing_controller.dart';
import 'comment_reaction_bar.dart';

class TrackCommentsInputArea extends StatelessWidget {
  const TrackCommentsInputArea({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.notifier,
    required this.staticFormattedTime,
    this.isReplying = false,
  });

  final MentionTextEditingController controller;
  final FocusNode focusNode;
  final TrackCommentNotifier notifier;
  final String staticFormattedTime;
  final bool isReplying;

  /// Builds the comments input area and reply cancellation row.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          children: [
            if (isReplying)
              Row(
                children: [
                  const Text(
                    'Replying...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      notifier.clearReplyMode();
                      focusNode.unfocus();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            CommentReactionBar(
              controller: controller,
              focusNode: focusNode,
              timestamp: staticFormattedTime,
              onSendTap: (val) {
                notifier.handleSubmit(val);
                controller.clear();
                focusNode.unfocus();
              },
              onReactionTap: (val) {
                notifier.handleSubmit(val);
                controller.clear();
                focusNode.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
