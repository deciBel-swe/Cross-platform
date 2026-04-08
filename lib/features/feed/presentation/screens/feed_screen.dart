/// Desktop Feed screen — activity timeline.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/feed_item.dart';

/// Activity feed showing recent actions from followed users.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(centerTitle: true, title: const _MobileFeedTabs()),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
          isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
          isDesktop ? AppDimensions.paddingLg : AppDimensions.paddingMd,
          AppDimensions.paddingLg,
        ),
        children: [
          if (isDesktop) ...[
            const Text('Your Feed', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.paddingSm),
            const Text(
              'Hear the latest from people you follow.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.paddingLg),
          ],
          ..._mockFeedItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
              child: FeedItem(
                trackId: item.id,
                userName: item.userName,
                action: item.action,
                trackTitle: item.trackTitle,
                trackArtist: item.trackArtist,
                timeAgo: item.timeAgo,
                genre: item.genre,
                likeCount: item.likeCount,
                repostCount: item.repostCount,
                isLiked: item.isLiked,
                isReposted: item.isReposted,
                plays: item.plays,
                commentCount: item.commentCount,
                duration: item.duration,
                waveformPeaks: item.waveformPeaks,
                gradientColors: item.colors,
              ),
            ),
          ),
        ],
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

// ---- Mock data ----

class _MockFeed {
  _MockFeed({
    required this.id,
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.genre,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.plays,
    required this.commentCount,
    required this.duration,
    required this.colors,
  }) : waveformPeaks = _buildMockPeaks(seed: '$userName$trackTitle'.hashCode);

  final int id;
  final String userName;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final String genre;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final String plays;
  final int commentCount;
  final String duration;
  final List<Color> colors;
  final List<double> waveformPeaks;
}

final _mockFeedItems = [
  _MockFeed(
    id: 101,
    userName: 'Bad-Bunny',
    action: 'posted a track',
    trackTitle: 'Super Bowl LX Halftime Show (Live)',
    trackArtist: 'Bad Bunny, NFL',
    timeAgo: '1 month ago',
    genre: 'Latin',
    likeCount: 6877,
    repostCount: 296,
    isLiked: false,
    isReposted: false,
    plays: '162K',
    commentCount: 718,
    duration: '13:41',
    colors: [const Color(0xFF1E88E5), const Color(0xFFF4511E)],
  ),
  _MockFeed(
    id: 102,
    userName: 'Gunna',
    action: 'posted a track',
    trackTitle: 'wgft (Remix) [feat. Chris Brown]',
    trackArtist: 'Gunna',
    timeAgo: '2 months ago',
    genre: 'Rap/Hip Hop',
    likeCount: 17900,
    repostCount: 144,
    isLiked: true,
    isReposted: false,
    plays: '705K',
    commentCount: 195,
    duration: '3:07',
    colors: [const Color(0xFF3E2723), const Color(0xFF6D4C41)],
  ),
  _MockFeed(
    id: 103,
    userName: 'Gunna',
    action: 'posted a track',
    trackTitle: 'at my purest (feat. Offset)',
    trackArtist: 'Gunna',
    timeAgo: '7 months ago',
    genre: 'Rap/Hip Hop',
    likeCount: 26200,
    repostCount: 182,
    isLiked: false,
    isReposted: true,
    plays: '1.52M',
    commentCount: 230,
    duration: '3:13',
    colors: [const Color(0xFF37474F), const Color(0xFF263238)],
  ),
];

List<double> _buildMockPeaks({required int seed, int count = 220}) {
  final baseSeed = seed.abs() + 17;
  return List<double>.generate(count, (index) {
    final rawValue = ((baseSeed + (index * 37)) % 100) / 100;
    final folded = rawValue <= 0.5 ? rawValue : (1 - rawValue);
    return (folded * 1.8).clamp(0.06, 1.0);
  });
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
