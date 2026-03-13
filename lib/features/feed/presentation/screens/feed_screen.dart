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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        children: [
          Text('Your Feed', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.paddingSm),
          Text(
            'Hear the latest from people you follow.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.paddingLg),
          ..._mockFeedItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
              child: FeedItem(
                userName: item.userName,
                action: item.action,
                trackTitle: item.trackTitle,
                trackArtist: item.trackArtist,
                timeAgo: item.timeAgo,
                gradientColors: item.colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Mock data ----

class _MockFeed {
  const _MockFeed({
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.colors,
  });

  final String userName;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final List<Color> colors;
}

const _mockFeedItems = [
  _MockFeed(userName: 'Aurora', action: 'uploaded a new track', trackTitle: 'Northern Lights', trackArtist: 'Aurora', timeAgo: '2h', colors: [Color(0xFF006064), Color(0xFF00838F)]),
  _MockFeed(userName: 'SynthWave', action: 'reposted', trackTitle: 'Midnight Drive', trackArtist: 'RetroFuture', timeAgo: '3h', colors: [Color(0xFF1A237E), Color(0xFF0D47A1)]),
  _MockFeed(userName: 'ChillHop', action: 'liked', trackTitle: 'Ocean Breeze', trackArtist: 'LoFi Beats', timeAgo: '5h', colors: [Color(0xFF00695C), Color(0xFF00897B)]),
  _MockFeed(userName: 'EDM Collective', action: 'uploaded a new track', trackTitle: 'Bass Drop 2.0', trackArtist: 'EDM Collective', timeAgo: '8h', colors: [Color(0xFFD50000), Color(0xFFFF1744)]),
  _MockFeed(userName: 'JazzLounge', action: 'reposted', trackTitle: 'After Midnight Session', trackArtist: 'Smooth Jazz Trio', timeAgo: '12h', colors: [Color(0xFF311B92), Color(0xFF512DA8)]),
  _MockFeed(userName: 'IndieMix', action: 'liked', trackTitle: 'Feel Good Inc.', trackArtist: 'IndieMix', timeAgo: '1d', colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)]),
  _MockFeed(userName: 'TechnoLab', action: 'uploaded a new track', trackTitle: 'Dark Matter v2', trackArtist: 'TechnoLab', timeAgo: '1d', colors: [Color(0xFF212121), Color(0xFF424242)]),
  _MockFeed(userName: 'Bon Iver', action: 'reposted', trackTitle: 'Skinny Love Remix', trackArtist: 'FanArtist', timeAgo: '2d', colors: [Color(0xFF1A237E), Color(0xFF283593)]),
];
