import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/listening_history_response.dart';

/// Remote datasource for the current user's listening history.
@lazySingleton
class HistoryRemoteDatasource {
  const HistoryRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<void> incrementPlayCount({required int trackId}) async {
    await _postTrackListenEvent(ApiConstants.trackPlay(trackId));
  }

  Future<void> markTrackCompleted({required int trackId}) async {
    await _postTrackListenEvent(ApiConstants.trackComplete(trackId));
  }

  Future<ListeningHistoryResponse> getListeningHistory({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.listeningHistory,
        queryParams: {'page': page, 'size': size},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Listening history response was empty');
      }

      if (data is! Map<Object?, Object?>) {
        throw const ServerException(
          'Unexpected listening history response shape',
        );
      }

      return ListeningHistoryResponse.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException('No internet connection');
      }
      throw ServerException(
        error.message ?? 'Listening history request failed',
      );
    } on ServerException {
      rethrow;
    } on FormatException catch (error) {
      throw ServerException(error.message);
    } on TypeError catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<void> _postTrackListenEvent(String path) async {
    try {
      await _dioClient.post<dynamic>(path, data: const <String, dynamic>{});
    } on DioException catch (error) {
      if (_isNetworkError(error)) {
        throw const NetworkException('No internet connection');
      }
      throw ServerException(error.message ?? 'Track listen event failed');
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
}
