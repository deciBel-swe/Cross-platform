/// GoRouter configuration – all app routes defined here.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/resend_verification_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/start_screen.dart';
import '../../features/engagement/presentation/providers/follow_connections_provider.dart';
import '../../features/engagement/presentation/screens/follow_connections_screen.dart';
import '../../features/engagement/presentation/screens/liked_tracks_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/home/domain/entities/station_playlist.dart';
import '../../features/home/presentation/screens/home_collection_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/station_playlist_screen.dart';
import '../../features/library/domain/entities/track.dart';
import '../../features/library/presentation/screens/add_to_playlist_screen.dart';
import '../../features/library/presentation/screens/downloads_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/library/presentation/screens/track_edit_screen.dart';
import '../../features/library/presentation/screens/track_preview_screen.dart';
import '../../features/library/presentation/screens/uploads_library_screen.dart';
import '../../features/library_profile/presentation/providers/track_repository_provider.dart';
import '../../features/library_profile/presentation/screens/edit_profile_screen.dart';
import '../../features/library_profile/presentation/screens/fullscreen_image_screen.dart';
import '../../features/library_profile/presentation/screens/profile_screen.dart';
import '../../features/library_profile/presentation/screens/public_profile_screen.dart';
import '../../features/library_profile/presentation/screens/web_profiles.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/playlists/domain/entities/playlist.dart';
import '../../features/playlists/presentation/screens/edit_playlist_screen.dart';
import '../../features/playlists/presentation/screens/playlist_details_screen.dart';
import '../../features/playlists/presentation/screens/playlists_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/basic_settings_screen.dart';
import '../../features/settings/presentation/screens/blocked_users_screen.dart';
import '../../features/settings/presentation/screens/change_app_icon_screen.dart';
import '../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/social_settings_screen.dart';
import '../../features/upgrade/presentation/screens/upgrade_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../theme/app_colors.dart';
import 'go_router_refresh_stream.dart';
import 'main_shell.dart';
import 'route_paths.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshStream(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStateAsync = ref.read(authStateProvider);

      debugPrint(
        '[AppRouter] redirect run! matchedLocation: ${state.matchedLocation}',
      );
      debugPrint('[AppRouter] authStateAsync: $authStateAsync');

      final bool isAuthRoute =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.resendVerification ||
          state.matchedLocation == RoutePaths.start ||
          state.matchedLocation == RoutePaths.forgotPassword ||
          state.matchedLocation == RoutePaths.resetPassword ||
          state.matchedLocation == RoutePaths.splash;

      final authState = authStateAsync.valueOrNull;

      if (authState is AuthUnauthenticated) {
        debugPrint('[AppRouter] -> Handling as AuthUnauthenticated.');
        return isAuthRoute && state.matchedLocation != RoutePaths.splash
            ? null
            : RoutePaths.start;
      }

      if (authState is AuthAuthenticated) {
        debugPrint('[AppRouter] -> Handling as AuthAuthenticated.');
        return isAuthRoute ? RoutePaths.home : null;
      }

      if (authStateAsync.hasError) {
        debugPrint(
          '[AppRouter] -> Error detected: ${authStateAsync.error}\nStackTrace: ${authStateAsync.stackTrace}',
        );
        return isAuthRoute && state.matchedLocation != RoutePaths.splash
            ? null
            : RoutePaths.start;
      }

      debugPrint(
        '[AppRouter] -> State is Loading. Holding current auth route.',
      );
      if (isAuthRoute) {
        return null;
      }
      return state.matchedLocation == RoutePaths.splash
          ? null
          : RoutePaths.splash;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.start,
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
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: RoutePaths.resendVerification,
        builder: (context, state) => const ResendVerificationScreen(),
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
              GoRoute(
                path: RoutePaths.homePopularCollection,
                builder: (context, state) => const HomeCollectionScreen(
                  kind: HomeCollectionKind.popular,
                ),
              ),
              GoRoute(
                path: RoutePaths.homeLikesStation,
                builder: (context, state) => const StationPlaylistScreen(
                  kind: StationPlaylistKind.likes,
                ),
              ),
              GoRoute(
                path: RoutePaths.homeArtistStation,
                builder: (context, state) => const StationPlaylistScreen(
                  kind: StationPlaylistKind.artist,
                ),
              ),
              GoRoute(
                path: RoutePaths.homeGenreStation,
                builder: (context, state) => const StationPlaylistScreen(
                  kind: StationPlaylistKind.genre,
                ),
              ),
              GoRoute(
                path: RoutePaths.homeLikes,
                builder: (context, state) => const LikedTracksScreen(),
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
                    path: 'add-to-playlist',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final track = state.extra as Track;
                      return AddToPlaylistScreen(
                        key: UniqueKey(),
                        track: track,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'playlists',
                    builder: (context, state) => const PlaylistsScreen(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final playlist = state.extra as Playlist;
                          return EditPlaylistScreen(playlist: playlist);
                        },
                      ),
                      GoRoute(
                        path: 'playlist-tracks',
                        builder: (context, state) {
                          final playlist = state.extra as Playlist;
                          return PlaylistDetailsScreen(
                            playlistSummary: playlist,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'following',
                    builder: (context, state) {
                      final authState = ref.read(authStateProvider).valueOrNull;
                      final userId = authState is AuthAuthenticated
                          ? authState.user.id
                          : 0;
                      return FollowConnectionsScreen(
                        userId: userId,
                        type: FollowConnectionsType.following,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'uploads',
                    builder: (context, state) => const UploadsLibraryScreen(),
                  ),
                  GoRoute(
                    path: 'downloads',
                    builder: (context, state) => const DownloadsScreen(),
                  ),
                  GoRoute(
                    path: 'likes',
                    builder: (context, state) => const LikedTracksScreen(),
                  ),
                  GoRoute(
                    path: 'reposts',
                    builder: (context, state) => const RepostedTracksScreen(),
                  ),
                  GoRoute(
                    path: 'track-preview/:trackId',
                    parentNavigatorKey: _rootNavigatorKey,
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
                    path: 'track-edit/:trackId',
                    parentNavigatorKey: _rootNavigatorKey,
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
                      return TrackEditScreen(trackId: trackId);
                    },
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'notifications',
                        builder: (context, state) =>
                            const NotificationSettingsScreen(),
                      ),
                      GoRoute(
                        path: 'social-settings',
                        builder: (context, state) =>
                            const SocialSettingsScreen(),
                        routes: [
                          GoRoute(
                            path: 'blocked',
                            builder: (context, state) =>
                                const BlockedUsersScreen(),
                          ),
                        ],
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
                    path: 'followers',
                    redirect: (context, state) {
                      if (state.extra is! int) {
                        return RoutePaths.profile;
                      }
                      return null;
                    },
                    builder: (context, state) => FollowConnectionsScreen(
                      userId: state.extra! as int,
                      type: FollowConnectionsType.followers,
                    ),
                  ),
                  GoRoute(
                    path: 'following',
                    redirect: (context, state) {
                      if (state.extra is! int) {
                        return RoutePaths.profile;
                      }
                      return null;
                    },
                    builder: (context, state) => FollowConnectionsScreen(
                      userId: state.extra! as int,
                      type: FollowConnectionsType.following,
                    ),
                  ),
                  GoRoute(
                    path: 'edit-web-link',
                    builder: (context, state) => const EditProfileLinkScreen(),
                  ),
                  GoRoute(
                    path: 'edit-profile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: '${RoutePaths.publicProfileBase}/:userIdentifier',
                redirect: (context, state) {
                  final userIdentifier = state.pathParameters['userIdentifier']
                      ?.trim();
                  if (userIdentifier == null || userIdentifier.isEmpty) {
                    return RoutePaths.home;
                  }
                  return null;
                },
                builder: (context, state) {
                  final userIdentifier =
                      state.pathParameters['userIdentifier']!;
                  return PublicProfileScreen(userIdentifier: userIdentifier);
                },
                routes: [
                  GoRoute(
                    path: 'followers',
                    redirect: (context, state) {
                      final raw = state.pathParameters['userIdentifier'];
                      final userId = int.tryParse(raw ?? '');
                      if (userId == null) {
                        return RoutePaths.home;
                      }
                      return null;
                    },
                    builder: (context, state) {
                      final userId = int.parse(
                        state.pathParameters['userIdentifier']!,
                      );
                      return FollowConnectionsScreen(
                        userId: userId,
                        type: FollowConnectionsType.followers,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'following',
                    redirect: (context, state) {
                      final raw = state.pathParameters['userIdentifier'];
                      final userId = int.tryParse(raw ?? '');
                      if (userId == null) {
                        return RoutePaths.home;
                      }
                      return null;
                    },
                    builder: (context, state) {
                      final userId = int.parse(
                        state.pathParameters['userIdentifier']!,
                      );
                      return FollowConnectionsScreen(
                        userId: userId,
                        type: FollowConnectionsType.following,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths
            .notifications, // Ensure this is defined in route_paths.dart as '/notifications'
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile-image',
        pageBuilder: (context, state) {
          final imagePath = state.extra as String?;
          return CustomTransitionPage(
            key: state.pageKey,
            opaque: false,
            barrierColor: AppColors.background.withValues(alpha: 0.9),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            child: FullscreenImagePage(imagePath: imagePath),
          );
        },
      ),
      GoRoute(
        path: '/:username/:trackIdentifier',
        redirect: (context, state) async {
          final username = state.pathParameters['username']?.trim();
          final trackIdentifier = state.pathParameters['trackIdentifier']
              ?.trim();

          if (username == null ||
              username.isEmpty ||
              RoutePaths.isReservedDeepLinkSegment(username)) {
            return RoutePaths.home;
          }

          if (trackIdentifier == null || trackIdentifier.isEmpty) {
            return RoutePaths.home;
          }

          try {
            final trackRepository = ref.read(trackRepositoryProvider);
            final resolvedTrackIdEither = await trackRepository
                .resolveTrackIdentifier(trackIdentifier);

            return resolvedTrackIdEither.fold(
              (_) => RoutePaths.home,
              RoutePaths.trackPreview,
            );
          } catch (_) {
            return RoutePaths.home;
          }
        },
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/:username',
        redirect: (context, state) {
          final username = state.pathParameters['username']?.trim();

          if (username == null ||
              username.isEmpty ||
              RoutePaths.isReservedDeepLinkSegment(username)) {
            return RoutePaths.home;
          }

          return RoutePaths.publicProfile(username);
        },
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
});
