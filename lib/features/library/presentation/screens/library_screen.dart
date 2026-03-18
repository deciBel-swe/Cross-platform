import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(onPressed: goToProfile, icon: const Icon(Icons.person)),
          TextButton(
            onPressed: () {
              context.push(RoutePaths.uploadLibrary);
            },
            child: const Text('Uploads'),
          ),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
