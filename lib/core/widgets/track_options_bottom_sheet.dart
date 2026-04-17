import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Action types for track options bottom sheet.
enum TrackOptionsAction { queue, edit, addToPlaylist, cancel }

/// Shows a consistent bottom sheet with track options.
///
/// Returns the selected [TrackOptionsAction] or null if dismissed.
Future<TrackOptionsAction?> showTrackOptionsBottomSheet({
  required BuildContext context,
  required bool isOwner,
  VoidCallback? onAddToPlaylist,
  VoidCallback? onQueue,
}) async {
  return showModalBottomSheet<TrackOptionsAction>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _OptionTile(
                icon: Icons.queue_music,
                label: 'Queue',
                onTap: () {
                  Navigator.of(sheetContext).pop(TrackOptionsAction.queue);
                },
              ),
              if (isOwner)
                _OptionTile(
                  icon: Icons.edit,
                  label: 'Edit track',
                  onTap: () {
                    Navigator.of(sheetContext).pop(TrackOptionsAction.edit);
                  },
                ),
              _OptionTile(
                icon: Icons.playlist_add,
                label: 'Add to playlist',
                onTap: () {
                  Navigator.of(sheetContext).pop(TrackOptionsAction.addToPlaylist);
                },
              ),
              const Divider(height: 1, color: Colors.white12),
              _OptionTile(
                icon: Icons.close,
                label: 'Cancel',
                isCancel: true,
                onTap: () {
                  Navigator.of(sheetContext).pop(TrackOptionsAction.cancel);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isCancel = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isCancel;

  @override
  Widget build(BuildContext context) {
    final color = isCancel ? Colors.white70 : AppColors.onPrimary;

    return ListTile(
      leading: Icon(icon, color: color, size: AppConstants.iconSizeMedium),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: color),
      ),
      onTap: onTap,
    );
  }
}
