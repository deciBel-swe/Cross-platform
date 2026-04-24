import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class IGenreRemoteDataSource {
  Future<List<String>> getGenres();
}

@LazySingleton(as: IGenreRemoteDataSource)
class GenreRemoteDataSource implements IGenreRemoteDataSource {
  const GenreRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<String>> getGenres() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.genresEndpoint,
      );
      final data = response.data;

      // 2. Check if it's a Map before accessing the 'data' key
      final dynamic responseData = (data is Map<String, dynamic>)
          ? data['data'] ?? data
          : data;

      if (response.data == null) {
        throw const ServerException('Received empty response from server');
      }

      if (responseData is List) {
        return responseData.map((e) => e.toString()).toList();
      } else {
        throw const ServerException(
          'Unexpected data format: Expected a list of genres',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to fetch genres.');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException(
          'Genres endpoint not found (404). Check your URL.',
        );
      }
      final responseData = e.response?.data as Map<String, dynamic>?;

      // 2. Now you can safely access the key without linting errors
      final backendMessage = (responseData?['message'] ?? e.message) as String?;
      throw ServerException(backendMessage ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }
}
