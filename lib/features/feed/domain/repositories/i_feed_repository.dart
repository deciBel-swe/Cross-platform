import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/paginated_feed.dart';

/// Abstract repository contract for the feed feature.
abstract class IFeedRepository {
  /// Fetches a page of the authenticated user's activity feed.
  Future<Either<Failure, PaginatedFeed>> getFeed({
    required int page,
    required int size,
  });
}
