/// Desktop Home screen — SoundCloud-style with horizontal carousels.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

/// Empty Home page – placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Home'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () {
                    context.push(RoutePaths.upload);
                  },
                ),
              ],
            ),
      body: const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
      // TODO(dev): Remove this FAB after testing the follow feature.
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'test_follow',
        onPressed: () => _showTestUsersSheet(context),
        child: const Icon(Icons.person_search),
      ),
    );
  }

  /// Opens a bottom sheet with mock user links for testing PublicProfileScreen.
  void _showTestUsersSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Test Public Profiles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User 2 — Follow Back'),
              subtitle: const Text('Even ID → isFollowedBy = true'),
              onTap: () {
                Navigator.pop(context);
                context.push(RoutePaths.publicProfile(2));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('User 3 — Follow'),
              subtitle: const Text('Odd ID → isFollowedBy = false'),
              onTap: () {
                Navigator.pop(context);
                context.push(RoutePaths.publicProfile(3));
              },
            ),
          ],
        ),
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}
