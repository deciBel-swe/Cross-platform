import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_profile_model.dart';

abstract class IProfileRemoteDataSource {
  Future<SocialLinksModel> updateSocialLinks(SocialLinksModel linksModel);
  Future<UserProfileModel> getUserProfile();
  Future<bool> updateProfile(Map<String, dynamic> updateData);
  Future<bool> updateProfileImages({File? profilePic, File? coverPic});
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SocialLinksModel> updateSocialLinks(
    SocialLinksModel linksModel,
  ) async {
    try {
      final unsupportedPlatforms = <String>[
        if ((linksModel.facebook ?? '').trim().isNotEmpty) 'facebook',
        if ((linksModel.youtube ?? '').trim().isNotEmpty) 'youtube',
        if ((linksModel.tiktok ?? '').trim().isNotEmpty) 'tiktok',
        if ((linksModel.linkedin ?? '').trim().isNotEmpty) 'linkedin',
        if ((linksModel.snapchat ?? '').trim().isNotEmpty) 'snapchat',
      ];

      if (unsupportedPlatforms.isNotEmpty) {
        throw ServerException(
          'These platforms are not supported by the current API: '
          '${unsupportedPlatforms.join(', ')}. '
          'Supported platforms: instagram, twitter, website, supportLink.',
        );
      }

      final payload = <String, dynamic>{
        if ((linksModel.instagram ?? '').trim().isNotEmpty)
          'instagram': linksModel.instagram!.trim(),
        if (((linksModel.twitter ?? linksModel.x) ?? '').trim().isNotEmpty)
          'twitter': (linksModel.twitter ?? linksModel.x)!.trim(),
        if ((linksModel.website ?? '').trim().isNotEmpty)
          'website': linksModel.website!.trim(),
        if ((linksModel.supportLink ?? '').trim().isNotEmpty)
          'supportLink': linksModel.supportLink!.trim(),
      };

      final response = await _dioClient.patch<dynamic>(
        ApiConstants.updateSocialLinks,
        data: payload,
      );

      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        throw const ServerException('Failed to update social links');
      }

      final Object? responseData = data['data'] ?? data;
      if (responseData is! Map<String, dynamic>) {
        throw const ServerException('Invalid social links response format');
      }

      return SocialLinksModel.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to update social links');
      }
      final responseData = e.response?.data;
      final backendMessage = responseData is Map<String, dynamic>
          ? responseData['message'] as String?
          : null;
      throw ServerException(
        backendMessage ?? e.message ?? 'Unknown server error',
      );
    }
  }

  @override
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _dioClient.patch<dynamic>(
        ApiConstants.updateProfile,
        data: updateData,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to update profile');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException(
          'Endpoint not found (404). Check your URL.',
        );
      }
      final errorData = e.response?.data as Map<String, dynamic>?;
      final backendMessage = (errorData?['message'] ?? e.message) as String?;
      throw ServerException(backendMessage ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiConstants.userProfileEndpoint,
      );
      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Received empty response from server');
      }

      final Map<String, dynamic> responseData = data['data'] != null
          ? data['data'] as Map<String, dynamic>
          : data;
      final Object? socialLinksDto = responseData['socialLinksDto'];
      final List<Object?> socialLinksList = socialLinksDto is List
          ? socialLinksDto.cast<Object?>()
          : const <Object?>[];
      final Map<String, dynamic>? normalizedSocialLinks =
          socialLinksDto is Map<String, dynamic>
          ? socialLinksDto
          : socialLinksList.isNotEmpty &&
                socialLinksList.first is Map<String, dynamic>
          ? socialLinksList.first as Map<String, dynamic>
          : null;

      final Map<String, dynamic> normalizedResponse = {
        ...responseData,
        'Role': _normalizeRole(responseData),
        'stats': {
          'followers': (responseData['followerCount'] as num?)?.toInt() ?? 0,
          'following': (responseData['followingCount'] as num?)?.toInt() ?? 0,
          'tracksCount': (responseData['trackCount'] as num?)?.toInt() ?? 0,
        },
        'socialLinks': normalizedSocialLinks,
      };

      return UserProfileModel.fromJson(normalizedResponse);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException(
          'Unauthorized to fetch profile. Please log in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw const ServerException('User profile not found.');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Failed to parse user profile data: $e');
    }
  }

  String _normalizeRole(Map<String, dynamic> responseData) {
    final Object? roleValue = responseData['Role'] ?? responseData['role'];
    if (roleValue == null) {
      return 'USER';
    }
    return roleValue.toString();
  }

  @override
  Future<bool> updateProfileImages({File? profilePic, File? coverPic}) async {
    try {
      final formData = FormData();

      if (profilePic != null) {
        final imageName = profilePic.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profilePic',
            await MultipartFile.fromFile(profilePic.path, filename: imageName),
          ),
        );
      }

      if (coverPic != null) {
        final imageName = coverPic.path.split('/').last;
        formData.files.add(
          MapEntry(
            'coverPic',
            await MultipartFile.fromFile(coverPic.path, filename: imageName),
          ),
        );
      }

      final response = await _dioClient.patch<dynamic>(
        ApiConstants.userProfileImage,
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final String? backendMessage = responseData is Map<String, dynamic>
          ? responseData['message'] as String?
          : null;
      throw ServerException(backendMessage ?? 'Failed to upload images');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
