import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../providers/history_provider.dart';

class RecentlyPlayedSection extends ConsumerWidget {
  const RecentlyPlayedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recently Played',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => context.push(RoutePaths.recentlyPlayed),
            child: const Text('See all'),
          ),
        ],
      ),
    ),
    const SizedBox(height: 12),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Failed to load recently played.\n$error',
        style: const TextStyle(color: Colors.white70),
      ),
    ),
  ],
),
      data: (tracks) {
        if (tracks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Played',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(RoutePaths.recentlyPlayed),
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tracks.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final track = tracks[index];

                  final artistName =
                      track.artist.displayName?.trim().isNotEmpty == true
                      ? track.artist.displayName!
                      : track.artist.username;

                  return GestureDetector(
                    onTap: () async {
                      final url = track.trackUrl;
                      if (url == null || url.isEmpty) {
                        return;
                      }

                      await ref
                          .read(trackAudioProvider.notifier)
                          .initializeForTrack(
                            trackId: track.id,
                            trackUrl: url,
                            track: track,
                            queue: tracks,
                            autoPlay: true,
                          );
                    },
                    child: SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: track.coverUrl != null &&
                                    track.coverUrl!.isNotEmpty
                                ? Image.network(
                                    track.coverUrl!,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.white10,
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 140,
                                    height: 140,
                                    color: Colors.white10,
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white70,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}