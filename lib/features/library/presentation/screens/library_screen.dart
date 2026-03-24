/// Desktop Library screen — tabbed view (Likes, Playlists, Albums, Following).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';

/// Simple library screen with a logout action.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    void goToSettings() {
      context.push(RoutePaths.settings);
    }

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Library'),
              actions: [
                IconButton(
                  onPressed: goToProfile,
                  icon: const Icon(Icons.person),
                ),
                IconButton(
                  onPressed: goToSettings,
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
      body: const _LibraryTab(),
    );
  }
}

class _LibraryTab extends StatelessWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _NavigationRow(
          title: 'Your uploads',
          onTap: () => context.go(RoutePaths.uploadLibrary),
        ),
      ],
    );
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
