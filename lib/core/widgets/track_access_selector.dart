import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TrackAccessSelector extends StatelessWidget {
  const TrackAccessSelector({
    super.key,
    required this.selectedAccess,
    required this.onAccessChanged,
  });

  /// The currently active access level (e.g., 'PLAYABLE', 'PREVIEW', 'BLOCKED').
  final String selectedAccess;

  /// Callback fired when the user selects a new option.
  final ValueChanged<String> onAccessChanged;

  @override
  Widget build(BuildContext context) {
    final normalizedAccess = _normalizeAccess(selectedAccess);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Track Access',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'PLAYABLE',
                label: Text('Playable', style: TextStyle(fontSize: 11)),
                icon: Icon(Icons.play_arrow),
              ),
              ButtonSegment(
                value: 'PREVIEW',
                label: Text('Preview', style: TextStyle(fontSize: 11)),
                icon: Icon(Icons.timer),
              ),
              ButtonSegment(
                value: 'BLOCKED',
                label: Text('Blocked', style: TextStyle(fontSize: 11)),
                icon: Icon(Icons.block),
              ),
            ],
            selected: {normalizedAccess},
            onSelectionChanged: (Set<String> newSelection) {
              if (newSelection.isNotEmpty) {
                onAccessChanged(newSelection.first);
              }
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: Colors.white70,
              selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
              selectedForegroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getAccessDescription(normalizedAccess),
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }

  String _getAccessDescription(String access) {
    switch (access) {
      case 'PREVIEW':
        return 'Users can only listen to a 10-second preview of this track.';
      case 'BLOCKED':
        return 'This track is locked and cannot be played by others.';
      case 'PLAYABLE':
      default:
        return 'Anyone can play the full track.';
    }
  }

  String _normalizeAccess(String access) {
    final normalized = access.trim().toUpperCase();
    const allowed = <String>{'PLAYABLE', 'PREVIEW', 'BLOCKED'};

    if (allowed.contains(normalized)) {
      return normalized;
    }

    return 'PLAYABLE';
  }
}
