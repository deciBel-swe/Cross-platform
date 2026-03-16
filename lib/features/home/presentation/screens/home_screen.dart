import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Empty Home page – placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () {
              context.push('/home/upload');
            },
          )
        ],
      ),
      body: const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}
