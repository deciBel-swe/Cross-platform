import 'package:flutter/material.dart';

/// Centered empty-state text for resource picker tabs.
class MessageResourceEmptyState extends StatelessWidget {
  const MessageResourceEmptyState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: const TextStyle(color: Colors.white54)),
    );
  }
}

/// Centered error-state text for resource picker tabs.
class MessageResourceErrorState extends StatelessWidget {
  const MessageResourceErrorState({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
