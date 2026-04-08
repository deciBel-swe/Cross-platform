import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/user_playlists_provider.dart';
import '../widgets/playlist_action_buttons.dart';
import '../widgets/playlist_tile.dart';

/// Main screen displaying the user's playlists
class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(userPlaylistsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Playlists',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const PlaylistActionButtons(),
            const SizedBox(height: 24),
            Expanded(
              child: playlistsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load playlists.\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.errors),
                  ),
                ),
                data: (playlists) {
                  if (playlists.isEmpty) {
                    return const Center(
                      child: Text(
                        'No playlists yet. Create one above!',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      // Added ValueKey for dynamic lists
                      return InkWell(
                        key: ValueKey(playlist.id),
                        onTap: () {
                          context.push(
                            RoutePaths.playlistTracks,
                            extra: playlist,
                          );
                        },
                        child: PlaylistTile(playlist: playlist),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
