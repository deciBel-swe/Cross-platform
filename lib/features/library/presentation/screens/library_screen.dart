import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';


/// Simple library screen with a logout action.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    void goToSettings() {
      context.push(RoutePaths.settings);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(onPressed: goToProfile, icon: const Icon(Icons.person)),
          IconButton(onPressed: goToSettings, icon: const Icon(Icons.settings)),
        ],
      ),
      body: const Center(
        child: Text('Library Content'),
      ),
    );
  }
}
