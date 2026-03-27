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
import '../../features/library/data/datasources/library_remote_datasource.dart'
    as _i534;
import '../../features/library_profile/data/datasources/genre_data_source_remote.dart'
    as _i271;
import '../../features/library_profile/data/datasources/moderation_remote_data_source.dart'
    as _i269;
import '../../features/library_profile/data/datasources/profile_remote_data_source.dart'
    as _i364;
import '../../features/library_profile/data/datasources/track_remote_data_source.dart'
    as _i226;
import '../../features/library_profile/data/repositories/genre_repository_impl.dart'
    as _i140;
import '../../features/library_profile/data/repositories/image_repository_impl.dart'
    as _i423;
import '../../features/library_profile/data/repositories/mock_track_repository_impl.dart'
    as _i690;
import '../../features/library_profile/data/repositories/moderation_repository_impl.dart'
    as _i810;
import '../../features/library_profile/data/repositories/profile_repository_impl.dart'
    as _i997;
import '../../features/library_profile/data/repositories/track_repository_impl.dart'
    as _i928;
import '../../features/library_profile/domain/repositories/genre_repository.dart'
    as _i2;
import '../../features/library_profile/domain/repositories/image_repository.dart'
    as _i121;
import '../../features/library_profile/domain/repositories/moderation_repository.dart'
    as _i11;
import '../../features/library_profile/domain/repositories/profile_repository.dart'
    as _i106;
import '../../features/library_profile/domain/repositories/track_repository.dart'
    as _i127;
import '../../features/library_profile/domain/repositories/update_image.dart'
    as _i728;
import '../../features/upload/data/datasources/upload_remote_datasource.dart'
    as _i464;
import '../../features/upload/data/repository/mock_upload_repository_impl.dart'
    as _i580;
import '../../features/upload/data/repository/upload_repository_impl.dart'
    as _i469;
import '../../features/upload/domain/repositories/i_upload_repository.dart'
    as _i43;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../storage/secure_storage_service.dart' as _i666;
import 'register_module.dart' as _i291;

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
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i361.Dio>(),
        authInterceptor: gh<_i745.AuthInterceptor>(),
      ),
    );
    gh.lazySingleton<_i226.ITrackRemoteDataSource>(
      () => _i226.TrackRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i271.IGenreRemoteDataSource>(
      () => _i271.GenreRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.factory<_i464.UploadRemoteDatasource>(
      () => _i464.UploadRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i534.LibraryRemoteDatasource>(
      () => _i534.LibraryRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i127.TrackRepository>(
      () => _i690.MockTrackRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i269.IModerationRemoteDataSource>(
      () => _i269.ModerationRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i43.IUploadRepository>(
      () => const _i580.MockUploadRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i364.IProfileRemoteDataSource>(
      () => _i364.ProfileRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i107.IAuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i106.ProfileRepository>(
      () => _i997.ProfileRepositoryImpl(gh<_i364.IProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i43.IUploadRepository>(
      () => _i469.UploadRepository(gh<_i464.UploadRemoteDatasource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i121.ImageRepository>(
      () => _i423.ImageRepositoryImpl(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i573.AuthRepository(
        gh<_i107.IAuthRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i2.AllGenresRepository>(
      () => _i140.AllGenresRepositoryImpl(
        remoteDataSource: gh<_i271.IGenreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i728.UpdateProfileImagesUseCase>(
      () => _i728.UpdateProfileImagesUseCase(gh<_i106.ProfileRepository>()),
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i703.MockAuthRepository(gh<_i666.SecureStorageService>()),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i127.TrackRepository>(
      () => _i928.TrackRepositoryImpl(gh<_i534.LibraryRemoteDatasource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i11.ModerationRepository>(
      () => _i810.ModerationRepositoryImpl(
        gh<_i269.IModerationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => registerModule.getAuthInterceptor(gh<_i666.SecureStorageService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
