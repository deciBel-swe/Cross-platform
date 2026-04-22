import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track.dart';
import '../../domain/usecases/download_track_usecase.dart';

class TrackDownloadNotifier extends StateNotifier<AsyncValue<String?>> {
  TrackDownloadNotifier(this._downloadTrackUseCase)
      : super(const AsyncValue.data(null));

  final DownloadTrackUseCase _downloadTrackUseCase;

  Future<void> downloadTrack(Track track) async {
    state = const AsyncValue.loading();
    final result = await _downloadTrackUseCase.execute(track);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (path) {
        state = AsyncValue.data(path);
      },
    );
  }
}
