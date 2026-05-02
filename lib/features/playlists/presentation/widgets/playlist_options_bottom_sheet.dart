import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist_details_provider.dart';
import '../providers/user_playlists_provider.dart';
import 'delete_playlist_dialog.dart';
import 'share_options_row.dart';

/// The bottom sheet for playlist actions.
class PlaylistOptionsBottomSheet extends ConsumerWidget {
  const PlaylistOptionsBottomSheet({super.key, required this.playlist});

  final Playlist playlist;

  /// Helper to easily show this bottom sheet from any screen.
  static void show(BuildContext context, Playlist playlist) {
    // ignore: inference_failure_on_function_invocation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PlaylistOptionsBottomSheet(playlist: playlist),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      snap: true,
      snapSizes: const [0.6, 0.85],
      builder: (context, scrollController) {
        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              // Close the sheet when dragged to the minimum size
              if (notification.extent <= notification.minExtent) {
                Navigator.of(context).pop();
              }
              return true;
            },
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                _Header(playlist: playlist),
                const SizedBox(height: 24),
                ShareOptionsRow(
                  onCopyLinkTap: () async {
                    return await ref
                        .read(playlistDetailsProvider(playlist.id).notifier)
                        .fetchSecretLink();
                  },
                ),
                const SizedBox(height: 16),
                Divider(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                  height: 1,
                ),
                const SizedBox(height: 8),

                // Actions List
                _ActionTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit',
                  onTap: () {
                    context.pop();
                    context.push(RoutePaths.editPlaylist, extra: playlist);
                  },
                ),
                _ActionTile(
                  icon: playlist.isPrivate
                      ? Icons.lock_open
                      : Icons.lock_outline,
                  title: playlist.isPrivate ? 'Make public' : 'Make private',
                  onTap: () async {
                    context.pop();

                    // 1. Directly call the notifier managed by Riverpod
                    final result = await ref
                        .read(userPlaylistsProvider.notifier)
                        .togglePrivacy(playlist);

                    // 2. Handle the snackbar
                    result.fold(
                      (failure) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(failure.toString()),
                              backgroundColor: AppColors.errors,
                            ),
                          );
                        }
                      },
                      (updatedPlaylist) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                updatedPlaylist.isPrivate
                                    ? 'Playlist is now private'
                                    : 'Playlist is now public',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.add_box_outlined,
                  title: 'Add music',
                  onTap: () {
                    // TODO: Implement add music logic
                  },
                ),
                _ActionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete',
                  onTap: () {
                    context.pop();
                    DeletePlaylistDialog.show(context, playlist);
                  },
                ),
                const SizedBox(height: 8),
                Divider(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                  height: 1,
                ),
                const SizedBox(height: 8),

                _ActionTile(
                  icon: Icons.playlist_play,
                  title: 'Play Next',
                  onTap: () {
                    // TODO: Implement play next logic
                  },
                ),
                _ActionTile(
                  icon: Icons.playlist_add,
                  title: 'Play Last',
                  onTap: () {
                    // TODO: Implement play last logic
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: playlist.coverArt != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(
                      File(playlist.coverArt!),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.music_note,
                    color: AppColors.textMuted,
                    size: 32,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  playlist.owner.username,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0,
      ),
    );
  }
}
