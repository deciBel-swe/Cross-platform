import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../presentation/providers/history_provider.dart';

class RecentlyPlayedScreen extends ConsumerWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: const Text(
          'Recently Played',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load recently played.\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(
              child: Text(
                'No recently played tracks yet.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: tracks.length,
            separatorBuilder: (_, _) => const Divider(
              color: Colors.white12,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final track = tracks[index];
              final artistName =
                  track.artist.displayName?.trim().isNotEmpty == true
                  ? track.artist.displayName!
                  : track.artist.username;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                      ? Image.network(
                          track.coverUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 56,
                            height: 56,
                            color: Colors.white10,
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white70,
                            ),
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: Colors.white10,
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white70,
                          ),
                        ),
                ),
                title: Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                onTap: () async {
                  final url = track.trackUrl;
                  if (url == null || url.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This track is not available for playback.'),
                      ),
                    );
                    return;
                  }

                  await ref.read(trackAudioProvider.notifier).initializeForTrack(
                    trackId: track.id,
                    trackUrl: url,
                    track: track,
                    queue: tracks,
                    autoPlay: true,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}