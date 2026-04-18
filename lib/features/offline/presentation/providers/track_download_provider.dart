import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/usecases/download_track_usecase.dart';
import '../notifiers/track_download_notifier.dart';

final trackDownloadProvider =
    StateNotifierProvider<TrackDownloadNotifier, AsyncValue<String?>>((ref) {
  return TrackDownloadNotifier(getIt<DownloadTrackUseCase>());
});
