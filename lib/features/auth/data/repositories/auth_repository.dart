import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final isExpired = await _secureStorageService.isAccessTokenExpired();
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
  Future<Either<Failure, AuthUser>> loginWithGoogle() async {
    try {
      // Create DeviceInfoModel by gathering real device metrics
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
        // Fallback to defaults if device gathering fails
      }

      final deviceInfo = DeviceInfoModel(
        deviceName: deviceName,
        deviceType: deviceType,
        fingerPrint: fingerPrint,
      );

      final responseModel = await _remoteDataSource.loginWithGoogle(deviceInfo);

      // Save tokens securely
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
      await _secureStorageService.clearAll();
    }
  }
}
