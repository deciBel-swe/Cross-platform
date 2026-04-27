import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist_details_provider.dart';
import '../providers/user_playlists_provider.dart';
import 'delete_playlist_dialog.dart';
import 'share_options_row.dart';

/// The bottom sheet for playlist actions.
class PlaylistOptionsBottomSheet extends ConsumerWidget {
  const PlaylistOptionsBottomSheet({
    super.key,
    required this.playlist,
    required this.parentContext,
  });

  final Playlist playlist;
  final BuildContext parentContext;

  /// Helper to easily show this bottom sheet from any screen.
  static void show(BuildContext context, Playlist playlist) {
    final parentContext = context;
    // ignore: inference_failure_on_function_invocation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PlaylistOptionsBottomSheet(
        playlist: playlist,
        parentContext: parentContext,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistDetails = ref
        .watch(playlistDetailsProvider(playlist.id))
        .valueOrNull;
    final currentPlaylist = playlistDetails ?? playlist;
    final authState = ref.watch(authStateProvider).valueOrNull;
    final rawOwnerUsername = currentPlaylist.owner?.username;
    final ownerUsername = rawOwnerUsername?.trim().toLowerCase();
    final isOwnPlaylist =
        authState is AuthAuthenticated &&
        (authState.user.id == currentPlaylist.owner?.id ||
            (ownerUsername != null &&
                authState.user.username.trim().toLowerCase() == ownerUsername));

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

                _Header(playlist: currentPlaylist),
                const SizedBox(height: 24),
                ShareOptionsRow(
                  onCopyLinkTap: () async {
                    return await ref
                        .read(
                          playlistDetailsProvider(currentPlaylist.id).notifier,
                        )
                        .fetchSecretLink();
                  },
                ),
                const SizedBox(height: 16),
                Divider(
                  color: AppColors.borderDark.withValues(alpha: 0.5),
                  height: 1,
                ),
                const SizedBox(height: 8),

                if (isOwnPlaylist) ...[
                  _ActionTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit playlist',
                    semanticHint: 'Open the playlist editor',
                    onTap: () {
                      context.pop();
                      parentContext.push(
                        RoutePaths.editPlaylist,
                        extra: currentPlaylist,
                      );
                    },
                  ),
                  _ActionTile(
                    icon: currentPlaylist.isPrivate
                        ? Icons.lock_open
                        : Icons.lock_outline,
                    title: currentPlaylist.isPrivate
                        ? 'Make public'
                        : 'Make private',
                    semanticHint: currentPlaylist.isPrivate
                        ? 'Set this playlist visibility to public'
                        : 'Set this playlist visibility to private',
                    onTap: () async {
                      final container = ProviderScope.containerOf(
                        parentContext,
                        listen: false,
                      );

                      context.pop();

                      final result = await container
                          .read(userPlaylistsProvider.notifier)
                          .togglePrivacy(currentPlaylist);

                      if (!parentContext.mounted) {
                        return;
                      }

                      result.fold(
                        (failure) {
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(
                              content: Text(failure.toString()),
                              backgroundColor: AppColors.errors,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        (updatedPlaylist) {
                          container
                              .read(
                                playlistDetailsProvider(
                                  updatedPlaylist.id,
                                ).notifier,
                              )
                              .updatePlaylistLocally(updatedPlaylist);

                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                updatedPlaylist.isPrivate
                                    ? 'Playlist is now private'
                                    : 'Playlist is now public',
                              ),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  _ActionTile(
                    icon: Icons.delete_outline,
                    title: 'Delete',
                    semanticHint: 'Delete this playlist permanently',
                    onTap: () {
                      context.pop();
                      DeletePlaylistDialog.show(parentContext, currentPlaylist);
                    },
                  ),
                ],
                const SizedBox(height: 8),
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
    final coverArt = playlist.coverArt?.trim();

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
            clipBehavior: Clip.hardEdge,
            child: coverArt != null && coverArt.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: _isRemote(coverArt)
                        ? DecibelCachedImage(
                            imageUrl: coverArt,
                            fit: BoxFit.cover,
                          )
                        : Image.file(File(coverArt), fit: BoxFit.cover),
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
                  playlist.owner!.username,
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

bool _isRemote(String path) {
  final uri = Uri.tryParse(path);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.semanticHint,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      hint: semanticHint,
      child: ListTile(
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
      ),
    );
  }
}
