import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../data/repositories/track_comments_repository.dart';

final commentRepositoryProvider = Provider<TrackCommentsRepository>((ref) {
  return getIt<TrackCommentsRepository>();
});
