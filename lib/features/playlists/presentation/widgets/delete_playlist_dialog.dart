import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import '../providers/user_playlists_provider.dart';

/// Dialog to confirm and execute the deletion of a playlist
class DeletePlaylistDialog extends ConsumerWidget {
  const DeletePlaylistDialog({super.key, required this.playlist});

  final Playlist playlist;

  static Future<void> show(BuildContext context, Playlist playlist) {
    return showDialog(
      context: context,
      builder: (context) => DeletePlaylistDialog(playlist: playlist),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete playlist'),
      content: const Text(
        'Are you sure you want to delete this playlist? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        TextButton(
          onPressed: () async {
            // Directly call the notifier managed by Riverpod
            final result = await ref
                .read(userPlaylistsProvider.notifier)
                .deletePlaylist(playlist.id);

            result.fold(
              (failure) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(failure.message),
                      backgroundColor: AppColors.errors,
                    ),
                  );
                }
              },
              (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Playlist deleted successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.pop();
                }
              },
            );
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.errors),
          ),
        ),
      ],
    );
  }
}
