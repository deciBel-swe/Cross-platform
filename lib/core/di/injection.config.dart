// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/data/repositories/mock_auth_repository.dart'
    as _i703;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/library/data/repositories/image_repository_impl.dart'
    as _i989;
import '../../features/library/domain/repositories/image_repository.dart'
    as _i925;
import '../../features/upload/data/datasources/upload_remote_datasource.dart'
    as _i464;
import '../../features/upload/data/repository/upload_repository_impl.dart'
    as _i469;
import '../../features/upload/domain/repositories/i_upload_repository.dart'
    as _i43;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../storage/secure_storage_service.dart' as _i666;
import 'register_module.dart' as _i291;

const String _prod = 'prod';
const String _mock = 'mock';

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
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i361.Dio>(),
        authInterceptor: gh<_i745.AuthInterceptor>(),
      ),
    );
    gh.factory<_i464.UploadRemoteDatasource>(
      () => _i464.UploadRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i107.IAuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i925.ImageRepository>(
      () => _i989.ImageRepositoryImpl(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i573.AuthRepository(
        gh<_i107.IAuthRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => registerModule.getAuthInterceptor(gh<_i666.SecureStorageService>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i703.MockAuthRepository(gh<_i666.SecureStorageService>()),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i43.IUploadRepository>(
      () => _i469.UploadRepository(gh<_i464.UploadRemoteDatasource>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
