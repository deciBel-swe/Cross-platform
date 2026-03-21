import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/genre_repository.dart';

  final allGenreRepositoryProvider = Provider<AllGenresRepository>((ref) {
  return getIt<AllGenresRepository>(); // This must match exactly!
});