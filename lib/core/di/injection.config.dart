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
import '../../features/discovery/data/datasources/discovery_remote_datasource.dart'
    as _i1005;
import '../../features/discovery/data/repositories/discovery_repository_impl.dart'
    as _i366;
import '../../features/discovery/data/repositories/mock_discovery_repository.dart'
    as _i614;
import '../../features/discovery/domain/repositories/discovery_repository.dart'
    as _i949;
import '../../features/engagement/data/datasources/follow_remote_data_source.dart'
    as _i485;
import '../../features/engagement/data/datasources/playlist_social_remote_datasource.dart'
    as _i127;
import '../../features/engagement/data/datasources/track_social_remote_datasource.dart'
    as _i459;
import '../../features/engagement/data/repositories/follow_repository_impl.dart'
    as _i666;
import '../../features/engagement/data/repositories/mock_playlist_social_repository_impl.dart'
    as _i773;
import '../../features/engagement/data/repositories/mock_track_social_repository_impl.dart'
    as _i872;
import '../../features/engagement/data/repositories/playlist_social_repository_impl.dart'
    as _i565;
import '../../features/engagement/data/repositories/track_social_repository_impl.dart'
    as _i529;
import '../../features/engagement/domain/repositories/follow_repository.dart'
    as _i557;
import '../../features/engagement/domain/repositories/playlist_social_repository.dart'
    as _i914;
import '../../features/engagement/domain/repositories/track_social_repository.dart'
    as _i590;
import '../../features/feed/data/datasources/feed_data_datasource.dart'
    as _i684;
import '../../features/feed/data/repositories/feed_repository_impl.dart'
    as _i452;
import '../../features/feed/domain/repositories/i_feed_repository.dart'
    as _i695;
import '../../features/home/data/datasources/history_remote_datasource.dart'
    as _i870;
import '../../features/home/data/repositories/history_repository_impl.dart'
    as _i694;
import '../../features/home/domain/repositories/history_repository.dart'
    as _i419;
import '../../features/library/data/datasources/library_remote_datasource.dart'
    as _i534;
import '../../features/library/data/datasources/track_comments_remote_data_source.dart'
    as _i688;
import '../../features/library/data/repositories/track_comments_mock_repository.dart'
    as _i238;
import '../../features/library/data/repositories/track_comments_repository.dart'
    as _i229;
import '../../features/library/domain/repositories/i_track_comments_repository.dart'
    as _i226;
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
import '../../features/notifications/data/datasources/notification_remote_datasource.dart'
    as _i923;
import '../../features/notifications/domain/repositories/notification_repository.dart'
    as _i367;
import '../../features/offline/data/datasources/offline_local_data_source.dart'
    as _i776;
import '../../features/offline/data/repositories/offline_repository_impl.dart'
    as _i720;
import '../../features/offline/domain/repositories/i_offline_repository.dart'
    as _i753;
import '../../features/offline/domain/usecases/download_track_usecase.dart'
    as _i272;
import '../../features/offline/domain/usecases/get_offline_tracks_usecase.dart'
    as _i212;
import '../../features/playlists/data/datasources/playlist_remote_datasource.dart'
    as _i108;
import '../../features/playlists/data/repositories/playlist_repository.dart'
    as _i757;
import '../../features/playlists/domain/repositories/i_playlist_repository.dart'
    as _i582;
import '../../features/settings/data/datasources/blocked_users_remote_datasource.dart'
    as _i688;
import '../../features/settings/data/datasources/change_email_remote_datasource.dart'
    as _i707;
import '../../features/settings/data/datasources/messaging_remote_datasource.dart'
    as _i123;
import '../../features/settings/data/datasources/notification_settings_remote_datasource.dart'
    as _i92;
import '../../features/settings/data/repositories/app_icon_repository_impl.dart'
    as _i781;
import '../../features/settings/data/repositories/blocked_users_repository_impl.dart'
    as _i292;
import '../../features/settings/data/repositories/change_email_repository_impl.dart'
    as _i225;
import '../../features/settings/data/repositories/messaging_repository_implementation.dart'
    as _i343;
import '../../features/settings/domain/repositories/app_icon_repository.dart'
    as _i993;
import '../../features/settings/domain/repositories/blocked_users_repository.dart'
    as _i288;
import '../../features/settings/domain/repositories/change_email_repository.dart'
    as _i346;
import '../../features/settings/domain/repositories/i_messaging_repository.dart'
    as _i23;
import '../../features/upload/data/datasources/upload_remote_datasource.dart'
    as _i464;
import '../../features/upload/data/repository/mock_upload_repository_impl.dart'
    as _i580;
import '../../features/upload/data/repository/upload_repository_impl.dart'
    as _i469;
import '../../features/upload/domain/repositories/i_upload_repository.dart'
    as _i43;
import '../network/dio_client.dart' as _i667;
import '../network/firebase_messaging_service.dart.dart' as _i565;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/websocket_client.dart' as _i777;
import '../storage/secure_storage_service.dart' as _i666;
import '../storage/shared_prefs_service.dart' as _i573;
import 'register_module.dart' as _i291;

const String _mock = 'mock';
const String _dev = 'dev';
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
    gh.lazySingleton<_i565.FirebaseMessagingService>(
      () => _i565.FirebaseMessagingService(),
    );
    gh.lazySingleton<_i573.SharedPrefsService>(
      () => _i573.SharedPrefsService(),
    );
    gh.lazySingleton<_i949.DiscoveryRepository>(
      () => const _i614.MockDiscoveryRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i361.Dio>(),
        authInterceptor: gh<_i745.AuthInterceptor>(),
      ),
    );
    gh.lazySingleton<_i923.INotificationRemoteDataSource>(
      () => _i923.NotificationRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i226.ITrackRemoteDataSource>(
      () => _i226.TrackRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i684.IFeedRemoteDatasource>(
      () => _i684.FeedRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i226.ITrackCommentsRepository>(
      () => _i238.TrackCommentsMockRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i914.IPlaylistSocialRepository>(
      () => _i773.MockPlaylistSocialRepositoryImpl(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i271.IGenreRemoteDataSource>(
      () => _i271.GenreRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.factory<_i459.TrackSocialRemoteDatasource>(
      () => _i459.TrackSocialRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.factory<_i127.PlaylistSocialRemoteDatasource>(
      () => _i127.PlaylistSocialRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i870.HistoryRemoteDatasource>(
      () => _i870.HistoryRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i534.LibraryRemoteDatasource>(
      () => _i534.LibraryRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i776.OfflineLocalDataSource>(
      () => _i776.OfflineLocalDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i688.BlockedUsersRemoteDatasource>(
      () => _i688.BlockedUsersRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i707.ChangeEmailRemoteDatasource>(
      () => _i707.ChangeEmailRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i92.NotificationSettingsRemoteDatasource>(
      () => _i92.NotificationSettingsRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i419.HistoryRepository>(
      () => _i694.HistoryRepositoryImpl(gh<_i870.HistoryRemoteDatasource>()),
    );
    gh.lazySingleton<_i127.TrackRepository>(
      () => _i690.MockTrackRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i590.ITrackSocialRepository>(
      () => _i872.MockTrackSocialRepository(),
      registerFor: {_mock},
    );
    gh.factory<_i108.IPlaylistRemoteDataSource>(
      () => _i108.PlaylistRemoteDatasource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i269.IModerationRemoteDataSource>(
      () => _i269.ModerationRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i43.IUploadRepository>(
      () => const _i580.MockUploadRepository(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i753.IOfflineRepository>(
      () => _i720.OfflineRepositoryImpl(gh<_i776.OfflineLocalDataSource>()),
    );
    gh.lazySingleton<_i364.IProfileRemoteDataSource>(
      () => _i364.ProfileRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.factory<_i123.IMessagingRemoteDataSource>(
      () => _i123.MessagingRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i107.IAuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i485.IFollowRemoteDataSource>(
      () => _i485.FollowRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i993.AppIconRepository>(
      () => _i781.AppIconRepositoryImpl(gh<_i573.SharedPrefsService>()),
    );
    gh.lazySingleton<_i106.ProfileRepository>(
      () => _i997.ProfileRepositoryImpl(gh<_i364.IProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i695.IFeedRepository>(
      () => _i452.FeedRepositoryImpl(gh<_i684.IFeedRemoteDatasource>()),
      registerFor: {_prod},
    );
    gh.factory<_i367.INotificationRepository>(
      () => _i367.NotificationRepository(
        gh<_i923.INotificationRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1005.DiscoveryRemoteDataSource>(
      () => _i1005.DiscoveryRemoteDataSourceImpl(gh<_i667.DioClient>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i121.ImageRepository>(
      () => _i423.ImageRepositoryImpl(gh<_i183.ImagePicker>()),
    );
    gh.factory<_i914.IPlaylistSocialRepository>(
      () => _i565.PlaylistSocialRepositoryImpl(
        gh<_i127.PlaylistSocialRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i589.IAuthRepository>(
      () => _i573.AuthRepository(
        gh<_i107.IAuthRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
        gh<_i573.SharedPrefsService>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i346.ChangeEmailRepository>(
      () => _i225.ChangeEmailRepositoryImpl(
        gh<_i707.ChangeEmailRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i590.ITrackSocialRepository>(
      () => _i529.TrackSocialRepositoryImpl(
        gh<_i459.TrackSocialRemoteDatasource>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i949.DiscoveryRepository>(
      () =>
          _i366.DiscoveryRepositoryImpl(gh<_i1005.DiscoveryRemoteDataSource>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i23.IMessagingRepository>(
      () =>
          _i343.MessagingRepositoryImpl(gh<_i123.IMessagingRemoteDataSource>()),
    );
    gh.lazySingleton<_i272.DownloadTrackUseCase>(
      () => _i272.DownloadTrackUseCase(gh<_i753.IOfflineRepository>()),
    );
    gh.lazySingleton<_i212.GetOfflineTracksUseCase>(
      () => _i212.GetOfflineTracksUseCase(gh<_i753.IOfflineRepository>()),
    );
    gh.factory<_i582.IPlaylistRepository>(
      () => _i757.PlaylistRepository(gh<_i108.IPlaylistRemoteDataSource>()),
    );
    gh.lazySingleton<_i2.AllGenresRepository>(
      () => _i140.AllGenresRepositoryImpl(
        remoteDataSource: gh<_i271.IGenreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i728.UpdateProfileImagesUseCase>(
      () => _i728.UpdateProfileImagesUseCase(gh<_i106.ProfileRepository>()),
    );
    gh.lazySingleton<_i688.ITrackCommentsRemoteDataSource>(
      () => _i688.TrackCommentsRemoteDataSource(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i288.BlockedUsersRepository>(
      () => _i292.BlockedUsersRepositoryImpl(
        gh<_i688.BlockedUsersRemoteDatasource>(),
      ),
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
    gh.lazySingleton<_i557.FollowRepository>(
      () => _i666.FollowRepositoryImpl(gh<_i485.IFollowRemoteDataSource>()),
    );
    gh.lazySingleton<_i745.AuthInterceptor>(
      () => _i745.AuthInterceptor(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i777.WebSocketClient>(
      () => _i777.WebSocketClient(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i226.ITrackCommentsRepository>(
      () => _i229.TrackCommentsRepository(
        gh<_i688.ITrackCommentsRemoteDataSource>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i464.UploadRemoteDatasource>(
      () => _i464.UploadRemoteDatasource(
        gh<_i667.DioClient>(),
        gh<_i777.WebSocketClient>(),
      ),
    );
    gh.lazySingleton<_i43.IUploadRepository>(
      () => _i469.UploadRepository(gh<_i464.UploadRemoteDatasource>()),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
