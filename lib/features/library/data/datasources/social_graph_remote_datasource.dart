import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/paginated_following_users_model.dart';

@lazySingleton
class SocialGraphRemoteDatasource {
  SocialGraphRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<PaginatedFollowingUsersModel> getFollowingUsers({
    required int userId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/$userId/following',
      queryParams: <String, Object?>{
        'page': page,
        'size': size,
      },
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty following response');
    }

    return PaginatedFollowingUsersModel.fromJson(data);
  }
}