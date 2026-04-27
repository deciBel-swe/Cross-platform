import 'package:flutter/material.dart';

class InboxEmptyState extends StatelessWidget {
  const InboxEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Your inbox is empty',
      child: const Center(
        child: Text(
          'No messages yet.',
          style: TextStyle(color: Colors.white54, fontSize: 15),
        ),
      ),
    );
  }
}
