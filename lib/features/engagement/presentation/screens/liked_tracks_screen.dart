import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/playlist_tile.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart' as playlist_providers;
import '../../domain/models/track_action_data.dart';
import '../notifiers/liked_tracks_notifier.dart';
import '../providers/playlist_social_provider.dart';
import '../providers/track_social_provider.dart';

class LikedTracksScreen extends StatelessWidget {
  const LikedTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaCollectionScreen(
      collectionType: TrackCollectionType.liked,
      title: 'Your Likes',
      emptyStateMessage: 'Tracks and playlists you like will appear here.',
      emptyStateIcon: Icons.favorite_rounded,
      errorPrefix: 'Failed to load likes',
      removeAction: SocialActionType.like,
      includePlaylists: true,
    );
  }
}

class RepostedTracksScreen extends StatelessWidget {
  const RepostedTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaCollectionScreen(
      collectionType: TrackCollectionType.reposted,
      title: 'Your Reposts',
      emptyStateMessage: 'Tracks you repost will appear here.',
      emptyStateIcon: Icons.repeat_rounded,
      errorPrefix: 'Failed to load reposts',
      removeAction: SocialActionType.repost,
    );
  }
}

class MediaCollectionScreen extends ConsumerStatefulWidget {
  const MediaCollectionScreen({
    super.key,
    required this.collectionType,
    required this.title,
    required this.emptyStateMessage,
    required this.emptyStateIcon,
    required this.errorPrefix,
    required this.removeAction,
    this.includePlaylists = false,
  });

  final TrackCollectionType collectionType;
  final String title;
  final String emptyStateMessage;
  final IconData emptyStateIcon;
  final String errorPrefix;
  final SocialActionType removeAction;
  final bool includePlaylists;

  @override
  ConsumerState<MediaCollectionScreen> createState() =>
      _MediaCollectionScreenState();
}

class _MediaCollectionScreenState extends ConsumerState<MediaCollectionScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Object> _localItems = [];
  late final ScrollController _scrollController;

  TrackCollectionType get _collectionType => widget.collectionType;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final initialTracks = ref
        .read(trackCollectionProvider(_collectionType))
        .valueOrNull;
    if (initialTracks != null && initialTracks.isNotEmpty) {
      _localItems.addAll(initialTracks);
    }

    if (widget.includePlaylists) {
      final initialPlaylists = ref
          .read(playlist_providers.userLikedPlaylistsProvider)
          .valueOrNull;
      if (initialPlaylists != null && initialPlaylists.isNotEmpty) {
        _localItems.addAll(initialPlaylists);
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const delta = 200.0;
    if (maxScroll - currentScroll <= delta) {
      ref.read(trackCollectionProvider(_collectionType).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _syncItems(List<Track> incomingTracks, [List<Playlist> incomingPlaylists = const []]) {
    final List<Object> incomingItems = [...incomingTracks, ...incomingPlaylists];

    bool isSame = false;
    if (incomingItems.length == _localItems.length) {
      isSame = true;
      for (int i = 0; i < incomingItems.length; i++) {
        final a = incomingItems[i];
        final b = _localItems[i];
        if (a is Track && b is Track) {
          if (a.id != b.id) {
            isSame = false;
            break;
          }
        } else if (a is Playlist && b is Playlist) {
          if (a.id != b.id) {
            isSame = false;
            break;
          }
        } else {
          isSame = false;
          break;
        }
      }
    }
    if (isSame) return;

    if (incomingItems.isEmpty) {
      final oldLength = _localItems.length;
      for (int i = oldLength - 1; i >= 0; i--) {
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => const SizedBox.shrink(),
          duration: Duration.zero,
        );
      }
      _localItems.clear();
      return;
    }

    if (_localItems.isEmpty) {
      _localItems.addAll(incomingItems);
      for (int i = 0; i < incomingItems.length; i++) {
        _listKey.currentState?.insertItem(i, duration: Duration.zero);
      }
      return;
    }

    // Full refresh for now if mixed types or complex changes
    final oldLength = _localItems.length;
    for (int i = oldLength - 1; i >= 0; i--) {
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => const SizedBox.shrink(),
        duration: Duration.zero,
      );
    }
    _localItems.clear();
    _localItems.addAll(incomingItems);
    for (int i = 0; i < incomingItems.length; i++) {
      _listKey.currentState?.insertItem(i, duration: Duration.zero);
    }
  }

  void _handleRemoveTrack(Track track, int index) {
    // 1. Remove from local list & animate
    final removedItem = _localItems.removeAt(index);
    final removedTrack = removedItem as Track;
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), // Slide out to the right
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
            ),
          ),
          child: TrackTile(track: removedTrack),
        ),
      ),
      duration: const Duration(milliseconds: 1000),
    );

    // 2. Perform actual API call via TrackSocialNotifier
    ref
        .read(trackSocialProvider(track.id).notifier)
        .toggleAction(widget.removeAction);

    // 3. Optimistic update: notify collection notifier to remove it from state
    ref
        .read(trackCollectionProvider(_collectionType).notifier)
        .removeTrackLocal(track.id);
  }

  void _handleRemovePlaylist(Playlist playlist, int index) {
    // 1. Remove from local list & animate
    final removedItem = _localItems.removeAt(index);
    final removedPlaylist = removedItem as Playlist;
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), // Slide out to the right
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
            ),
          ),
          child: PlaylistTile(playlist: removedPlaylist),
        ),
      ),
      duration: const Duration(milliseconds: 1000),
    );

    // 2. Perform actual API call via PlaylistSocialNotifier
    ref.read(playlistSocialProvider(playlist.id).notifier).toggleLike();

    // 3. Optimistic update: notify liked playlists provider
    ref
        .read(playlist_providers.userLikedPlaylistsProvider.notifier)
        .removePlaylistLocal(playlist.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = trackCollectionProvider(_collectionType);
    final asyncTracks = ref.watch(provider);
    final asyncPlaylists = widget.includePlaylists 
        ? ref.watch(playlist_providers.userLikedPlaylistsProvider)
        : const AsyncData(<Playlist>[]);

    ref.listen<AsyncValue<List<Track>>>(provider, (previous, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _syncItems(next.value!, asyncPlaylists.valueOrNull ?? []);
      }
    });

    if (widget.includePlaylists) {
      ref.listen<AsyncValue<List<Playlist>>>(playlist_providers.userLikedPlaylistsProvider, (previous, next) {
        if (next.hasValue && !next.isLoading && !next.hasError) {
          _syncItems(asyncTracks.valueOrNull ?? [], next.value!);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: asyncTracks.when(
        skipLoadingOnRefresh: false,
        data: (tracks) {
          final playlists = asyncPlaylists.valueOrNull ?? [];
          final combined = [...tracks, ...playlists];

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(provider.notifier).refreshAll();
              if (widget.includePlaylists) {
                // Actually UserLikedPlaylistsNotifier doesn't have refreshAll yet, but it's autoDispose
                ref.invalidate(playlist_providers.userLikedPlaylistsProvider);
              }
            },
            child: Stack(
              children: [
                if (combined.isEmpty && _localItems.isEmpty)
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.emptyStateIcon,
                              size: 64,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.emptyStateMessage,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                AnimatedList(
                  key: _listKey,
                  controller: _scrollController,
                  initialItemCount: _localItems.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.mobileMiniPlayerReservedSpace,
                  ),
                  itemBuilder: (context, index, animation) {
                    if (index >= _localItems.length) {
                      return const SizedBox.shrink();
                    }
                    final item = _localItems[index];

                    if (item is Track) {
                      return FadeTransition(
                        opacity: animation,
                        child: TrackTile(
                          track: item,
                          onTap: () => ref
                              .read(trackAudioProvider.notifier)
                              .playTrack(track: item, queue: tracks),
                          onLikePressed: () =>
                              _handleRemoveTrack(item, index),
                        ),
                      );
                    } else if (item is Playlist) {
                      return FadeTransition(
                        opacity: animation,
                        child: PlaylistTile(
                          playlist: item,
                          onTap: () => context.push(
                            RoutePaths.playlistTracks,
                            extra: item,
                          ),
                          onLikePressed: () =>
                              _handleRemovePlaylist(item, index),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text('${widget.errorPrefix}: $error'),
              TextButton(
                onPressed: () => ref.read(provider.notifier).refreshAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
