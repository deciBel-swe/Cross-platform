import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../library/domain/entities/artist.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_status.dart';
import '../../domain/repositories/history_repository.dart';

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<Track>>>(
  (ref) => HistoryNotifier(getIt<HistoryRepository>()),
);

class HistoryNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  final HistoryRepository _repository;

  Future<void> fetchHistory() async {
    state = const AsyncValue.loading();

    final result = await _repository.getListeningHistory();

    result.fold(
      (_) => state = AsyncValue.data(_mockHistoryTracks()),
      (tracks) => state = AsyncValue.data(tracks),
    );
  }

  void addLocalRecentlyPlayed(Track track) {
    final current = state.valueOrNull ?? <Track>[];

    final updated = <Track>[
      track,
      ...current.where((item) => item.id != track.id),
    ];

    state = AsyncValue.data(updated);
  }

  List<Track> _mockHistoryTracks() {
    final now = DateTime.now();

    return [
      Track(
        id: 9001,
        title: 'Rebirth of the Phoenix',
        artist: const Artist(
          id: 501,
          username: 'thrillian_ai',
          displayName: 'Thrillian & AI',
          avatarUrl: null,
        ),
        trackUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        coverUrl:
            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600',
        waveformUrl: null,
        genre: 'Rock',
        tags: const ['rock'],
        state: TrackStatus.finished,
        releaseDate: now,
        playCount: 120,
        likeCount: 42,
        repostCount: 8,
        isLiked: false,
        isReposted: false,
        createdAt: now,
      ),
      Track(
        id: 9002,
        title: 'Sleep Won’t Save The Thing',
        artist: const Artist(
          id: 502,
          username: 'silentattwelve',
          displayName: 'Silent at Twelve',
          avatarUrl: null,
        ),
        trackUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        coverUrl:
            'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=600',
        waveformUrl: null,
        genre: 'Indie',
        tags: const ['indie'],
        state: TrackStatus.finished,
        releaseDate: now,
        playCount: 88,
        likeCount: 31,
        repostCount: 4,
        isLiked: true,
        isReposted: false,
        createdAt: now,
      ),
      Track(
        id: 9003,
        title: 'When I Still Loved You',
        artist: const Artist(
          id: 503,
          username: 'drixy',
          displayName: 'DRIXY',
          avatarUrl: null,
        ),
        trackUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        coverUrl:
            'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=600',
        waveformUrl: null,
        genre: 'Pop',
        tags: const ['pop'],
        state: TrackStatus.finished,
        releaseDate: now,
        playCount: 211,
        likeCount: 67,
        repostCount: 13,
        isLiked: false,
        isReposted: true,
        createdAt: now,
      ),
      Track(
        id: 9004,
        title: 'Buzzing Pop',
        artist: const Artist(
          id: 504,
          username: 'novix',
          displayName: 'NOVIX',
          avatarUrl: null,
        ),
        trackUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        coverUrl:
            'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=600',
        waveformUrl: null,
        genre: 'Pop',
        tags: const ['pop'],
        state: TrackStatus.finished,
        releaseDate: now,
        playCount: 300,
        likeCount: 95,
        repostCount: 20,
        isLiked: false,
        isReposted: false,
        createdAt: now,
      ),
    ];
  }
}