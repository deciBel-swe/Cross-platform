import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_profile_model.dart';

abstract class IProfileLocalDataSource {
  Future<void> cacheUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getLastUserProfile();
  Future<void> clearCache();
}

@LazySingleton(as: IProfileLocalDataSource)
class ProfileLocalDataSource implements IProfileLocalDataSource {
  ProfileLocalDataSource(this._secureStorageService);

  final SecureStorageService _secureStorageService;
  static const String _profileKey = 'cached_user_profile';

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    // We use SecureStorage because profile might contain email/private info
    await _secureStorageService.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<UserProfileModel?> getLastUserProfile() async {
    final jsonStr = await _secureStorageService.getString(_profileKey);
    if (jsonStr == null) return null;
    try {
      return UserProfileModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await _secureStorageService.removeString(_profileKey);
  }
}
