import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/i_feed_repository.dart';

/// Bridges the Injectable singleton into the Riverpod world.
final feedRepositoryProvider = Provider<IFeedRepository>(
  (ref) => getIt<IFeedRepository>(),
);
