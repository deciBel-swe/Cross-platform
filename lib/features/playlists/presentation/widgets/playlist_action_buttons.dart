import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'create_playlist_bottom_sheet.dart';

/// Row of action buttons for creating new playlists.
class PlaylistActionButtons extends StatelessWidget {
  const PlaylistActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => CreatePlaylistBottomSheet.show(context),
            icon: const Icon(Icons.add, color: AppColors.textPrimary, size: 20),
            label: const Text(
              'Create new',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.borderDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
