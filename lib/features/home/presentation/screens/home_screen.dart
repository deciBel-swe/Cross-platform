/// Desktop Home screen — SoundCloud-style with horizontal carousels.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Empty Home page – placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () {
              context.push('/home/upload');
            },
          ),
        ],
      ),
      body: const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Track carousel
// ─────────────────────────────────────────────────────────────────────────────

class _TrackCarousel extends StatelessWidget {
  const _TrackCarousel({required this.title, required this.tracks});

  final String title;
  final List<_MockTrack> tracks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: () {}),
        const SizedBox(height: AppDimensions.paddingMd),
        SizedBox(
          height: AppDimensions.trackCardSize + 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.paddingMd),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return TrackCard(
                title: track.title,
                artist: track.artist,
                gradientColors: track.colors,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────────────────────────────────────────

class _MockTrack {
  const _MockTrack({
    required this.title,
    required this.artist,
    required this.colors,
  });

  final String title;
  final String artist;
  final List<Color> colors;
}

const _recentlyPlayed = [
  _MockTrack(
    title: 'Midnight Drive',
    artist: 'SynthWave',
    colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
  ),
  _MockTrack(
    title: 'Golden Hour',
    artist: 'Lofi Beats',
    colors: [Color(0xFFF57F17), Color(0xFFFF6F00)],
  ),
  _MockTrack(
    title: 'Electric Dreams',
    artist: 'RetroFuture',
    colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
  ),
  _MockTrack(
    title: 'Ocean Breeze',
    artist: 'ChillHop',
    colors: [Color(0xFF00695C), Color(0xFF00897B)],
  ),
  _MockTrack(
    title: 'Neon Lights',
    artist: 'CityPop',
    colors: [Color(0xFFAD1457), Color(0xFFC2185B)],
  ),
  _MockTrack(
    title: 'Sunset Vibes',
    artist: 'Ambient',
    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
  ),
  _MockTrack(
    title: 'Cloud Nine',
    artist: 'DreamPop',
    colors: [Color(0xFF283593), Color(0xFF1565C0)],
  ),
  _MockTrack(
    title: 'Stargazer',
    artist: 'SpaceAmbient',
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  ),
];

const _trending = [
  _MockTrack(
    title: 'Bass Drop',
    artist: 'EDM Collective',
    colors: [Color(0xFFD50000), Color(0xFFFF1744)],
  ),
  _MockTrack(
    title: 'Summer Anthem',
    artist: 'PopVerse',
    colors: [Color(0xFFFF6D00), Color(0xFFFFAB00)],
  ),
  _MockTrack(
    title: 'Dark Matter',
    artist: 'TechnoLab',
    colors: [Color(0xFF212121), Color(0xFF424242)],
  ),
  _MockTrack(
    title: 'Feel Good Inc.',
    artist: 'IndieMix',
    colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
  ),
  _MockTrack(
    title: 'Rhythm & Soul',
    artist: 'FunkMaster',
    colors: [Color(0xFF4E342E), Color(0xFF795548)],
  ),
  _MockTrack(
    title: 'Crystal Clear',
    artist: 'AcousticLive',
    colors: [Color(0xFF0277BD), Color(0xFF039BE5)],
  ),
  _MockTrack(
    title: 'Wildfire',
    artist: 'RockSolid',
    colors: [Color(0xFFBF360C), Color(0xFFE64A19)],
  ),
  _MockTrack(
    title: 'After Midnight',
    artist: 'JazzLounge',
    colors: [Color(0xFF311B92), Color(0xFF512DA8)],
  ),
];

const _artists = [
  _MockTrack(
    title: 'New Single',
    artist: 'Aurora',
    colors: [Color(0xFF006064), Color(0xFF00838F)],
  ),
  _MockTrack(
    title: 'Live Session',
    artist: 'The Weeknd',
    colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
  ),
  _MockTrack(
    title: 'Remix Album',
    artist: 'Daft Punk',
    colors: [Color(0xFF827717), Color(0xFF9E9D24)],
  ),
  _MockTrack(
    title: 'Acoustic Set',
    artist: 'Bon Iver',
    colors: [Color(0xFF1A237E), Color(0xFF283593)],
  ),
  _MockTrack(
    title: 'EP Release',
    artist: 'Tame Impala',
    colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
  ),
  _MockTrack(
    title: 'Studio Album',
    artist: 'Radiohead',
    colors: [Color(0xFF263238), Color(0xFF37474F)],
  ),
  _MockTrack(
    title: 'B-Sides',
    artist: 'Gorillaz',
    colors: [Color(0xFF33691E), Color(0xFF558B2F)],
  ),
  _MockTrack(
    title: 'Deluxe Edition',
    artist: 'Billie Eilish',
    colors: [Color(0xFF3E2723), Color(0xFF5D4037)],
  ),
];

const _newReleases = [
  _MockTrack(
    title: 'Fresh Beats',
    artist: 'NewWave',
    colors: [Color(0xFF00BFA5), Color(0xFF1DE9B6)],
  ),
  _MockTrack(
    title: 'First Light',
    artist: 'DawnChorus',
    colors: [Color(0xFFFFD600), Color(0xFFFFEA00)],
  ),
  _MockTrack(
    title: 'Underground',
    artist: 'BassCulture',
    colors: [Color(0xFF37474F), Color(0xFF546E7A)],
  ),
  _MockTrack(
    title: 'Euphoria',
    artist: 'TranceState',
    colors: [Color(0xFF0091EA), Color(0xFF00B0FF)],
  ),
  _MockTrack(
    title: 'Raw',
    artist: 'PunkRock',
    colors: [Color(0xFFDD2C00), Color(0xFFFF3D00)],
  ),
  _MockTrack(
    title: 'Serenity',
    artist: 'ClassicalMix',
    colors: [Color(0xFF004D40), Color(0xFF00695C)],
  ),
  _MockTrack(
    title: 'Voltage',
    artist: 'ElectroHouse',
    colors: [Color(0xFFAA00FF), Color(0xFFD500F9)],
  ),
  _MockTrack(
    title: 'Soulful',
    artist: 'R&B Collection',
    colors: [Color(0xFF6D4C41), Color(0xFF8D6E63)],
  ),
];
