import 'package:flutter/material.dart';

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
