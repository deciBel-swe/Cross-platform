/// Desktop / mobile Feed screen — activity timeline backed by real API data.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/feed_track.dart';
import '../notifiers/feed_notifier.dart';
import '../widgets/feed_item.dart';

/// Activity feed showing recent tracks from followed users.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(feedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(centerTitle: true, title: const _MobileFeedTabs()),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.read(feedProvider.notifier).refresh(),
        ),
        data: (feedState) {
          final tracks = feedState.tracks.cast<FeedTrack>();
          if (tracks.isEmpty) {
            return _EmptyFeedView(isDesktop: isDesktop);
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(feedProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
                isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
                isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
                AppDimensions.paddingLg,
              ),
              itemCount: tracks.length + 1, // +1 for header (desktop) or footer
              itemBuilder: (context, index) {
                // Desktop header
                if (index == 0 && isDesktop) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Feed', style: AppTextStyles.sectionTitle),
                      SizedBox(height: AppDimensions.paddingSm),
                      Text(
                        'Hear the latest from people you follow.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      SizedBox(height: AppDimensions.paddingLg),
                    ],
                  );
                }

                final trackIndex = isDesktop ? index - 1 : index;

                // Footer — load-more indicator or sentinel
                if (trackIndex == tracks.length) {
                  if (feedState.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMd,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final track = tracks[trackIndex];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSm,
                  ),
                  child: FeedItem(
                    trackId: track.id,
                    userName: track.feedActorName,
                    action: track.feedAction,
                    trackTitle: track.title,
                    trackArtist: track.displayArtistName,
                    timeAgo: _timeAgo(track.feedTimestamp),
                    genre: track.genre,
                    likeCount: track.likeCount,
                    repostCount: track.repostCount,
                    isLiked: track.isLiked,
                    isReposted: track.isARepost,
                    plays: _formatCount(track.playCount),
                    commentCount: track.commentCount,
                    duration: _formatDuration(track.duration),
                    waveformPeaks: _buildPeaks(seed: track.id),
                    gradientColors: _colorsForTrack(track.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

bool _isDesktopLayout(BuildContext context) {
  final mq = MediaQuery.maybeOf(context);
  return mq != null && mq.size.width >= 801;
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
  const _EmptyFeedView({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Center(
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
            'Your feed is empty',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          const Text(
            'Follow artists to see their latest tracks here.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
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
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileFeedTabs extends StatelessWidget {
  const _MobileFeedTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Discover',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
        ),
        const SizedBox(width: AppDimensions.paddingLg),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLg,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Following',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
