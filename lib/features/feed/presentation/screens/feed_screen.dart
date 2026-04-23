/// Desktop / mobile Feed screen — activity timeline backed by real API data.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/feed_track.dart';
import '../notifiers/feed_notifier.dart';
import '../notifiers/discover_feed_notifier.dart';
import '../widgets/feed_item.dart';

enum FeedTab { following, discover }

/// Activity feed showing recent tracks from followed users or discovered tracks.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  FeedTab _selectedTab = FeedTab.following;

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
      if (_selectedTab == FeedTab.following) {
        ref.read(feedProvider.notifier).loadMore();
      } else {
        ref.read(discoverFeedProvider.notifier).loadMore();
      }
    }
  }

  void _switchTab(FeedTab tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
    });
    // Scroll to top on switch
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final feedAsync = _selectedTab == FeedTab.following
        ? ref.watch(feedProvider)
        : ref.watch(discoverFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              centerTitle: true,
              title: _MobileFeedTabs(
                selectedTab: _selectedTab,
                onTabChanged: _switchTab,
              ),
            ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () {
            if (_selectedTab == FeedTab.following) {
              ref.read(feedProvider.notifier).refresh();
            } else {
              ref.read(discoverFeedProvider.notifier).refresh();
            }
          },
        ),
        data: (feedState) {
          final tracks = feedState.tracks.cast<FeedTrack>();
          if (tracks.isEmpty) {
            return _EmptyFeedView(isDesktop: isDesktop, tab: _selectedTab);
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (_selectedTab == FeedTab.following) {
                await ref.read(feedProvider.notifier).refresh();
              } else {
                await ref.read(discoverFeedProvider.notifier).refresh();
              }
            },
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DesktopFeedHeader(
                        selectedTab: _selectedTab,
                        onTabChanged: _switchTab,
                      ),
                      const SizedBox(height: AppDimensions.paddingLg),
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
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
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
        foregroundColor:
            isSelected ? AppColors.textPrimary : AppColors.textSecondary,
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
