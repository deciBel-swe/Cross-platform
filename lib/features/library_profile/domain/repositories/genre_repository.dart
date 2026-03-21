import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart'; 

abstract class AllGenresRepository {
  Future<Either<Failure, List<String>>> getGenres();
}