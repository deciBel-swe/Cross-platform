import 'package:flutter/material.dart';

/// Empty Feed page – placeholder.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Feed', style: TextStyle(fontSize: 24))),
    );
  }
}
