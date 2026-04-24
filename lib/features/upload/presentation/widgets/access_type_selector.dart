import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

class AccessTypeSelector extends ConsumerWidget {
  const AccessTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the current state to get the selected access type
    final access = ref.watch(
      uploadNotifierProvider.select(
        (state) => state.valueOrNull?.access ?? 'PLAYABLE',
      ),
    );

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
                label: Text('Playable', style: TextStyle(fontSize: 13)),
                icon: Icon(Icons.play_arrow),
              ),
              ButtonSegment(
                value: 'PREVIEW',
                label: Text('Preview', style: TextStyle(fontSize: 13)),
                icon: Icon(Icons.timer),
              ),
              ButtonSegment(
                value: 'BLOCKED',
                label: Text('Blocked', style: TextStyle(fontSize: 13)),
                icon: Icon(Icons.block),
              ),
            ],
            selected: {access},
            onSelectionChanged: (Set<String> newSelection) {
              if (newSelection.isEmpty) {
                return;
              }

              ref
                  .read(uploadNotifierProvider.notifier)
                  .updateAccess(newSelection.first);
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
          _getAccessDescription(access),
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }

  String _getAccessDescription(String access) {
    switch (access) {
      case 'PREVIEW':
        return 'Users can only listen to a 30-second preview of this track.';
      case 'BLOCKED':
        return 'This track is locked and cannot be played by others.';
      case 'PLAYABLE':
      default:
        return 'Anyone can play the full track.';
    }
  }
}
