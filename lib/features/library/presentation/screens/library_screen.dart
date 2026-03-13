/// Desktop Library screen — tabbed view (Likes, Playlists, Albums, Following).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/library_list_tile.dart';

/// Library page with tabbed content sections.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.paddingLg,
                right: AppDimensions.paddingLg,
                top: AppDimensions.paddingLg,
              ),
              child: Text('Your Library', style: AppTextStyles.sectionTitle),
            ),
            const SizedBox(height: AppDimensions.paddingMd),

            // ---- Tab bar ----
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLg,
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primary,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                dividerHeight: 0.5,
                dividerColor: AppColors.divider,
                tabs: [
                  Tab(text: 'Likes'),
                  Tab(text: 'Playlists'),
                  Tab(text: 'Albums'),
                  Tab(text: 'Following'),
                ],
              ),
            ),

            // ---- Tab content ----
            Expanded(
              child: TabBarView(
                children: [
                  _LikesTab(),
                  _PlaylistsTab(),
                  _AlbumsTab(),
                  _FollowingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab content
// ─────────────────────────────────────────────────────────────────────────────

class _LikesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: _likedTracks.length,
      itemBuilder: (context, index) {
        final track = _likedTracks[index];
        return LibraryListTile(
          title: track.title,
          subtitle: track.subtitle,
          gradientColors: track.colors,
          trailing: const Icon(
            Icons.favorite,
            color: AppColors.primary,
            size: 20,
          ),
        );
      },
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return LibraryListTile(
          title: playlist.title,
          subtitle: playlist.subtitle,
          gradientColors: playlist.colors,
          trailing: const Icon(
            Icons.playlist_play,
            color: AppColors.textSecondary,
            size: 24,
          ),
        );
      },
    );
  }
}

class _AlbumsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return LibraryListTile(
          title: album.title,
          subtitle: album.subtitle,
          gradientColors: album.colors,
          trailing: const Icon(
            Icons.album,
            color: AppColors.textSecondary,
            size: 20,
          ),
        );
      },
    );
  }
}

class _FollowingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      itemCount: _following.length,
      itemBuilder: (context, index) {
        final artist = _following[index];
        return LibraryListTile(
          title: artist.title,
          subtitle: artist.subtitle,
          gradientColors: artist.colors,
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.outline),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('Following'),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────────────────────────────────────────

class _MockItem {
  const _MockItem({
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final List<Color> colors;
}

const _likedTracks = [
  _MockItem(title: 'Midnight Drive', subtitle: 'SynthWave', colors: [Color(0xFF1A237E), Color(0xFF0D47A1)]),
  _MockItem(title: 'Golden Hour', subtitle: 'Lofi Beats', colors: [Color(0xFFF57F17), Color(0xFFFF6F00)]),
  _MockItem(title: 'Bass Drop', subtitle: 'EDM Collective', colors: [Color(0xFFD50000), Color(0xFFFF1744)]),
  _MockItem(title: 'Ocean Breeze', subtitle: 'ChillHop', colors: [Color(0xFF00695C), Color(0xFF00897B)]),
  _MockItem(title: 'Electric Dreams', subtitle: 'RetroFuture', colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)]),
  _MockItem(title: 'Feel Good Inc.', subtitle: 'IndieMix', colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)]),
  _MockItem(title: 'After Midnight', subtitle: 'JazzLounge', colors: [Color(0xFF311B92), Color(0xFF512DA8)]),
  _MockItem(title: 'Neon Lights', subtitle: 'CityPop', colors: [Color(0xFFAD1457), Color(0xFFC2185B)]),
];

const _playlists = [
  _MockItem(title: 'Chill Vibes', subtitle: '42 tracks', colors: [Color(0xFF006064), Color(0xFF00838F)]),
  _MockItem(title: 'Workout Fuel', subtitle: '28 tracks', colors: [Color(0xFFD50000), Color(0xFFFF1744)]),
  _MockItem(title: 'Late Night Jazz', subtitle: '35 tracks', colors: [Color(0xFF311B92), Color(0xFF512DA8)]),
  _MockItem(title: 'Road Trip', subtitle: '56 tracks', colors: [Color(0xFFE65100), Color(0xFFFF6D00)]),
  _MockItem(title: 'Focus Flow', subtitle: '19 tracks', colors: [Color(0xFF33691E), Color(0xFF558B2F)]),
  _MockItem(title: 'Party Mix', subtitle: '67 tracks', colors: [Color(0xFFAD1457), Color(0xFFC2185B)]),
];

const _albums = [
  _MockItem(title: 'Currents', subtitle: 'Tame Impala · 2015', colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)]),
  _MockItem(title: 'In Rainbows', subtitle: 'Radiohead · 2007', colors: [Color(0xFFBF360C), Color(0xFFE64A19)]),
  _MockItem(title: 'Random Access Memories', subtitle: 'Daft Punk · 2013', colors: [Color(0xFF827717), Color(0xFF9E9D24)]),
  _MockItem(title: 'For Emma, Forever Ago', subtitle: 'Bon Iver · 2007', colors: [Color(0xFF1A237E), Color(0xFF283593)]),
  _MockItem(title: 'Plastic Beach', subtitle: 'Gorillaz · 2010', colors: [Color(0xFF00695C), Color(0xFF00897B)]),
];

const _following = [
  _MockItem(title: 'Aurora', subtitle: '1.2M followers', colors: [Color(0xFF006064), Color(0xFF00838F)]),
  _MockItem(title: 'Tame Impala', subtitle: '4.5M followers', colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)]),
  _MockItem(title: 'Radiohead', subtitle: '3.8M followers', colors: [Color(0xFF263238), Color(0xFF37474F)]),
  _MockItem(title: 'Bon Iver', subtitle: '2.1M followers', colors: [Color(0xFF1A237E), Color(0xFF283593)]),
  _MockItem(title: 'Billie Eilish', subtitle: '7.3M followers', colors: [Color(0xFF3E2723), Color(0xFF5D4037)]),
  _MockItem(title: 'The Weeknd', subtitle: '8.9M followers', colors: [Color(0xFF880E4F), Color(0xFFAD1457)]),
  _MockItem(title: 'Gorillaz', subtitle: '3.2M followers', colors: [Color(0xFF33691E), Color(0xFF558B2F)]),
];
