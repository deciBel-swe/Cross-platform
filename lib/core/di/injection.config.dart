// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:decibel/core/di/register_module.dart' as _i787;
import 'package:decibel/core/network/dio_client.dart' as _i354;
import 'package:decibel/core/storage/secure_storage_service.dart' as _i953;
import 'package:decibel/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i414;
import 'package:decibel/features/auth/data/repositories/auth_repository.dart'
    as _i399;
import 'package:decibel/features/auth/data/repositories/mock_auth_repository.dart'
    as _i760;
import 'package:decibel/features/auth/domain/repositories/i_auth_repository.dart'
    as _i823;
import 'package:decibel/features/library/data/datasources/library_remote_datasource.dart'
    as _i928;
import 'package:decibel/features/library/data/repositories/image_repository_impl.dart'
    as _i719;
import 'package:decibel/features/library/data/repositories/mock_track_repository_impl.dart'
    as _i598;
import 'package:decibel/features/library/data/repositories/track_repository_impl.dart'
    as _i536;
import 'package:decibel/features/library/domain/repositories/image_repository.dart'
    as _i565;
import 'package:decibel/features/library/domain/repositories/track_repository.dart'
    as _i40;
import 'package:decibel/features/upload/data/datasources/upload_remote_datasource.dart'
    as _i255;
import 'package:decibel/features/upload/data/repository/upload_repository_impl.dart'
    as _i646;
import 'package:decibel/features/upload/domain/repositories/i_upload_repository.dart'
    as _i664;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

const String _mock = 'mock';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i40.TrackRepository>(
      () => _i598.MockTrackRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i823.IAuthRepository>(
      () => _i760.MockAuthRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i354.DioClient>(() => _i354.DioClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i414.IAuthRemoteDataSource>(
      () => _i414.AuthRemoteDataSource(gh<_i354.DioClient>()),
    );
    gh.lazySingleton<_i953.SecureStorageService>(
      () => _i953.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i565.ImageRepository>(
      () => _i719.ImageRepositoryImpl(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i823.IAuthRepository>(
      () => _i399.AuthRepository(
        gh<_i414.IAuthRemoteDataSource>(),
        gh<_i953.SecureStorageService>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i255.UploadRemoteDatasource>(
      () => _i255.UploadRemoteDatasource(gh<_i354.DioClient>()),
    );
    gh.lazySingleton<_i928.LibraryRemoteDatasource>(
      () => _i928.LibraryRemoteDatasource(gh<_i354.DioClient>()),
    );
    gh.lazySingleton<_i40.TrackRepository>(
      () => _i536.TrackRepositoryImpl(gh<_i928.LibraryRemoteDatasource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i664.IUploadRepository>(
      () => _i646.UploadRepository(gh<_i255.UploadRemoteDatasource>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i787.RegisterModule {}
