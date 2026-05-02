import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

enum TrackMoreOption {
  addToPlaylist,
  addToQueue,
  viewQueue,
  editTrack,
  goToArtist,
  goToAlbum,
  share,
  copyLink,
  download,
  deleteTrack,
  report,
}

/// Shows the responsive track more-options menu.
Future<TrackMoreOption?> showTrackMoreOptionsMenu({
  required BuildContext context,
  BuildContext? anchorContext,
  bool includeEdit = false,
  bool includeDelete = false,
  bool isPro = false,
}) {
  if (ResponsiveUtils.isDesktop(context)) {
    return showMenu<TrackMoreOption>(
      context: context,
      color: const Color(0xFF1F1F1F),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      position: _menuPosition(context: context, anchorContext: anchorContext),
      items: [
        _desktopTrackOptionItem(
          value: TrackMoreOption.addToPlaylist,
          icon: Icons.playlist_add_rounded,
          label: 'Add to playlist',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.addToQueue,
          icon: Icons.queue_music_rounded,
          label: 'Add to queue',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.viewQueue,
          icon: Icons.list_rounded,
          label: 'View queue',
        ),
        if (includeEdit)
          _desktopTrackOptionItem(
            value: TrackMoreOption.editTrack,
            icon: Icons.edit_outlined,
            label: 'Edit track',
          ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.goToArtist,
          icon: Icons.person_outline_rounded,
          label: 'Go to artist',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.goToAlbum,
          icon: Icons.album_rounded,
          label: 'Go to album',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.share,
          icon: Icons.share_outlined,
          label: 'Share',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.copyLink,
          icon: Icons.link_rounded,
          label: 'Copy link',
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.download,
          icon: Icons.download_rounded,
          label: 'Download',
          enabled: isPro,
        ),
        _desktopTrackOptionItem(
          value: TrackMoreOption.report,
          icon: Icons.flag_outlined,
          label: 'Report',
        ),
        if (includeDelete) const PopupMenuDivider(height: 8),
        if (includeDelete)
          _desktopTrackOptionItem(
            value: TrackMoreOption.deleteTrack,
            icon: Icons.delete_outline_rounded,
            label: 'Delete track',
            color: AppColors.errors,
          ),
      ],
    );
  }

  return showModalBottomSheet<TrackMoreOption>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppDimensions.paddingSm),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.addToPlaylist,
                  icon: Icons.playlist_add_rounded,
                  label: 'Add to playlist',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.addToQueue,
                  icon: Icons.queue_music_rounded,
                  label: 'Add to queue',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.viewQueue,
                  icon: Icons.list_rounded,
                  label: 'View queue',
                ),
                if (includeEdit)
                  _mobileTrackOptionItem(
                    sheetContext,
                    value: TrackMoreOption.editTrack,
                    icon: Icons.edit_outlined,
                    label: 'Edit track',
                  ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.goToArtist,
                  icon: Icons.person_outline_rounded,
                  label: 'Go to artist',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.goToAlbum,
                  icon: Icons.album_rounded,
                  label: 'Go to album',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.share,
                  icon: Icons.share_outlined,
                  label: 'Share',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.copyLink,
                  icon: Icons.link_rounded,
                  label: 'Copy link',
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.download,
                  icon: Icons.download_rounded,
                  label: 'Download',
                  enabled: isPro,
                ),
                _mobileTrackOptionItem(
                  sheetContext,
                  value: TrackMoreOption.report,
                  icon: Icons.flag_outlined,
                  label: 'Report',
                ),
                if (includeDelete)
                  _mobileTrackOptionItem(
                    sheetContext,
                    value: TrackMoreOption.deleteTrack,
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete track',
                    color: AppColors.errors,
                  ),
                SizedBox(height: MediaQuery.paddingOf(sheetContext).bottom + 8),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Calculates the desktop menu position from the anchor context.
RelativeRect _menuPosition({
  required BuildContext context,
  required BuildContext? anchorContext,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
  final anchor = anchorContext?.findRenderObject() as RenderBox?;
  if (overlay == null || anchor == null || !anchor.attached) {
    final size = MediaQuery.sizeOf(context);
    return RelativeRect.fromLTRB(size.width - 420, 96, 24, size.height - 96);
  }

  final topLeft = anchor.localToGlobal(Offset.zero, ancestor: overlay);
  final bottomRight = anchor.localToGlobal(
    anchor.size.bottomRight(Offset.zero),
    ancestor: overlay,
  );
  return RelativeRect.fromRect(
    Rect.fromPoints(topLeft, bottomRight),
    Offset.zero & overlay.size,
  );
}

/// Builds a desktop popup menu item for a track action.
PopupMenuItem<TrackMoreOption> _desktopTrackOptionItem({
  required TrackMoreOption value,
  required IconData icon,
  required String label,
  Color? color,
  bool enabled = true,
}) {
  final itemColor = !enabled
      ? AppColors.textHint
      : color ?? AppColors.textPrimary.withValues(alpha: 0.82);

  return PopupMenuItem<TrackMoreOption>(
    value: value,
    enabled: enabled,
    height: 52,
    child: SizedBox(
      width: 300,
      child: Row(
        children: [
          Icon(icon, color: itemColor, size: 24),
          const SizedBox(width: AppDimensions.paddingMd),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardTitle.copyWith(
                color: itemColor,
                fontSize: 16,
              ),
            ),
          ),
          if (!enabled)
            Icon(Icons.lock_outline_rounded, color: itemColor, size: 16),
        ],
      ),
    ),
  );
}

/// Builds a mobile bottom-sheet option for a track action.
Widget _mobileTrackOptionItem(
  BuildContext context, {
  required TrackMoreOption value,
  required IconData icon,
  required String label,
  Color? color,
  bool enabled = true,
}) {
  final itemColor = !enabled
      ? AppColors.textHint
      : color ?? AppColors.textSecondary;
  return ListTile(
    leading: Icon(icon, color: itemColor),
    title: Text(
      label,
      style: AppTextStyles.titleMedium.copyWith(color: itemColor),
    ),
    trailing: !enabled
        ? Icon(Icons.lock_outline_rounded, color: itemColor, size: 16)
        : null,
    enabled: enabled,
    onTap: enabled ? () => Navigator.of(context).pop(value) : null,
  );
}
