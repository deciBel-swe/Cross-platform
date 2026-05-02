import 'package:flutter/material.dart';

/// Small timestamp label rendered below a chat bubble.
///
/// Semantics are excluded because [MessageBubble] includes the time in its
/// full accessibility label.
class MessageBubbleTimestamp extends StatelessWidget {
  const MessageBubbleTimestamp({super.key, required this.timeString});

  final String timeString;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        timeString,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}
