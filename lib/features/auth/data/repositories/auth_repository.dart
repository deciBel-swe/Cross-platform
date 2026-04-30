import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../../offline/data/datasources/offline_local_data_source.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/device_info_model.dart';
import '../models/login_local_request_model.dart';
import '../models/register_local_request_model.dart';

@Environment('prod')
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(
    this._remoteDataSource,
    this._secureStorageService,
    this._sharedPrefsService,
    this._offlineLocalDataSource,
  );

  final IAuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  final SharedPrefsService _sharedPrefsService;
  final OfflineLocalDataSource _offlineLocalDataSource;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final deviceInfo = await _buildDeviceInfo();
      final request = LoginLocalRequestModel(
        email: email,
        password: _hashPassword(password),
        deviceInfo: deviceInfo,
      );

      final responseModel = await _remoteDataSource.loginLocal(request);
      await _secureStorageService.saveTokenPair(responseModel);

      return Right(responseModel.user.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[AuthRepository] Unexpected error in loginWithEmailPassword: $e',
        );
        debugPrint('[AuthRepository] StackTrace: $st');
      }
      return Left(AuthFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerWithEmailPassword({
    required String email,
    required String displayName,
    required String password,
    required DateTime dateOfBirth,
    required String gender,
    String? city,
    String? country,
    required String captchaToken,
  }) async {
    try {
      final deviceInfo = await _buildDeviceInfo();

      final request = RegisterLocalRequestModel(
        email: email,
        displayName: displayName,
        password: _hashPassword(password),
        dateOfBirth: dateOfBirth.toIso8601String().split('T').first,
        gender: gender,
        city: city,
        country: country,
        captchaToken: captchaToken,
        deviceInfo: deviceInfo,
      );

      await _remoteDataSource.registerLocal(request);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[AuthRepository] Unexpected error in registerWithEmailPassword: $e',
        );
        debugPrint('[AuthRepository] StackTrace: $st');
      }
      return const Left(AuthFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final isExpired = await _secureStorageService.isAccessTokenExpired();
      final hasRefreshToken =
          (await _secureStorageService.getRefreshToken()) != null;

      if (isExpired && hasRefreshToken) {
        final refreshResult = await refreshToken();
        return refreshResult.fold(
          (failure) {
            _offlineLocalDataSource.clearAll();
            return const Right(null); // If refresh fails, user must log in again
          },
          (user) => Right(user),
        );
      }

      if (isExpired) {
        return const Right(null);
      }

      final userModel = await _secureStorageService.getUser();
      return Right(userModel?.toDomain());
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, AuthUser>> refreshToken() async {
    try {
      final refreshToken = await _secureStorageService.getRefreshToken();
      final accessToken = await _secureStorageService.getAccessToken();

      if (refreshToken == null || accessToken == null) {
        return const Left(AuthFailure('No tokens available for refresh'));
      }

      debugPrint('[AuthRepository] Proactively refreshing token...');
      final responseModel = await _remoteDataSource.refreshToken(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      await _secureStorageService.saveRefreshTokens(
        accessToken: responseModel.accessToken,
        refreshToken: responseModel.refreshToken,
        expiresIn: responseModel.expiresIn,
      );

      final userModel = await _secureStorageService.getUser();
      if (userModel == null) {
        return const Left(
          AuthFailure('Token refreshed but no cached user was found'),
        );
      }

      return Right(userModel.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Token refresh failed: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithGoogle() async {
    try {
      final deviceInfo = await _buildDeviceInfo();

      final responseModel = await _remoteDataSource.loginWithGoogle(deviceInfo);

      await _secureStorageService.saveTokenPair(responseModel);

      return Right(responseModel.user.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AuthRepository] Unexpected error in loginWithGoogle: $e');
        debugPrint('[AuthRepository] StackTrace: $st');
      }
      return const Left(AuthFailure('An unexpected error occurred.'));
    }
  }

  Future<DeviceInfoModel> _buildDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String deviceName = 'unknown_device';
    String fingerPrint = 'unknown';
    String deviceType = 'DESKTOP';

    try {
      if (Platform.isAndroid) {
        deviceType = 'MOBILE';
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
        fingerPrint = androidInfo.id;
      } else if (Platform.isIOS) {
        deviceType = 'MOBILE';
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceName = iosInfo.name;
        fingerPrint = iosInfo.identifierForVendor ?? 'unknown';
      } else if (Platform.isWindows) {
        deviceType = 'DESKTOP';
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceName = windowsInfo.computerName;
        fingerPrint = windowsInfo.deviceId;
      } else if (Platform.isMacOS) {
        deviceType = 'DESKTOP';
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceName = macOsInfo.computerName;
        fingerPrint = macOsInfo.systemGUID ?? 'unknown';
      } else if (Platform.isLinux) {
        deviceType = 'DESKTOP';
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceName = linuxInfo.prettyName;
        fingerPrint = linuxInfo.machineId ?? 'unknown';
      }
    } catch (_) {
      // Fallback to defaults if device gathering fails.
    }

    return DeviceInfoModel(
      deviceName: deviceName,
      deviceType: deviceType,
      fingerPrint: fingerPrint,
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AuthRepository] Unexpected error in logout: $e');
        debugPrint('[AuthRepository] StackTrace: $st');
      }
      return const Left(AuthFailure('An unexpected error occurred.'));
    } finally {
      await _offlineLocalDataSource.clearAll();
      await _secureStorageService.clearAll();
      await _sharedPrefsService.clearAll();
    }
  }

  @override
  Future<Either<Failure, (String, int?)>> resendVerificationCode({
    required String email,
  }) async {
    try {
      final response = await _remoteDataSource.resendVerification(email);
      return Right((response.message, response.coolDown));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[AuthRepository] Unexpected error in resendVerificationCode: $e',
        );
        debugPrint('[AuthRepository] StackTrace: $st');
      }
      return const Left(AuthFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final message = await _remoteDataSource.forgotPassword(email);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      final message = await _remoteDataSource.resetPassword(token, newPassword);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure('An unexpected error occurred.'));
    }
  }
}
