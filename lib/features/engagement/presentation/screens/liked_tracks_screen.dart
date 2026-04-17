import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../domain/models/track_action_data.dart';
import '../notifiers/liked_tracks_notifier.dart';
import '../providers/track_social_provider.dart';

class LikedTracksScreen extends StatelessWidget {
  const LikedTracksScreen({super.key, this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return TrackCollectionScreen(
      collectionType: TrackCollectionType.liked,
      username: username,
      title: username != null ? 'Likes' : 'Your Likes',
      emptyStateMessage: username != null
          ? 'This user has no likes yet.'
          : 'Tracks you like will appear here.',
      emptyStateIcon: Icons.favorite_rounded,
      errorPrefix: 'Failed to load likes',
      removeAction: SocialActionType.like,
    );
  }
}

class RepostedTracksScreen extends StatelessWidget {
  const RepostedTracksScreen({super.key, this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return TrackCollectionScreen(
      collectionType: TrackCollectionType.reposted,
      username: username,
      title: username != null ? 'Reposts' : 'Your Reposts',
      emptyStateMessage: username != null
          ? 'This user has no reposts yet.'
          : 'Tracks you repost will appear here.',
      emptyStateIcon: Icons.repeat_rounded,
      errorPrefix: 'Failed to load reposts',
      removeAction: SocialActionType.repost,
    );
  }
}

class TrackCollectionScreen extends ConsumerStatefulWidget {
  const TrackCollectionScreen({
    super.key,
    required this.collectionType,
    required this.title,
    required this.emptyStateMessage,
    required this.emptyStateIcon,
    required this.errorPrefix,
    required this.removeAction,
    this.username,
  });

  final TrackCollectionType collectionType;
  final String title;
  final String emptyStateMessage;
  final IconData emptyStateIcon;
  final String errorPrefix;
  final SocialActionType removeAction;
  final String? username;

  @override
  ConsumerState<TrackCollectionScreen> createState() =>
      _TrackCollectionScreenState();
}

class _TrackCollectionScreenState extends ConsumerState<TrackCollectionScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Track> _localTracks = [];
  late final ScrollController _scrollController;

  TrackCollectionType get _collectionType => widget.collectionType;
  (TrackCollectionType, String?) get _providerArg =>
      (_collectionType, widget.username);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final initialTracks =
        ref.read(trackCollectionProvider(_providerArg)).valueOrNull;
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
      ref.read(trackCollectionProvider(_providerArg).notifier).loadMore();
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

  void _handleRemoveFromCollection(Track track, int index) {
    // 1. Remove from local list & animate
    final removedTrack = _localTracks.removeAt(index);
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
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
          )),
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
    // so it doesn't reappear on partial refresh.
    ref
        .read(trackCollectionProvider(_providerArg).notifier)
        .removeTrackLocal(track.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = trackCollectionProvider(_providerArg);
    final asyncTracks = ref.watch(provider);

    ref.listen<AsyncValue<List<Track>>>(provider, (previous, next) {
      if (next.hasValue && !next.isLoading && !next.hasError) {
        _syncTracks(next.value!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.background,
        //dont change color when scrolling
        scrolledUnderElevation: 0,
      ),
      body: asyncTracks.when(
        skipLoadingOnRefresh: false,
        data: (tracks) {
          return RefreshIndicator(
            onRefresh: () => ref.read(provider.notifier).refreshAll(),
            child: Stack(
              children: [
                if (tracks.isEmpty && _localTracks.isEmpty)
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
                  initialItemCount: _localTracks.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.mobileMiniPlayerReservedSpace,
                  ),
              itemBuilder: (context, index, animation) {
                if (index >= _localTracks.length) {
                  return const SizedBox.shrink();
                }
                final track = _localTracks[index];

                return FadeTransition(
                  opacity: animation,
                  child: TrackTile(
                    track: track,
                    onTap: () => ref.read(trackAudioProvider.notifier).initializeForTrack(
                          trackId: track.id,
                          trackUrl: track.trackUrl ?? '',
                          track: track,
                          queue: _localTracks,
                        ),
                        onLikePressed: widget.username == null ? () =>
                        _handleRemoveFromCollection(track, index) : null,
                    // onMorePressed: () => TrackDetails.show(context, track, ref),
                  ),
                );
              },
            ),
            ]));
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
