/// GoRouter configuration – all app routes defined here.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/start_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/library/presentation/screens/profile_screen.dart';
import '../../features/library/presentation/screens/track_preview_screen.dart';
import '../../features/library/presentation/screens/uploads_library_screen.dart';
import '../../features/library/presentation/screens/web_profiles.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/upgrade/presentation/screens/upgrade_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import 'go_router_refresh_stream.dart';
import 'main_shell.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshStream(ref);

  return GoRouter(
    initialLocation: RoutePaths.trackPreview(1),
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStateAsync = ref.read(authStateProvider);

      debugPrint(
        '[AppRouter] redirect run! matchedLocation: \${state.matchedLocation}',
      );
      debugPrint('[AppRouter] authStateAsync: \$authStateAsync');

      final isAuthRoute =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.splash;

      // Extract the actual AuthState from the AsyncValue
      final authState = authStateAsync.valueOrNull;

      if (authState is AuthUnauthenticated) {
        debugPrint(
          '[AppRouter] -> Handling as AuthUnauthenticated. Redirecting to login? \${isAuthRoute ? "No" : "Yes"}',
        );
        // return isAuthRoute ? null : RoutePaths.login;
        return null;
      }

      if (authState is AuthAuthenticated) {
        debugPrint(
          '[AppRouter] -> Handling as AuthAuthenticated. Redirecting to home? \${isAuthRoute ? "Yes" : "No"}',
        );
        //return isAuthRoute ? RoutePaths.home : null;
        return null;
      }

      debugPrint(
        '[AppRouter] -> State is Loading or Error. Redirecting to splash? ${isAuthRoute ? "No (already auth route)" : "Yes"}',
      );
      // authState is null -> AsyncLoading or AsyncError.
      // Block protected routes until auth is definitively resolved.
      //return isAuthRoute ? null : RoutePaths.splash;
      return null;
    },
    routes: [
      // ---- Auth flow (outside the main shell) ----
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ---- Main app shell (bottom navigation) ----
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
              GoRoute(
                path: RoutePaths.upload,
                builder: (context, state) => const UploadScreen(),
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
                routes: [
                  GoRoute(
                    path: "uploads",
                    builder: (context, state) => const UploadsLibraryScreen(),
                  ),
                  GoRoute(
                    path: 'track-preview/:trackId',
                    redirect: (context, state) {
                      final raw = state.pathParameters['trackId'];
                      final parsed = int.tryParse(raw ?? '');
                      if (parsed == null) {
                        return RoutePaths.library;
                      }
                      return null;
                    },
                    builder: (context, state) {
                      final trackId = int.parse(
                        state.pathParameters['trackId']!,
                      );
                      return TrackPreviewScreen(trackId: trackId);
                    },
                  ),
                ],
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
          // 5-Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
                routes: [
                  GoRoute(
                    path: 'edit-web-link',
                    builder: (context, state) => const EditProfileLinkScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
