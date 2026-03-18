import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_profile_model.dart';

abstract class IProfileRemoteDataSource {
  Future<UserProfileModel> updateSocialLinks(SocialLinksModel linksModel);
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<UserProfileModel> updateSocialLinks(
      SocialLinksModel linksModel) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.updateProfile,
        data: {'socialLinks': linksModel.toJson()},
      );

      if (response.data == null || response.data['success'] != true) {
        throw const ServerException('Failed to update social links');
      }

      return UserProfileModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to update profile');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    }
  }
}
