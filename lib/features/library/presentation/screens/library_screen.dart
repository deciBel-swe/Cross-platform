import 'package:flutter/material.dart';

/// Empty Library page – placeholder.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Library', style: TextStyle(fontSize: 24))),
    );
  }
}
