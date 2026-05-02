import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/discovery_search_response.dart';
import '../entities/discovery_search_type.dart';
import '../entities/paginated_discovery_tracks.dart';

abstract class DiscoveryRepository {
  Future<Either<Failure, DiscoverySearchResponse>> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedDiscoveryTracks>> getTrendingTracks({
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedDiscoveryTracks>> getGenreStation({
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedDiscoveryTracks>> getArtistStation({
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedDiscoveryTracks>> getLikesStation();
}
