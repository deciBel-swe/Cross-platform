import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Simple library screen with a logout action.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    final isAuthBusy = ref.watch(authStateProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(onPressed: goToProfile, icon: const Icon(Icons.person)),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: isAuthBusy
              ? null
              : () => ref.read(authStateProvider.notifier).logout(),
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
