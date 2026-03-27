import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';

@lazySingleton
class FollowingFeedRemoteDatasource {
  FollowingFeedRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<Map<String, dynamic>> getFollowingFeed({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/feed',
      queryParams: <String, Object?>{
        'page': page,
        'size': size,
      },
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty following feed response');
    }

    return data;
  }
}