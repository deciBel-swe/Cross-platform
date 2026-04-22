import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/usecases/get_offline_tracks_usecase.dart';
import '../notifiers/offline_tracks_notifier.dart';

final offlineTracksProvider =
    StateNotifierProvider.autoDispose<
      OfflineTracksNotifier,
      AsyncValue<List<Track>>
    >((ref) {
      return OfflineTracksNotifier(getIt<GetOfflineTracksUseCase>())
        ..loadTracks();
    });
