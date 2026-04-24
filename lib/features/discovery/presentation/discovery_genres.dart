import 'package:flutter/material.dart';

/// Curated discovery genres with reusable gradients for search and home.
class DiscoveryGenreOption {
  const DiscoveryGenreOption({
    required this.label,
    required this.colors,
  });

  final String label;
  final List<Color> colors;
}

const List<DiscoveryGenreOption> discoveryGenreOptions =
    <DiscoveryGenreOption>[
      DiscoveryGenreOption(
        label: 'Electronic',
        colors: <Color>[Color(0xFFFF6A00), Color(0xFFFF3D00)],
      ),
      DiscoveryGenreOption(
        label: 'Hip-Hop',
        colors: <Color>[Color(0xFFFF7043), Color(0xFFD84315)],
      ),
      DiscoveryGenreOption(
        label: 'Pop',
        colors: <Color>[Color(0xFFFF8A65), Color(0xFFFF5252)],
      ),
      DiscoveryGenreOption(
        label: 'Ambient',
        colors: <Color>[Color(0xFF26A69A), Color(0xFF00695C)],
      ),
      DiscoveryGenreOption(
        label: 'Rock',
        colors: <Color>[Color(0xFF8D6E63), Color(0xFF4E342E)],
      ),
      DiscoveryGenreOption(
        label: 'House',
        colors: <Color>[Color(0xFFFFB74D), Color(0xFFF57C00)],
      ),
      DiscoveryGenreOption(
        label: 'Lo-Fi',
        colors: <Color>[Color(0xFF78909C), Color(0xFF455A64)],
      ),
      DiscoveryGenreOption(
        label: 'R&B',
        colors: <Color>[Color(0xFFBA68C8), Color(0xFF7B1FA2)],
      ),
      DiscoveryGenreOption(
        label: 'Jazz',
        colors: <Color>[Color(0xFFFFCC80), Color(0xFFEF6C00)],
      ),
      DiscoveryGenreOption(
        label: 'Classical',
        colors: <Color>[Color(0xFF90A4AE), Color(0xFF546E7A)],
      ),
      DiscoveryGenreOption(
        label: 'Indie',
        colors: <Color>[Color(0xFFA5D6A7), Color(0xFF2E7D32)],
      ),
      DiscoveryGenreOption(
        label: 'Latin',
        colors: <Color>[Color(0xFFFFAB91), Color(0xFFE64A19)],
      ),
    ];
