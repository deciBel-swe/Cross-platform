/// Desktop Feed screen — activity timeline.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/following_feed_provider.dart';
import '../widgets/feed_item.dart';

/// Activity feed showing recent actions from followed users.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final threshold = position.maxScrollExtent * 0.8;

    if (position.pixels >= threshold) {
      ref.read(followingFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final feedAsync = ref.watch(followingFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: const Text('Your Feed'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(followingFeedProvider.notifier).refresh();
                  },
                ),
              ],
            )
          : AppBar(
              centerTitle: true,
              title: const _MobileFeedTabs(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(followingFeedProvider.notifier).refresh();
                  },
                ),
              ],
            ),
      body: feedAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop
                  ? AppDimensions.paddingLg
                  : AppDimensions.paddingMd,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.textMuted,
                  size: 54,
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                const Text(
                  'Failed to load following feed.',
                  style: AppTextStyles.sectionTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingSm),
                TextButton(
                  onPressed: () {
                    ref.read(followingFeedProvider.notifier).refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.read(followingFeedProvider.notifier).refresh(),
          child: items.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    AppDimensions.paddingLg,
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                    const Icon(
                      Icons.people_outline_rounded,
                      color: AppColors.textMuted,
                      size: 72,
                    ),
                    const SizedBox(height: AppDimensions.paddingMd),
                    const Text(
                      "That’s it — ready to follow more people?",
                      style: AppTextStyles.sectionTitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    isDesktop
                        ? AppDimensions.paddingLg
                        : AppDimensions.paddingMd,
                    AppDimensions.paddingLg,
                  ),
                  children: [
                    if (isDesktop) ...[
                      const SizedBox(height: AppDimensions.paddingSm),
                      const Text(
                        'Hear the latest from people you follow.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppDimensions.paddingLg),
                    ],
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingSm,
                        ),
                        child: FeedItem(
                          userName: item.userName,
                          action: item.action,
                          trackTitle: item.trackTitle,
                          trackArtist: item.trackArtist,
                          timeAgo: item.timeAgo,
                          genre: item.genre,
                          likes: item.likes,
                          reposts: item.reposts,
                          plays: item.plays,
                          comments: item.comments,
                          duration: item.duration,
                          waveformPeaks: item.waveformPeaks,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
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