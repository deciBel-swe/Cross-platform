import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/playlist.dart';
import 'user_playlists_provider.dart';

/// A StateProvider to hold the temporary dragged order before hitting Save
final pendingTracksProvider = StateProvider.autoDispose<List<int>?>(
  (ref) => null,
);
class PlaylistDetailsNotifier extends AutoDisposeFamilyAsyncNotifier<Playlist, int> {
  
  @override
  Future<Playlist> build(int arg) async {
    final repository = ref.watch(playlistRepositoryProvider);
    
    final result = await repository.getPlaylistDetails(arg);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (playlist) => playlist,
    );
  }

Future<Either<Failure, String>> fetchSecretLink() async {
    final repository = ref.read(playlistRepositoryProvider);
  
    return await repository.getPlaylistSecretLink(arg);
  }
}

final playlistDetailsProvider = AsyncNotifierProvider.autoDispose
    .family<PlaylistDetailsNotifier, Playlist, int>(
  PlaylistDetailsNotifier.new,
);