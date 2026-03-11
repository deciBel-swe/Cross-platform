import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/device_info_model.dart';

@Environment('prod')
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._remoteDataSource, this._secureStorageService);

  final IAuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final isExpired = await _secureStorageService.isAccessTokenExpired();
      if (isExpired) {
        return null; // A refresh logic would go here initially, but for now just logout.
      }

      // Because we don't have a /me endpoint or local user db mapped right now,
      // getting the current user purely relies on valid tokens.
      // we'd fetch the user's profile info when backend is ready.
      // Returning null requires them to login again
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthUser> loginWithGoogle() async {
    try {
      // Create DeviceInfoModel (hardcoded for now, I will do it in the next commit)
      final deviceInfo = const DeviceInfoModel(
        deviceName: 'unknown_device',
        deviceType: 'flutter_app',
        fingerPrint: 'unknown',
      );

      final responseModel = await _remoteDataSource.loginWithGoogle(deviceInfo);

      // Save tokens securely
      await _secureStorageService.saveTokenPair(responseModel);

      return responseModel.user.toDomain();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw const AuthFailure('An unexpected error occurred.');
    }
  }
}
