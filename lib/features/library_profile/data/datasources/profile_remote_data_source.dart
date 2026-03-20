import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_profile_model.dart';

abstract class IProfileRemoteDataSource {
  Future<SocialLinksModel> updateSocialLinks(SocialLinksModel linksModel);
  Future<UserProfileModel> getUserProfile();
  Future<bool> updateProfile(Map<String, dynamic> updateData);
Future<bool> updateProfileImages({File? profilePic, File? coverPic});}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SocialLinksModel> updateSocialLinks(
    SocialLinksModel linksModel,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.updateSocialLinks,
        data: linksModel.toJson(),
      );

      if (response.data == null || response.data['success'] != true) {
        throw const ServerException('Failed to update social links');
      }

      return SocialLinksModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Unauthorized to update social links');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    }
  }

  @override
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _dioClient.patch(
        ApiConstants.userProfileEndpoint, 
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
      final backendMessage =
          (e.response?.data?['message'] ?? e.message) as String?;
      throw ServerException(backendMessage ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Data parsing error: $e');
    }
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
      final backendMessage = error.response?.data?['message'] ?? error.message ;
      throw ServerException((backendMessage ?? 'Failed to upload images') as String);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dioClient.get(ApiConstants.userProfileEndpoint);
      debugPrint("++++++++++++++++++++++++++++++++++++");
      debugPrint("Response from /users/me: ${response.data}");
      debugPrint("++++++++++++++++++++++++++++++++++++");
      if (response.data == null) {
        throw const ServerException('Received empty response from server');
      }

      final Map<String, dynamic> responseData = response.data['data'] != null
          ? response.data['data'] as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return UserProfileModel.fromJson(responseData);
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
}
