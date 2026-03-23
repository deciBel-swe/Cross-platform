import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../providers/track_provider.dart';

class UserTracksNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Track>, int> {
  @override
  FutureOr<List<Track>> build(int arg) async {
    // 'arg' is the userId passed from the UI
    return _fetchUserTracks(arg);
  }

  Future<List<Track>> _fetchUserTracks(int userId) async {
    final repository = ref.watch(trackRepositoryProvider);

    final result = await repository.fetchTracks(
      userId: userId,
      page: 0,
      size: 20,
    );

    return result.fold((failure) {
      throw Exception(failure.message);
    }, (paginated) => paginated.content);
  }

  // Helper method for "Pull to Refresh" in the UI
  Future<void> refresh() async {
    // Set state back to loading to show the spinner
    state = const AsyncLoading();

    // AsyncValue.guard safely executes the future and handles any
    // exceptions (like the one we throw in our fold above)
    state = await AsyncValue.guard(() => _fetchUserTracks(arg));
  }
}

// ---------------------------------------------------------
// The Provider to watch in your UI
// ---------------------------------------------------------
final userTracksProvider = AsyncNotifierProvider.autoDispose
    .family<UserTracksNotifier, List<Track>, int>(UserTracksNotifier.new);
