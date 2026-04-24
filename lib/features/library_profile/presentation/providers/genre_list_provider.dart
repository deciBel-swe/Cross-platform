import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/genre_repository.dart';
import '../notifiers/genre_list_notifier.dart';

final allGenreRepositoryProvider = Provider<AllGenresRepository>((ref) {
  return getIt<AllGenresRepository>(); // This must match exactly!
});
final allGenreListProvider =
    AsyncNotifierProvider<AllGenresListNotifier, Either<Failure, List<String>>>(
      AllGenresListNotifier.new,
    );
