import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/discovery_search_response.dart';
import '../../domain/entities/discovery_search_type.dart';
import '../../domain/entities/paginated_discovery_tracks.dart';
import '../../domain/repositories/discovery_repository.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((Ref ref) {
  return getIt<DiscoveryRepository>();
});

typedef DiscoverySearchParams =
    ({String query, DiscoverySearchType type, int page, int size});

final searchResultsProvider =
    FutureProvider.autoDispose
        .family<DiscoverySearchResponse, DiscoverySearchParams>((
          Ref ref,
          DiscoverySearchParams params,
        ) async {
          final repository = ref.read(discoveryRepositoryProvider);
          final result = await repository.search(
            query: params.query,
            type: params.type,
            page: params.page,
            size: params.size,
          );

          return result.fold((failure) => throw Exception(failure.message), (
            response,
          ) {
            return response;
          });
        });

final popularTracksProvider =
    FutureProvider.autoDispose
        .family<PaginatedDiscoveryTracks, ({String? genre, int limit})>((
          Ref ref,
          ({String? genre, int limit}) params,
        ) async {
          final repository = ref.read(discoveryRepositoryProvider);
          final result = await repository.getTrendingTracks(
            genre: params.genre,
            limit: params.limit,
          );

          return result.fold((failure) => throw Exception(failure.message), (
            response,
          ) {
            return response;
          });
        });

final likesStationProvider =
    FutureProvider.autoDispose<PaginatedDiscoveryTracks>((Ref ref) async {
      final repository = ref.read(discoveryRepositoryProvider);
      final result = await repository.getLikesStation();

      return result.fold((failure) => throw Exception(failure.message), (
        response,
      ) {
        return response;
      });
    });

final genreStationProvider =
    FutureProvider.autoDispose
        .family<PaginatedDiscoveryTracks, ({String genre, int page, int size})>(
          (Ref ref, ({String genre, int page, int size}) params) async {
            final repository = ref.read(discoveryRepositoryProvider);
            final result = await repository.getGenreStation(
              genre: params.genre,
              page: params.page,
              size: params.size,
            );

            return result.fold((failure) => throw Exception(failure.message), (
              response,
            ) {
              return response;
            });
          },
        );
