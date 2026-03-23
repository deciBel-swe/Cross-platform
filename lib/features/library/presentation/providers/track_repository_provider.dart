import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/track_repository.dart';

final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  return getIt<TrackRepository>();
});
