/// GoRouter configuration – all app routes defined here.
library;

import 'package:go_router/go_router.dart';

import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/upgrade/presentation/screens/upgrade_screen.dart';
import 'main_shell.dart';
import 'route_paths.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        // 0 – Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        // 1 – Feed
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.feed,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FeedScreen()),
            ),
          ],
        ),
        // 2 – Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.search,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SearchScreen()),
            ),
          ],
        ),
        // 3 – Library
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.library,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LibraryScreen()),
            ),
          ],
        ),
        // 4 – Upgrade
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.upgrade,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UpgradeScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
