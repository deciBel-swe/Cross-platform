import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/discovery_search_response.dart';
import '../../domain/entities/discovery_search_type.dart';
import '../../domain/entities/discovery_track.dart';
import '../../domain/entities/paginated_discovery_tracks.dart';
import '../../domain/repositories/discovery_repository.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((Ref ref) {
  return getIt<DiscoveryRepository>();
});

typedef DiscoverySearchParams = ({
  String query,
  DiscoverySearchType type,
  int page,
  int size,
});

final searchResultsProvider = FutureProvider.autoDispose
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

      return result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const DiscoverySearchResponse();
          }
          throw Exception(failure.message);
        },
        (response) {
          return response;
        },
      );
    });

final popularTracksProvider = FutureProvider.autoDispose
    .family<PaginatedDiscoveryTracks, ({int page, int size})>((
      Ref ref,
      ({int page, int size}) params,
    ) async {
      final repository = ref.read(discoveryRepositoryProvider);
      final result = await repository.getTrendingTracks(
        page: params.page,
        size: params.size,
      );

      return result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const PaginatedDiscoveryTracks(content: <DiscoveryTrack>[]);
          }
          throw Exception(failure.message);
        },
        (response) {
          return response;
        },
      );
    });

final likesStationProvider =
    FutureProvider.autoDispose<PaginatedDiscoveryTracks>((Ref ref) async {
      final repository = ref.read(discoveryRepositoryProvider);
      final result = await repository.getLikesStation();

      return result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const PaginatedDiscoveryTracks(content: <DiscoveryTrack>[]);
          }
          throw Exception(failure.message);
        },
        (response) {
          return response;
        },
      );
    });

final artistStationProvider = FutureProvider.autoDispose
    .family<PaginatedDiscoveryTracks, ({int page, int size})>((
      Ref ref,
      ({int page, int size}) params,
    ) async {
      final repository = ref.read(discoveryRepositoryProvider);
      final result = await repository.getArtistStation(
        page: params.page,
        size: params.size,
      );

      return result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const PaginatedDiscoveryTracks(content: <DiscoveryTrack>[]);
          }
          throw Exception(failure.message);
        },
        (response) {
          return response;
        },
      );
    });

final genreStationProvider = FutureProvider.autoDispose
    .family<PaginatedDiscoveryTracks, ({int page, int size})>((
      Ref ref,
      ({int page, int size}) params,
    ) async {
      final repository = ref.read(discoveryRepositoryProvider);
      final result = await repository.getGenreStation(
        page: params.page,
        size: params.size,
      );

      return result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const PaginatedDiscoveryTracks(content: <DiscoveryTrack>[]);
          }
          throw Exception(failure.message);
        },
        (response) {
          return response;
        },
      );
    });
