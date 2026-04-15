import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/library_profile/presentation/providers/track_audio_provider.dart';
import '../../features/player/presentation/widgets/desktop_player_bar.dart';
import '../../features/player/presentation/widgets/mobile_mini_player.dart';
import '../theme/app_colors.dart';
import 'desktop_header.dart';
import 'desktop_sidebar.dart';
import 'route_paths.dart';

/// SoundCloud-style shell that wraps tabbed content.
///
/// - **Desktop (≥ 801 px):** sidebar + header + content + player bar.
/// - **Mobile (< 801 px):** content + bottom navigation bar.
class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    if (isDesktop) {
      return _DesktopShell(navigationShell: navigationShell);
    }

    return _MobileShell(navigationShell: navigationShell);
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop layout
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ---- Sidebar ----
          DesktopSidebar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),

          // ---- Vertical divider ----
          const VerticalDivider(
            width: 1,
            thickness: 0.5,
            color: AppColors.divider,
          ),

          // ---- Content area ----
          Expanded(
            child: Column(
              children: [
                const DesktopHeader(),
                Expanded(child: navigationShell),
                const DesktopPlayerBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile layout
// ─────────────────────────────────────────────────────────────────────────────

class _MobileShell extends ConsumerWidget {
  const _MobileShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final hideMiniPlayer =
        location == RoutePaths.editProfile ||
        location.startsWith(RoutePaths.settings) ||
        location == RoutePaths.upload ||
        location.startsWith(RoutePaths.uploadLibrary);
    final miniPlayerVisible = ref.watch(miniPlayerVisibleProvider);

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          if (!hideMiniPlayer)
            Positioned(
              left: 0,
              right: 0,
              bottom: 5,
              child: AnimatedSlide(
                offset: miniPlayerVisible
                    ? Offset.zero
                    : const Offset(0, 1.5), // slide below the screen
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: const MobileMiniPlayer(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.video_library_outlined,
                activeIcon: Icons.video_library,
                label: 'Feed',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: 'Search',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.library_books_outlined,
                activeIcon: Icons.library_books,
                label: 'Library',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _UpgradeNavItem(
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Standard nav item with Material icon.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : Colors.white54;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

/// Upgrade nav item – uses the app icon instead of a Material icon.
class _UpgradeNavItem extends StatelessWidget {
  const _UpgradeNavItem({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : Colors.white54;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.45,
              child: Image.asset(
                'assets/icon/white_app_icon_trans.png',
                width: 24,
                height: 24,
                color: color,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            Text('Upgrade', style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
