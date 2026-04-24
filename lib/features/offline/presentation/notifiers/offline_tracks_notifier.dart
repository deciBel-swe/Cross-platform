import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../domain/usecases/get_offline_tracks_usecase.dart';

class OfflineTracksNotifier extends StateNotifier<AsyncValue<List<Track>>> {
  OfflineTracksNotifier(this._useCase) : super(const AsyncValue.loading());

  final GetOfflineTracksUseCase _useCase;

  Future<void> loadTracks() async {
    state = const AsyncValue.loading();
    final result = await _useCase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (tracks) {
        state = AsyncValue.data(tracks);
      },
    );
  }
}
