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
import '../../features/library_profile/presentation/screens/web_profiles.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/basic_settings_screen.dart';
import '../../features/settings/presentation/screens/change_app_icon_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/social_settings_screen.dart';
import '../../features/upgrade/presentation/screens/upgrade_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import 'go_router_refresh_stream.dart';
import 'main_shell.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshStream(ref);

  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStateAsync = ref.read(authStateProvider);

      debugPrint(
        '[AppRouter] redirect run! matchedLocation: ${state.matchedLocation}',
      );
      debugPrint('[AppRouter] authStateAsync: $authStateAsync');

      final isAuthRoute =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.splash;

      final authState = authStateAsync.valueOrNull;

      if (authState is AuthUnauthenticated) {
        debugPrint(
          '[AppRouter] -> Handling as AuthUnauthenticated. Redirecting to login? ${isAuthRoute ? "No" : "Yes"}',
        );
        return isAuthRoute ? null : RoutePaths.login;
      }

      if (authState is AuthAuthenticated) {
        debugPrint(
          '[AppRouter] -> Handling as AuthAuthenticated. Redirecting to home? ${isAuthRoute ? "Yes" : "No"}',
        );
        return isAuthRoute ? RoutePaths.home : null;
      }

      debugPrint(
        '[AppRouter] -> State is Loading or Error. Redirecting to splash? ${isAuthRoute ? "No (already auth route)" : "Yes"}',
      );

      return isAuthRoute ? null : RoutePaths.splash;
    },
    routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.feed,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FeedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SearchScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.library,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LibraryScreen()),
                routes: [
                  GoRoute(
                    path: 'uploads',
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
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'social-settings',
                        builder: (context, state) =>
                            const SocialSettingsScreen(),
                      ),
                      GoRoute(
                        path: 'basic-settings',
                        builder: (context, state) =>
                            const BasicSettingsScreen(),
                        routes: [
                          GoRoute(
                            path: 'change-app-icon',
                            builder: (context, state) =>
                                const ChangeAppIconScreen(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.upgrade,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UpgradeScreen()),
              ),
            ],
          ),
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
