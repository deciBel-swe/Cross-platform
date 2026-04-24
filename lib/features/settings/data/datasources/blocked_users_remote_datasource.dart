import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/paginated_blocked_users_model.dart';

@lazySingleton
class BlockedUsersRemoteDatasource {
  BlockedUsersRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<PaginatedBlockedUsersModel> getBlockedUsers({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/me/blocked',
      queryParams: <String, Object?>{'page': page, 'size': size},
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty blocked users response');
    }

    return PaginatedBlockedUsersModel.fromJson(data);
  }

  Future<void> unblockUser({required int userId}) async {
    await _dioClient.delete<void>('/users/$userId/block');
  }
}
