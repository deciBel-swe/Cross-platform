import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/models/track_action_data.dart';
import '../notifiers/liked_tracks_notifier.dart';
import '../notifiers/track_action_notifier.dart';
import '../widgets/liked_track_tile.dart';

class LikedTracksScreen extends ConsumerStatefulWidget {
  const LikedTracksScreen({super.key});

  @override
  ConsumerState<LikedTracksScreen> createState() => _LikedTracksScreenState();
}

class _LikedTracksScreenState extends ConsumerState<LikedTracksScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Track> _localTracks = [];
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final initialTracks = ref.read(likedTracksProvider).valueOrNull;
    if (initialTracks != null && initialTracks.isNotEmpty) {
      _localTracks.addAll(initialTracks);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const delta = 200.0;
    if (maxScroll - currentScroll <= delta) {
      ref.read(likedTracksProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _syncTracks(List<Track> incomingTracks) {
    bool isSame = false;
    if (incomingTracks.length == _localTracks.length) {
      isSame = true;
      for (int i = 0; i < incomingTracks.length; i++) {
        if (incomingTracks[i].id != _localTracks[i].id) {
          isSame = false;
          break;
        }
      }
    }
    if (isSame) return;

    if (incomingTracks.isEmpty) {
      final oldLength = _localTracks.length;
      for (int i = oldLength - 1; i >= 0; i--) {
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => const SizedBox.shrink(),
          duration: Duration.zero,
        );
      }
      _localTracks.clear();
      return;
    }

    if (_localTracks.isEmpty) {
      _localTracks.addAll(incomingTracks);
      for (int i = 0; i < incomingTracks.length; i++) {
        _listKey.currentState?.insertItem(i, duration: Duration.zero);
      }
      return;
    }

    if (incomingTracks.length > _localTracks.length &&
        incomingTracks.first.id == _localTracks.first.id) {
      final startIndex = _localTracks.length;
      final newItems = incomingTracks.sublist(startIndex);
      _localTracks.addAll(newItems);
      for (int i = 0; i < newItems.length; i++) {
        _listKey.currentState?.insertItem(
          startIndex + i,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    // Full refresh
    final oldLength = _localTracks.length;
    for (int i = oldLength - 1; i >= 0; i--) {
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => const SizedBox.shrink(),
        duration: Duration.zero,
      );
    }
    _localTracks.clear();
    _localTracks.addAll(incomingTracks);
    for (int i = 0; i < incomingTracks.length; i++) {
      _listKey.currentState?.insertItem(i, duration: Duration.zero);
    }
  }

  void _handleUnlike(Track track, int index) {
    // 1. Remove from local list & animate
    final removedTrack = _localTracks.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation.drive(
          CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
        ),
        child: SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0), // Slide out to the right
              end: Offset.zero,
            ).chain(
              CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
            ),
          ),
          child: LikedTrackTile(
            track: removedTrack,
            onUnlike: () {}, // Do nothing during removal
          ),
        ),
      ),
      duration: const Duration(milliseconds: 1000),
    );

    // 2. Perform actual API call via TrackSocialNotifier
    ref
        .read(trackSocialProvider.notifier)
        .toggleAction(track.id.toString(), SocialActionType.like);

    // 3. Optimistic update: notify LikedTracksNotifier to remove it from state
    // so it doesn't reappear on partial refresh.
    ref.read(likedTracksProvider.notifier).removeTrackLocal(track.id);
  }

  @override
  Widget build(BuildContext context) {
    final asyncTracks = ref.watch(likedTracksProvider);

    ref.listen<AsyncValue<List<Track>>>(likedTracksProvider, (previous, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _syncTracks(next.value!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Likes'),
        backgroundColor: AppColors.background,
        //dont change color when scrolling
        scrolledUnderElevation: 0,
      ),
      body: asyncTracks.when(
        skipLoadingOnRefresh: false,
        data: (tracks) {
          if (tracks.isEmpty && _localTracks.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(likedTracksProvider.notifier).refreshAll(),
              child: Stack(
                children: [
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [SizedBox(height: 100)],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 64,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Tracks you like will appear here.",
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
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(likedTracksProvider.notifier).refreshAll(),
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              initialItemCount: _localTracks.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                if (index >= _localTracks.length) {
                  return const SizedBox.shrink();
                }
                final track = _localTracks[index];

                return FadeTransition(
                  opacity: animation,
                  child: LikedTrackTile(
                    track: track,
                    onUnlike: () => _handleUnlike(track, index),
                    onTap: () {},
                  ),
                );
              },
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
              Text('Failed to load likes: $error'),
              TextButton(
                onPressed: () =>
                    ref.read(likedTracksProvider.notifier).refreshAll(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
