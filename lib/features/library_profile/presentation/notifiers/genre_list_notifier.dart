import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../providers/genre_list_provider.dart';

// 2. The Notifier matching your Dartz error handling pattern
class AllGenresListNotifier
    extends AsyncNotifier<Either<Failure, List<String>>> {
  @override
  Future<Either<Failure, List<String>>> build() async {
    // This fetches the mock data automatically when the UI first watches the provider
    return _fetchGenres();
  }

  Future<Either<Failure, List<String>>> _fetchGenres() async {
    final repository = ref.read(allGenreRepositoryProvider);
    return await repository.getGenres();
  }
}

// 3. The Provider your UI will actually watch
