import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/widgets/create_playlist_bottom_sheet.dart';
import '../../domain/entities/track.dart';
import '../providers/add_to_playlist_provider.dart';
import '../providers/user_playlists_provider.dart';

class AddToPlaylistScreen extends ConsumerWidget {
  const AddToPlaylistScreen({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(userPlaylistsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Add track to playlist screen',
      scopesRoute: true,
      namesRoute: true,

      explicitChildNodes: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Semantics(
            button: true,
            label: 'Go back',
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          title: Semantics(
            header: true,
            child: Text(
              'Add to playlist',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: playlistsAsync.when(
          loading: () => Semantics(
            label: 'Loading playlists',
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Semantics(
            label: 'Error loading playlists',
            child: Center(
              child: Text(
                'Error loading playlists.\n$error',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
          data: (playlists) =>
              _PlaylistListView(playlists: playlists, track: track),
        ),
      ),
    );
  }
}

class _PlaylistListView extends StatelessWidget {
  const _PlaylistListView({required this.playlists, required this.track});

  final List<Playlist> playlists;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Playlists list',
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        children: [
          const _CreatePlaylistButton(),
          const SizedBox(height: AppConstants.spacingMedium),
          ...playlists.map(
            (playlist) => _PlaylistItem(
              key: ValueKey(playlist.id),
              playlist: playlist,
              track: track,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePlaylistButton extends StatelessWidget {
  const _CreatePlaylistButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: 'Create a new playlist',
      child: InkWell(
        onTap: () {
          CreatePlaylistBottomSheet.show(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingSmall,
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.onPrimary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'Create playlist',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistItem extends ConsumerWidget {
  const _PlaylistItem({super.key, required this.playlist, required this.track});

  final Playlist playlist;
  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isAlreadyAdded = playlist.tracks.any((t) => t.id == track.id);
    final trackCount = playlist.tracks.length;

    return Semantics(
      button: !isAlreadyAdded,
      enabled: !isAlreadyAdded,
      label: isAlreadyAdded
          ? '${playlist.title}, playlist, $trackCount tracks, track already added'
          : '${playlist.title}, playlist, $trackCount tracks, tap to add track',
      child: InkWell(
        onTap: () async {
          if (isAlreadyAdded) return;

          final notifier = ref.read(addToPlaylistProvider.notifier);
          final success = await notifier.addTrack(
            playlistId: playlist.id,
            trackId: track.id,
            track: track,
          );

          if (!context.mounted) return;

          if (success) {
            ref.invalidate(userPlaylistsProvider);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Track added to ${playlist.title}')),
            );
            context.pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to add track. Please try again.'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingSmall,
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Playlist · ${playlist.tracks.length} Track${playlist.tracks.length == 1 ? '' : 's'}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isAlreadyAdded)
                Semantics(
                  label: 'Track already added',
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.onPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
