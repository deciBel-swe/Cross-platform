import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = _isDesktopLayout(context);

    void goToProfile() {
      context.push(RoutePaths.profile);
    }

    void goToSettings() {
      context.push(RoutePaths.settings);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              title: const Text(
                'Library',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'GET PRO',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.cast)),
                IconButton(
                  onPressed: goToSettings,
                  icon: const Icon(Icons.settings_outlined),
                ),
                IconButton(
                  onPressed: goToProfile,
                  icon: const Icon(Icons.account_circle),
                ),
              ],
            ),
      body: const _LibraryTab(),
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

class _LibraryTab extends StatelessWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _NavigationRow(
          title: 'Your likes',
          onTap: () {}, // TODO: Implement Route
        ),
        _NavigationRow(
          title: 'Playlists',
          onTap: () {
            context.push(RoutePaths.playlists);
          },
        ),
        _NavigationRow(
          title: 'Albums',
          onTap: () {}, // TODO: Implement Route
        ),
        _NavigationRow(
          title: 'Following',
          onTap: () {}, // TODO: Implement Route
        ),
        _NavigationRow(
          title: 'Stations',
          onTap: () {}, // TODO: Implement Route
        ),
        _NavigationRow(
          title: 'Your insights',
          onTap: () {}, // TODO: Implement Route
        ),
        _NavigationRow(
          title: 'Following',
          onTap: () => context.go(RoutePaths.libraryFollowing),
        ),
        _NavigationRow(
          title: 'Your uploads',
          onTap: () => context.go(RoutePaths.uploadLibrary),
        ),
        _NavigationRow(
          title: 'Your likes',
          onTap: () => context.go(RoutePaths.libraryLikes),
        ),
        _NavigationRow(
          title: 'Your reposts',
          onTap: () => context.go(RoutePaths.libraryReposts),
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}