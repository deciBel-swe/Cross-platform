/// Desktop / mobile Feed screen — activity timeline backed by real API data.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart' as library_track;
import '../../../library/domain/entities/track_status.dart';
import '../../../library/presentation/notifiers/track_audio_notifier.dart';
import '../../../library_profile/domain/entities/user_profile.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../../../library_profile/presentation/widgets/track_details.dart';
import '../../../offline/presentation/notifiers/track_download_notifier.dart';
import '../../../offline/presentation/providers/track_download_provider.dart';
import '../../../player/presentation/widgets/queue_bottom_sheet.dart';
import '../../../upgrade/presentation/widgets/pro_promotion_bottom_sheet.dart';
import '../../domain/entities/feed_item_type.dart';
import '../../domain/entities/feed_track.dart';
import '../notifiers/discover_feed_notifier.dart';
import '../notifiers/feed_notifier.dart';
import '../widgets/feed_item.dart';
import '../widgets/mobile_discover_track_page.dart';

enum FeedTab { following, discover }

final _discoveryFeedIndexProvider = StateProvider<int>((ref) => 0);

/// Activity feed showing recent tracks from followed users or discovered tracks.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  FeedTab _selectedTab = FeedTab.following;
  bool _miniPlayerSyncScheduled = false;
  bool? _pendingMiniPlayerSuppression;
  late final StateController<bool> _miniPlayerSuppressedNotifier;
  late final TrackAudioNotifier _audioNotifier;
  late final FeedNotifier _feedNotifier;
  late final DiscoverFeedNotifier _discoverFeedNotifier;
  late final TrackDownloadNotifier _downloadNotifier;

  @override
  void initState() {
    super.initState();
    _miniPlayerSuppressedNotifier = ref.read(
      mobileMiniPlayerSuppressedProvider.notifier,
    );
    _audioNotifier = ref.read(trackAudioProvider.notifier);
    _feedNotifier = ref.read(feedProvider.notifier);
    _discoverFeedNotifier = ref.read(discoverFeedProvider.notifier);
    _downloadNotifier = ref.read(trackDownloadProvider.notifier);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (_miniPlayerSuppressedNotifier.state) {
      Future.microtask(() => _miniPlayerSuppressedNotifier.state = false);
    }

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMoreSelectedFeed();
    }
  }

  void _loadMoreSelectedFeed() {
    if (_selectedTab == FeedTab.following) {
      _feedNotifier.loadMore();
    } else {
      _discoverFeedNotifier.loadMore();
    }
  }

  void _switchTab(FeedTab tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
    });
    // Scroll to top on switch safely
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _copyTrackLink(
    FeedTrack track, {
    String message = 'Track link copied',
  }) async {
    final link =
        'https://decibel.foo${RoutePaths.deepLinkTrack(track.artistUsername, track.id.toString())}';
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _downloadTrack(library_track.Track track) async {
    // Gate behind PRO tier — use the user profile (server-side source of truth).
    final profileAsync = ref.read(userProfileProvider);
    final profile = profileAsync.valueOrNull?.fold((_) => null, (p) => p);
    final isPro =
        profile?.tier == UserTier.pro || profile?.tier == UserTier.artistPro;

    if (!isPro) {
      ProPromotionBottomSheet.show(context);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Downloading "${track.title}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await _downloadNotifier.downloadTrack(track);
    if (!mounted) {
      return;
    }

    final state = ref.read(trackDownloadProvider);
    messenger.hideCurrentSnackBar();
    if (state.hasError) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Download failed: ${state.error}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errors,
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('Downloaded "${track.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFeedSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _syncMiniPlayerSuppression(bool shouldSuppress) {
    _pendingMiniPlayerSuppression = shouldSuppress;
    if (_miniPlayerSyncScheduled) {
      return;
    }

    _miniPlayerSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _miniPlayerSyncScheduled = false;
      if (!mounted) {
        return;
      }

      final target = _pendingMiniPlayerSuppression;
      if (target == null) {
        return;
      }

      final current = _miniPlayerSuppressedNotifier.state;
      if (current != target) {
        _miniPlayerSuppressedNotifier.state = target;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    _syncMiniPlayerSuppression(!isDesktop && _selectedTab == FeedTab.discover);
    final authState = ref.watch(authStateProvider).valueOrNull;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : null;
    // FIX 1: Watch BOTH providers so they are not disposed when switching tabs
    final followingAsync = ref.watch(feedProvider);
    final discoverAsync = ref.watch(discoverFeedProvider);

    final feedAsync = _selectedTab == FeedTab.following
        ? followingAsync
        : discoverAsync;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: !isDesktop && _selectedTab == FeedTab.discover,
      appBar: isDesktop
          ? null
          : AppBar(
              centerTitle: true,
              backgroundColor: _selectedTab == FeedTab.discover
                  ? Colors.transparent
                  : AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: _MobileFeedTabs(
                selectedTab: _selectedTab,
                onTabChanged: _switchTab,
              ),
            ),
      body: Column(
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              child: _DesktopFeedHeader(
                selectedTab: _selectedTab,
                onTabChanged: _switchTab,
              ),
            ),
          Expanded(
            child: feedAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorView(
                message: error.toString(),
                onRetry: () {
                  if (!mounted) return;
                  if (_selectedTab == FeedTab.following) {
                    _feedNotifier.refresh();
                  } else {
                    _discoverFeedNotifier.refresh();
                  }
                },
              ),
              data: (feedState) {
                final tracks = feedState.tracks.cast<FeedTrack>();
                final playableQueue = tracks.map(_toLibraryTrack).toList();
                if (tracks.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (_selectedTab == FeedTab.following) {
                        await _feedNotifier.refresh();
                      } else {
                        await _discoverFeedNotifier.refresh();
                      }
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: _EmptyFeedView(
                              isDesktop: isDesktop,
                              tab: _selectedTab,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (!isDesktop && _selectedTab == FeedTab.discover) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _discoverFeedNotifier.refresh();
                    },
                    child: _MobileDiscoverFeedPager(
                      tracks: tracks,
                      playableQueue: playableQueue,
                      isLoadingMore: feedState.isLoadingMore,
                      onLoadMore: () {
                        if (!mounted) return;
                        _discoverFeedNotifier.loadMore();
                      },
                      onPlayTrack: (track, queue) async {
                        if (!mounted) return;
                        await _audioNotifier.playTrack(
                          track: track,
                          queue: queue,
                        );
                      },
                      onAddToPlaylist: (track) {
                        context.push(RoutePaths.addToPlaylist, extra: track);
                      },
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    if (_selectedTab == FeedTab.following) {
                      await _feedNotifier.refresh();
                    } else {
                      await _discoverFeedNotifier.refresh();
                    }
                  },
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      primary: false,
                      padding: EdgeInsets.fromLTRB(
                        isDesktop
                            ? AppDimensions.paddingLg
                            : AppDimensions.paddingMd,
                        isDesktop ? 0 : AppDimensions.paddingMd,
                        isDesktop
                            ? AppDimensions.paddingLg
                            : AppDimensions.paddingMd,
                        AppDimensions.paddingLg,
                      ),
                      itemCount: tracks.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tracks.length) {
                          return _FeedPaginationFooter(
                            isLoadingMore: feedState.isLoadingMore,
                          );
                        }

                        final track = tracks[index];
                        final playableTrack = playableQueue[index];
                        final isOwnTrack =
                            currentUserId != null &&
                            currentUserId == track.artistId;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.paddingSm,
                          ),
                          child: FeedItem(
                            trackId: track.id,
                            userName: track.feedActorName,
                            userAvatarUrl: track.isARepost
                                ? track.repostedByAvatarUrl ??
                                      track.artistAvatarUrl
                                : track.artistAvatarUrl,
                            action: track.feedAction,
                            trackTitle: track.title,
                            trackArtist: track.displayArtistName,
                            coverUrl: track.coverUrl,
                            timeAgo: _timeAgo(track.feedTimestamp),
                            genre: track.genre,
                            likeCount: track.likeCount,
                            repostCount: track.repostCount,
                            isLiked: track.isLiked,
                            isReposted: track.isARepost,
                            plays: _formatCount(track.playCount),
                            commentCount: track.commentCount,
                            duration: _selectedTab == FeedTab.discover
                                ? ''
                                : _formatDuration(track.duration),
                            waveformPeaks: _buildPeaks(seed: track.id),
                            commentTrack: playableTrack,
                            gradientColors: _colorsForTrack(track.id),
                            feedItemType:
                                _parseFeedItemType(track.feedItemType) ??
                                FeedItemType.trackPosted,
                            playlistData: track.playlistData,
                            onPlay: () {
                              if (!mounted) return;
                              if (!playableTrack.isPlayable) {
                                _showFeedSnackBar(
                                  'This track is not playable (missing audio URL).',
                                );
                                return;
                              }
                              _audioNotifier.playTrack(
                                track: playableTrack,
                                queue: _selectedTab == FeedTab.discover
                                    ? [playableTrack]
                                    : playableQueue,
                              );
                            },
                            onAddToPlaylist: () {
                              // The add-to-playlist route expects the shared
                              // library Track entity, so keep conversion here.
                              context.push(
                                RoutePaths.addToPlaylist,
                                extra: playableTrack,
                              );
                            },
                            onAddToQueue: () {
                              if (!mounted) return;
                              _audioNotifier.addToQueue(playableTrack);
                            },
                            onEditTrack: isOwnTrack
                                ? () => context.push(
                                    RoutePaths.trackEdit(track.id),
                                  )
                                : null,
                            onGoToArtist: () {
                              final artistIdentifier =
                                  track.artistUsername.trim().isNotEmpty
                                  ? track.artistUsername
                                  : track.artistId.toString();
                              context.push(
                                RoutePaths.publicProfile(artistIdentifier),
                              );
                            },
                            onGoToAlbum: () {
                              _showFeedSnackBar(
                                'Album pages are not available yet',
                              );
                            },
                            onShare: () {
                              if (!mounted) return;
                              unawaited(
                                _copyTrackLink(
                                  track,
                                  message: 'Track link copied to share',
                                ),
                              );
                            },
                            onCopyLink: () {
                              if (!mounted) return;
                              unawaited(_copyTrackLink(track));
                            },
                            onDownload: () {
                              if (!mounted) return;
                              unawaited(_downloadTrack(playableTrack));
                            },
                            onMoreOptions: () {
                              if (!mounted) return;
                              unawaited(
                                TrackDetails.show(context, playableTrack, ref),
                              );
                            },
                            onViewQueue: () {
                              if (!mounted) return;
                              unawaited(QueueBottomSheet.show(context));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

library_track.Track _toLibraryTrack(FeedTrack track) {
  return library_track.Track(
    id: track.id,
    title: track.title,
    artist: Artist(
      id: track.artistId,
      username: track.artistUsername,
      displayName: track.artistDisplayName,
      avatarUrl: track.artistAvatarUrl,
    ),
    trackUrl: track.trackUrl,
    trackPreviewUrl: track.trackPreviewUrl,
    coverUrl: track.coverUrl,
    waveformUrl: track.waveformUrl,
    genre: track.genre,
    access: track.access,
    tags: track.tags,
    state: TrackStatus.finished,
    releaseDate: track.releaseDate,
    playCount: track.playCount,
    likeCount: track.likeCount,
    repostCount: track.repostCount,
    isLiked: track.isLiked,
    isReposted: track.isReposted,
    createdAt: track.uploadDate,
    trackDurationSeconds: track.trackDurationSeconds,
    isPrivate: track.isPrivate,
  );
}

// ── Helpers ──────────────────────────────────────────────────────────────────

FeedItemType? _parseFeedItemType(String? typeStr) {
  if (typeStr == null) return null;
  switch (typeStr) {
    case 'track_posted':
      return FeedItemType.trackPosted;
    case 'playlist_posted':
      return FeedItemType.playlistPosted;
    case 'repost':
      return FeedItemType.repost;
    default:
      return null;
  }
}

class _MobileDiscoverFeedPager extends ConsumerStatefulWidget {
  const _MobileDiscoverFeedPager({
    required this.tracks,
    required this.playableQueue,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onPlayTrack,
    required this.onAddToPlaylist,
  });

  final List<FeedTrack> tracks;
  final List<library_track.Track> playableQueue;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Future<void> Function(
    library_track.Track track,
    List<library_track.Track> queue,
  )
  onPlayTrack;
  final ValueChanged<library_track.Track> onAddToPlaylist;

  @override
  ConsumerState<_MobileDiscoverFeedPager> createState() =>
      _MobileDiscoverFeedPagerState();
}

class _MobileDiscoverFeedPagerState
    extends ConsumerState<_MobileDiscoverFeedPager> {
  int _autoplayRequestId = 0;
  late final PageController _pageController;
  int _currentIndex = 0;
  int? _lastPlayedTrackId;

  int get _visibleTrackCount {
    final trackCount = widget.tracks.length;
    final queueCount = widget.playableQueue.length;
    return trackCount < queueCount ? trackCount : queueCount;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = ref.read(_discoveryFeedIndexProvider);
    _pageController = PageController(initialPage: _currentIndex);
    _scheduleAutoplay();
  }

  @override
  void didUpdateWidget(covariant _MobileDiscoverFeedPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_didPlayableQueueChange(
      oldWidget.playableQueue,
      widget.playableQueue,
    )) {
      return;
    }

    if (_visibleTrackCount == 0) {
      _currentIndex = 0;
      _lastPlayedTrackId = null;
      return;
    }

    if (_currentIndex >= _visibleTrackCount) {
      _currentIndex = 0;

      // FIX 3: Actually move the PageView and update the global provider
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      Future.microtask(() {
        if (mounted) {
          ref.read(_discoveryFeedIndexProvider.notifier).state = 0;
        }
      });
    }

    final currentTrackId = widget.playableQueue[_currentIndex].id;
    if (_lastPlayedTrackId != currentTrackId) {
      _lastPlayedTrackId = null;
    }

    _scheduleAutoplay();
  }

  @override
  void dispose() {
    _autoplayRequestId += 1;
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoplay() {
    if (_visibleTrackCount == 0) {
      return;
    }

    final requestId = ++_autoplayRequestId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || requestId != _autoplayRequestId) {
        return;
      }
      _playIndex(_currentIndex);
    });
  }

  bool _didPlayableQueueChange(
    List<library_track.Track> previousQueue,
    List<library_track.Track> currentQueue,
  ) {
    if (identical(previousQueue, currentQueue)) {
      return false;
    }

    if (previousQueue.length != currentQueue.length) {
      return true;
    }

    for (var i = 0; i < previousQueue.length; i++) {
      if (previousQueue[i].id != currentQueue[i].id) {
        return true;
      }
    }

    return false;
  }

  Future<void> _playTrack(
    library_track.Track track,
    List<library_track.Track> queue,
  ) async {
    // Discover mode: No queue, only play the single selected track
    await widget.onPlayTrack(track, [track]);
  }

  void _playIndex(int index) {
    if (index < 0 || index >= _visibleTrackCount) {
      return;
    }

    final track = widget.playableQueue[index];

    // FIX 2: Check if this track is ALREADY playing globally to prevent restarting from 0:00
    final currentAudioState = ref.read(trackAudioProvider);
    final isAlreadyPlayingGlobally =
        currentAudioState.currentTrack?.id == track.id;

    if (_lastPlayedTrackId == track.id || isAlreadyPlayingGlobally) {
      _lastPlayedTrackId = track.id; // Keep local state in sync
      return;
    }

    _lastPlayedTrackId = track.id;
    unawaited(_playTrack(track, [track]));
  }

  @override
  Widget build(BuildContext context) {
    final visibleTrackCount = _visibleTrackCount;
    final showPaginationLoader =
        widget.isLoadingMore || visibleTrackCount < widget.tracks.length;

    if (visibleTrackCount == 0) {
      if (showPaginationLoader) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: visibleTrackCount + (showPaginationLoader ? 1 : 0),
      onPageChanged: (index) {
        if (index < visibleTrackCount) {
          _currentIndex = index;
          ref.read(_discoveryFeedIndexProvider.notifier).state = index;
          _playIndex(index);
        }

        if (index >= visibleTrackCount - 3 && !widget.isLoadingMore) {
          widget.onLoadMore();
        }
      },
      itemBuilder: (context, index) {
        if (index >= visibleTrackCount) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final track = widget.tracks[index];
        final libTrack = widget.playableQueue[index];
        return MobileDiscoverTrackPage(
          track: track,
          playableTrack: libTrack,
          playableQueue: [libTrack], // Discover mode: single-item queue
          gradientColors: _colorsForTrack(track.id),
          onPlayTrack: _playTrack,
          onAddToPlaylist: widget.onAddToPlaylist,
        );
      },
    );
  }
}

String _formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
  return n.toString();
}

String _formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

String _timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inDays > 365) return '${(diff.inDays / 365).floor()} years ago';
  if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
  if (diff.inDays > 0) return '${diff.inDays} days ago';
  if (diff.inHours > 0) return '${diff.inHours} hours ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
  return 'just now';
}

List<double> _buildPeaks({required int seed, int count = 220}) {
  final base = seed.abs() + 17;
  return List<double>.generate(count, (i) {
    final raw = ((base + (i * 37)) % 100) / 100;
    final folded = raw <= 0.5 ? raw : 1 - raw;
    return (folded * 1.8).clamp(0.06, 1.0);
  });
}

List<Color> _colorsForTrack(int trackId) {
  const palette = <List<Color>>[
    [Color(0xFF1E88E5), Color(0xFFF4511E)],
    [Color(0xFF3E2723), Color(0xFF6D4C41)],
    [Color(0xFF37474F), Color(0xFF263238)],
    [Color(0xFF6A1B9A), Color(0xFFAD1457)],
    [Color(0xFF00695C), Color(0xFF004D40)],
    [Color(0xFF1565C0), Color(0xFF0D47A1)],
  ];
  return palette[trackId % palette.length];
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView({required this.isDesktop, required this.tab});
  final bool isDesktop;
  final FeedTab tab;

  @override
  Widget build(BuildContext context) {
    final title = tab == FeedTab.following
        ? 'Your feed is empty'
        : 'No discoveries yet';
    final subtitle = tab == FeedTab.following
        ? 'Follow artists to see their latest tracks here.'
        : 'Try following more artists to get better recommendations.';

    return Center(
      child: Semantics(
        label: title,
        hint: subtitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.queue_music_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Text(
              'Could not load your feed',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.paddingLg),
            Semantics(
              button: true,
              label: 'Retry loading feed',
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedPaginationFooter extends StatelessWidget {
  const _FeedPaginationFooter({required this.isLoadingMore});

  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return const SizedBox.shrink();
  }
}

class _MobileFeedTabs extends StatelessWidget {
  const _MobileFeedTabs({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final FeedTab selectedTab;
  final ValueChanged<FeedTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TabItem(
          label: 'Discover',
          isSelected: selectedTab == FeedTab.discover,
          onTap: () => onTabChanged(FeedTab.discover),
        ),
        const SizedBox(width: AppDimensions.paddingLg),
        _TabItem(
          label: 'Following',
          isSelected: selectedTab == FeedTab.following,
          onTap: () => onTabChanged(FeedTab.following),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '$label tab',
        hint: 'Switch to $label feed',
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLg,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceVariant : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 16,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopFeedHeader extends StatelessWidget {
  const _DesktopFeedHeader({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final FeedTab selectedTab;
  final ValueChanged<FeedTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final title = selectedTab == FeedTab.following ? 'Your Feed' : 'Discover';
    final subtitle = selectedTab == FeedTab.following
        ? 'Hear the latest from people you follow.'
        : 'New tracks you might like based on your taste.';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppDimensions.paddingSm),
              Text(subtitle, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DesktopTabButton(
              label: 'Following',
              isSelected: selectedTab == FeedTab.following,
              onTap: () => onTabChanged(FeedTab.following),
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            _DesktopTabButton(
              label: 'Discover',
              isSelected: selectedTab == FeedTab.discover,
              onTap: () => onTabChanged(FeedTab.discover),
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopTabButton extends StatelessWidget {
  const _DesktopTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? AppColors.textPrimary
            : AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }
}
