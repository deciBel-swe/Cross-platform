import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

/// Empty Library page – placeholder.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    void goToSettings() {
      context.push(RoutePaths.settings);
    }

    //I removed the nested scaffold here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(onPressed: goToProfile, icon: const Icon(Icons.person)),
          IconButton(onPressed: goToSettings, icon: const Icon(Icons.settings)),
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
