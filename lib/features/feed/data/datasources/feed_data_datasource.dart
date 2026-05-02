import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/paginated_feed_model.dart';

/// Abstract contract for the feed remote datasource.
abstract class IFeedRemoteDatasource {
  Future<PaginatedFeedModel> getFeed({required int page, required int size});
  Future<PaginatedFeedModel> getDiscoverFeed({
    required int page,
    required int size,
  });
}

/// Production implementation that calls `/feed` and `/stations/artist` and parses the response.
@LazySingleton(as: IFeedRemoteDatasource)
class FeedRemoteDatasource implements IFeedRemoteDatasource {
  const FeedRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<PaginatedFeedModel> getFeed({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        '/feed',
        queryParams: <String, Object?>{'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) throw const ServerException('Empty feed response');

      // Unwrap optional "data" envelope some backends add.
      final payload = _extractObjectPayload(data);
      if (payload.isEmpty) {
        throw const ServerException('Unexpected feed response shape');
      }

      return PaginatedFeedModel.fromJson(payload);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      throw ServerException(e.message ?? 'Feed request failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaginatedFeedModel> getDiscoverFeed({
    required int page,
    required int size,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.artistStationEndpoint,
        queryParams: <String, Object?>{'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) throw const ServerException('Empty discover response');

      final payload = _extractObjectPayload(data);
      if (payload.isEmpty) {
        throw const ServerException('Unexpected discover response shape');
      }

      return PaginatedFeedModel.fromJson(payload);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (_isNoResultsStationResponse(e)) {
        return const PaginatedFeedModel();
      }
      throw ServerException(e.message ?? 'Discover request failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }

  Map<String, dynamic> _extractObjectPayload(Object? data) {
    if (data is! Map<Object?, Object?>) {
      return const <String, dynamic>{};
    }

    final payload = Map<String, dynamic>.from(data);
    final nested = payload['data'];
    if (nested is Map<Object?, Object?>) {
      return Map<String, dynamic>.from(nested);
    }
    return payload;
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
}
