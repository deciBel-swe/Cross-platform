import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/paginated_feed_model.dart';

/// Abstract contract for the feed remote datasource.
abstract class IFeedRemoteDatasource {
  Future<PaginatedFeedModel> getFeed({required int page, required int size});
}

/// Production implementation that calls `/feed` and parses the response.
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
      final Map<String, dynamic> payload;
      if (data is Map<String, dynamic>) {
        payload = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
      } else {
        throw const ServerException('Unexpected feed response shape');
      }

      return PaginatedFeedModel.fromJson(payload);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Feed request failed');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
