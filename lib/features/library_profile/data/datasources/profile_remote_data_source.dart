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
  Future<UserProfileModel> getPublicProfile(int userId);
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

      final currentProfile = await getUserProfile();
      final profileDetails = currentProfile.profileDetails;

      final updateMePayload = <String, dynamic>{
        'bio': profileDetails.bio ?? '',
        'city': profileDetails.city ?? '',
        'country': profileDetails.country ?? '',
        'favoriteGenres': profileDetails.favoriteGenres,
        'socialLinks': payload,
      };

      final response = await _dioClient.patch<dynamic>(
        ApiConstants.updateProfile,
        data: updateMePayload,
      );

      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        throw const ServerException('Failed to update social links');
      }

      final Object? responseData = data['data'] ?? data;
      if (responseData is! Map<String, dynamic>) {
        throw const ServerException('Invalid social links response format');
      }

      var normalizedLinksPayload = _extractSocialLinksPayload(
        responseData: responseData,
      );

      if (!_containsAllRequestedLinks(normalizedLinksPayload, payload)) {
        final refreshedProfile = await getUserProfile();
        final refreshedLinks =
            refreshedProfile.socialLinks?.toJson() ?? const <String, dynamic>{};

        if (!_containsAllRequestedLinks(refreshedLinks, payload)) {
          throw const ServerException(
            'Social links were not persisted by backend',
          );
        }

        normalizedLinksPayload = refreshedLinks;
      }

      return SocialLinksModel.fromJson(normalizedLinksPayload);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
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
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
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
      final rawProfile = responseData['profile'];
      final profileMap = rawProfile is Map<String, dynamic>
          ? rawProfile
          : const <String, dynamic>{};

      final normalizedSocialLinks = _extractProfileSocialLinks(
        responseData,
        profileMap,
      );
      final profilePayload = _extractProfileDetailsPayload(responseData);
      final privacyPayload = _extractPrivacySettingsPayload(responseData);

      final Map<String, dynamic> normalizedResponse = {
        ...responseData,
        'id': _asInt(responseData['id'] ?? profileMap['id']),
        'Role': _normalizeRole(responseData),
        'email': _asString(responseData['email'] ?? profileMap['email']),
        'username': _asString(
          responseData['username'] ?? profileMap['username'],
        ),
        'displayName': _asNullableString(
          responseData['displayName'] ??
              profileMap['displayName'] ??
              profileMap['DisplayName'],
        ),
        'emailVerified': _asBool(responseData['emailVerified']),
        'tier': _asString(
          responseData['tier'] ?? profileMap['tier'],
          fallback: 'FREE',
        ),
        'profile': profilePayload,
        'privacySettings': privacyPayload,
        'stats': {
          'followers': _asInt(
            responseData['followerCount'] ?? profileMap['followerCount'],
          ),
          'following': _asInt(
            responseData['followingCount'] ?? profileMap['followingCount'],
          ),
          'tracksCount': _asInt(
            responseData['trackCount'] ?? profileMap['trackCount'],
          ),
        },
        'socialLinks': normalizedSocialLinks,
      };

      return UserProfileModel.fromJson(normalizedResponse);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (e.response?.statusCode == 401) {
        throw const AuthException(
          'Unauthorized to fetch profile. Please log in again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw const NotFoundException('User profile not found.');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Failed to parse user profile data: $e');
    }
  }

  @override
  Future<UserProfileModel> getPublicProfile(int userId) async {
    try {
      final response = await _dioClient.get<dynamic>('/users/$userId');

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException('Received empty public profile response');
      }

      final Map<String, dynamic> responseData = data['data'] != null
          ? data['data'] as Map<String, dynamic>
          : data;

      final Map<String, dynamic> profile =
          (responseData['profile'] as Map<String, dynamic>?) ??
          const <String, dynamic>{};

      final Map<String, dynamic> stats =
          (responseData['stats'] as Map<String, dynamic>?) ??
          const <String, dynamic>{};

      final Map<String, dynamic>? socialLinks =
          responseData['socialLinks'] as Map<String, dynamic>?;

      final Map<String, dynamic> normalizedResponse = <String, dynamic>{
        'id': responseData['id'] ?? 0,
        'Role': 'USER',
        'email': '',
        'username': responseData['username'] ?? '',
        'displayName': _asNullableString(
          responseData['displayName'] ??
              profile['displayName'] ??
              profile['DisplayName'],
        ),
        'emailVerified': true,
        'tier': responseData['tier'] ?? 'FREE',
        'profile': {
          'bio': profile['bio'],
          'city': profile['Location'] ?? profile['city'],
          'country': null,
          'profilePic': profile['avatarUrl'],
          'coverPic': profile['coverPhotoUrl'],
          'favoriteGenres': profile['favoriteGenres'] ?? const <dynamic>[],
        },
        'socialLinks': socialLinks,
        'privacySettings': {'isPrivate': false, 'showHistory': true},
        'stats': {
          'followers': (stats['followersCount'] as num?)?.toInt() ?? 0,
          'following': (stats['followingCount'] as num?)?.toInt() ?? 0,
          'tracksCount': (stats['trackCount'] as num?)?.toInt() ?? 0,
        },
      };

      return UserProfileModel.fromJson(normalizedResponse);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        throw const NetworkException(
          'No internet connection. Offline content is still available.',
        );
      }
      if (e.response?.statusCode == 404) {
        throw const NotFoundException('Public profile not found.');
      }
      throw ServerException(e.message ?? 'Unknown server error');
    } catch (e) {
      throw ServerException('Failed to parse public profile data: $e');
    }
  }

  String _normalizeRole(Map<String, dynamic> responseData) {
    final Object? roleValue = responseData['Role'] ?? responseData['role'];
    if (roleValue == null) {
      return 'USER';
    }
    return roleValue.toString();
  }

  Map<String, dynamic> _extractProfileDetailsPayload(
    Map<String, dynamic> responseData,
  ) {
    final rawProfile = responseData['profile'];
    final profileMap = rawProfile is Map<String, dynamic>
        ? rawProfile
        : const <String, dynamic>{};

    return <String, dynamic>{
      'bio': _asNullableString(profileMap['bio'] ?? responseData['bio']),
      'city': _asNullableString(profileMap['city'] ?? responseData['city']),
      'country': _asNullableString(
        profileMap['country'] ?? responseData['country'],
      ),
      'profilePic': _asNullableString(
        profileMap['profilePic'] ??
            profileMap['avatarUrl'] ??
            responseData['profilePic'] ??
            responseData['avatarUrl'],
      ),
      'coverPic': _asNullableString(
        profileMap['coverPic'] ??
            profileMap['coverPhotoUrl'] ??
            responseData['coverPic'] ??
            responseData['coverPhotoUrl'],
      ),
      'favoriteGenres': _asStringList(
        profileMap['favoriteGenres'] ?? responseData['favoriteGenres'],
      ),
    };
  }

  Map<String, dynamic> _extractPrivacySettingsPayload(
    Map<String, dynamic> responseData,
  ) {
    final raw = responseData['privacySettings'];
    final map = raw is Map<String, dynamic> ? raw : const <String, dynamic>{};

    return <String, dynamic>{
      'isPrivate': _asBool(map['isPrivate']),
      'showHistory': _asBool(map['showHistory']),
    };
  }

  int _asInt(Object? value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  bool _asBool(Object? value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }

  String _asString(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final parsed = value.toString().trim();
    return parsed.isEmpty ? fallback : parsed;
  }

  String? _asNullableString(Object? value) {
    if (value == null) return null;
    final parsed = value.toString().trim();
    return parsed.isEmpty ? null : parsed;
  }

  List<String> _asStringList(Object? value) {
    if (value is! List) return const <String>[];
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> _extractSocialLinksPayload({
    required Map<String, dynamic> responseData,
  }) {
    final socialLinks = responseData['socialLinks'];
    if (socialLinks is Map<String, dynamic>) {
      return socialLinks;
    }

    final socialLinksDto = responseData['socialLinksDto'];
    if (socialLinksDto is Map<String, dynamic>) {
      return socialLinksDto;
    }

    if (socialLinksDto is List) {
      final mergedFromList = <String, dynamic>{};

      for (final item in socialLinksDto.whereType<Map<String, dynamic>>()) {
        if (item.keys.any((key) => _isSupportedSocialKey(key))) {
          for (final entry in item.entries) {
            if (_isSupportedSocialKey(entry.key) &&
                entry.value is String &&
                (entry.value as String).trim().isNotEmpty) {
              mergedFromList[entry.key] = (entry.value as String).trim();
            }
          }
          continue;
        }

        final platform =
            item['platform']?.toString() ?? item['name']?.toString();
        final url = item['url']?.toString() ?? item['link']?.toString();

        if (platform != null &&
            url != null &&
            _isSupportedSocialKey(platform) &&
            url.trim().isNotEmpty) {
          mergedFromList[platform] = url.trim();
        }
      }

      if (mergedFromList.isNotEmpty) {
        return mergedFromList;
      }
    }

    return const <String, dynamic>{};
  }

  bool _isSupportedSocialKey(String key) {
    const supported = <String>{
      'instagram',
      'twitter',
      'website',
      'supportLink',
    };
    return supported.contains(key);
  }

  Map<String, dynamic>? _extractProfileSocialLinks(
    Map<String, dynamic> responseData,
    Map<String, dynamic> profileMap,
  ) {
    final socialLinks =
        responseData['socialLinks'] ?? profileMap['socialLinks'];
    if (socialLinks is Map<String, dynamic> && socialLinks.isNotEmpty) {
      return socialLinks;
    }

    final socialLinksDto =
        responseData['socialLinksDto'] ?? profileMap['socialLinksDto'];
    if (socialLinksDto is Map<String, dynamic> && socialLinksDto.isNotEmpty) {
      return socialLinksDto;
    }

    if (socialLinksDto is List) {
      final mergedFromList = <String, dynamic>{};

      for (final item in socialLinksDto.whereType<Map<String, dynamic>>()) {
        if (item.keys.any((key) => _isSupportedSocialKey(key))) {
          for (final entry in item.entries) {
            if (_isSupportedSocialKey(entry.key) &&
                entry.value is String &&
                (entry.value as String).trim().isNotEmpty) {
              mergedFromList[entry.key] = (entry.value as String).trim();
            }
          }
          continue;
        }

        final platform =
            item['platform']?.toString() ?? item['name']?.toString();
        final url = item['url']?.toString() ?? item['link']?.toString();

        if (platform != null &&
            url != null &&
            _isSupportedSocialKey(platform) &&
            url.trim().isNotEmpty) {
          mergedFromList[platform] = url.trim();
        }
      }

      if (mergedFromList.isNotEmpty) {
        return mergedFromList;
      }
    }

    return null;
  }

  bool _containsAllRequestedLinks(
    Map<String, dynamic> persisted,
    Map<String, dynamic> requested,
  ) {
    for (final entry in requested.entries) {
      final persistedValue = persisted[entry.key]?.toString().trim();
      final requestedValue = entry.value.toString().trim();
      if (persistedValue != requestedValue) {
        return false;
      }
    }
    return true;
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
      if (_isNetworkError(error)) {
        throw const NetworkException(
          'No internet. Image kept locally but not uploaded.',
        );
      }
      final responseData = error.response?.data;
      final String? backendMessage = responseData is Map<String, dynamic>
          ? responseData['message'] as String?
          : null;
      throw ServerException(backendMessage ?? 'Failed to upload images');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }
}
