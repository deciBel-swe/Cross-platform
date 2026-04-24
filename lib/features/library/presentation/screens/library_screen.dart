import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/domain/entities/user_profile.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';

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
              scrolledUnderElevation: 0,
              title:  Semantics(
                header: true,
                child: const Text(
                  'Library',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                const GetProButton(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cast),
                  tooltip: 'Cast to device',
                ),
                IconButton(
                  onPressed: goToSettings,
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Settings',
                ),
                IconButton(
                  onPressed: goToProfile,
                  icon: const Icon(Icons.account_circle),
                  tooltip: 'Profile',
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

class _LibraryTab extends ConsumerWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final userProfile = profileAsync.valueOrNull?.fold(
      (_) => null,
      (profile) => profile,
    );
    final isPro =
        userProfile?.tier == UserTier.pro ||
        userProfile?.tier == UserTier.artistPro;

    // final isPro=true;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _NavigationRow(
          title: 'Playlists',
          onTap: () {
            context.push(RoutePaths.playlists);
          },
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
          title: 'Downloads',
          onTap: () => context.go(RoutePaths.libraryDownloads),
          enabled: isPro,
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
  const _NavigationRow({
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled ? AppColors.textPrimary : AppColors.textHint;

    return Semantics(
      button: true,
      enabled: enabled,
      label: title,
      hint: enabled ? 'Navigate to $title' : 'Pro feature only, unavailable.',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: enabled
              ? onTap
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature is for Pro users only.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!enabled)
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
