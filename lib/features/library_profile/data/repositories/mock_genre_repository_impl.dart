import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/genre_repository.dart';

class MockAllGenresRepository implements AllGenresRepository {
  static const List<String> _genres = <String>[
    'Lo-fi',
    'House',
    'Ambient',
    'Hip-Hop',
    'Pop',
    'Rock',
  ];

  @override
  Future<Either<Failure, List<String>>> getGenres() async {
    return const Right(_genres);
  }
}
