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
    return  Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Library'),
          actions: [IconButton(onPressed: goToProfile, icon: Icon(Icons.person))],
        ),
      ),
    );
  }
}
