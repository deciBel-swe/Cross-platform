import 'package:flutter/material.dart';

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
