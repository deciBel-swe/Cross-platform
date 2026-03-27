import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/i_track_comments_repository.dart';

final commentRepositoryProvider = Provider<ITrackCommentsRepository>((ref) {
  return getIt<ITrackCommentsRepository>();
});
