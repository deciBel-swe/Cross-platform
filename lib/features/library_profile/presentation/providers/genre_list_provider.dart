import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/genre_repository.dart';

  final allGenresRepositoryProvider = Provider<AllGenresRepository>((ref) {
    return getIt<AllGenresRepository>();
  });