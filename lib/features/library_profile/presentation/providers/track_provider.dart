import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart'; // Assuming you use get_it with injectable

import '../../domain/repositories/track_repository.dart';

// Grabs the injectable instance of your repository
final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  return GetIt.instance<TrackRepository>();
});