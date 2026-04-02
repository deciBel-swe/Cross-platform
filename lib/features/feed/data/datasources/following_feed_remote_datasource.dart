import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

@lazySingleton
class FollowingFeedRemoteDatasource {
  FollowingFeedRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<Map<String, dynamic>> getFollowingFeed({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiConstants.feedEndpoint,
        queryParams: <String, Object?>{
          'page': page,
          'size': size,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('Received empty following feed response');
      }

      return data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to fetch following feed');
      }
      if (e.response?.statusCode == 404) {
        throw const ServerException('Following feed endpoint not found');
      }
      throw ServerException(e.message ?? 'Failed to fetch following feed');
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to parse following feed response: $e');
    }
  }
}