import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/discovery_search_type.dart';
import '../models/discovery_search_response_model.dart';
import '../models/paginated_discovery_tracks_model.dart';

abstract class DiscoveryRemoteDataSource {
  Future<DiscoverySearchResponseModel> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  });

  Future<PaginatedDiscoveryTracksModel> getTrendingTracks({
    required int page,
    required int size,
  });

  Future<PaginatedDiscoveryTracksModel> getGenreStation({
    required int page,
    required int size,
  });

  Future<PaginatedDiscoveryTracksModel> getArtistStation({
    required int page,
    required int size,
  });

  Future<PaginatedDiscoveryTracksModel> getLikesStation();
}

@LazySingleton(as: DiscoveryRemoteDataSource, env: [Environment.prod])
class DiscoveryRemoteDataSourceImpl implements DiscoveryRemoteDataSource {
  const DiscoveryRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<DiscoverySearchResponseModel> search({
    required String query,
    required DiscoverySearchType type,
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.globalSearchEndpoint,
        queryParams: <String, Object?>{
          'q': query,
          'type': type.queryValue,
          'page': page,
          'size': size,
        },
      );

      return DiscoverySearchResponseModel.fromResponse(response.data);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(error.message ?? 'Failed to search discovery');
    } catch (error) {
      throw ServerException('Failed to parse search response: $error');
    }
  }

  @override
  Future<PaginatedDiscoveryTracksModel> getTrendingTracks({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.trendingTracksEndpoint,
        queryParams: <String, Object?>{'page': page, 'size': size},
      );

      return PaginatedDiscoveryTracksModel.fromResponse(response.data);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(
        error.message ?? 'Failed to fetch trending discovery tracks',
      );
    } catch (error) {
      throw ServerException('Failed to parse trending response: $error');
    }
  }

  @override
  Future<PaginatedDiscoveryTracksModel> getGenreStation({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.genreStationEndpoint,
        queryParams: <String, Object?>{'page': page, 'size': size},
      );

      return PaginatedDiscoveryTracksModel.fromResponse(response.data);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (_isNoResultsStationResponse(error)) {
        return const PaginatedDiscoveryTracksModel();
      }
      throw ServerException(
        error.message ?? 'Failed to fetch genre station tracks',
      );
    } catch (error) {
      throw ServerException('Failed to parse genre station response: $error');
    }
  }

  @override
  Future<PaginatedDiscoveryTracksModel> getArtistStation({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.artistStationEndpoint,
        queryParams: <String, Object?>{'page': page, 'size': size},
      );

      return PaginatedDiscoveryTracksModel.fromResponse(response.data);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (_isNoResultsStationResponse(error)) {
        return const PaginatedDiscoveryTracksModel();
      }
      throw ServerException(
        error.message ?? 'Failed to fetch artist station tracks',
      );
    } catch (error) {
      throw ServerException('Failed to parse artist station response: $error');
    }
  }

  @override
  Future<PaginatedDiscoveryTracksModel> getLikesStation() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.likesStationEndpoint,
      );

      return PaginatedDiscoveryTracksModel.fromResponse(response.data);
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (_isNoResultsStationResponse(error)) {
        return const PaginatedDiscoveryTracksModel();
      }
      throw ServerException(
        error.message ?? 'Failed to fetch station based on likes',
      );
    } catch (error) {
      throw ServerException('Failed to parse likes station response: $error');
    }
  }

  bool _isNoResultsStationResponse(DioException error) {
    if (error.response?.statusCode != 404) {
      return false;
    }

    final data = error.response?.data;
    if (data is! Map<Object?, Object?>) {
      return false;
    }

    final payload = Map<String, dynamic>.from(data);
    final errorLabel = payload['error']?.toString().trim().toLowerCase();
    final message = payload['message']?.toString().trim().toLowerCase();

    return errorLabel == 'no results' ||
        (message?.contains('no tracks found for this station') ?? false);
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }
}
