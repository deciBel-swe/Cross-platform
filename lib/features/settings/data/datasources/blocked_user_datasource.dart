import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/blocked_user.dart';

@LazySingleton()
class BlockedUserRemoteDataSource {
  BlockedUserRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<BlockedUserResponse> fetchBlockedUsers(int page, int size) async {
    final response = await _dioClient.get<dynamic>(
      ApiConstants.userBlockedList,
      queryParams: {'page': page, 'size': size},
    );

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final List<dynamic> contentJson =
        (data['content'] as List<dynamic>?) ?? <dynamic>[];
    final List<BlockedUser> users = contentJson
        .map((e) => BlockedUser.fromJson(e as Map<String, dynamic>))
        .toList();

    return BlockedUserResponse(
      content: users,
      isLast: (data['isLast'] as bool?) ?? true,
    );
  }

  Future<void> unblockUser(String userId) async {
    await _dioClient.delete<dynamic>('/api/users/$userId/block');
  }
}

class BlockedUserResponse {
  BlockedUserResponse({required this.content, required this.isLast});
  final List<BlockedUser> content;
  final bool isLast;
}
