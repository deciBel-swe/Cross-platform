import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_data_source_remote.dart';

class AllGenresRepositoryImpl implements AllGenresRepository {
  AllGenresRepositoryImpl({required this.remoteDataSource});
  final GenreRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<String>>> getGenres() async {
    try {
      final genres = await remoteDataSource.getGenres();
      return Right(genres);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
