import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/engagement/data/repositories/mock_follow_repository_impl.dart';
import '../../features/engagement/domain/repositories/follow_repository.dart';
import '../../features/library_profile/data/repositories/mock_genre_repository_impl.dart';
import '../../features/library_profile/data/repositories/mock_profile_repository_impl.dart';
import '../../features/library_profile/domain/repositories/genre_repository.dart';
import '../../features/library_profile/domain/repositories/profile_repository.dart';
import '../../features/playlists/data/repositories/mock_playlist_repository.dart';
import '../../features/playlists/domain/repositories/i_playlist_repository.dart';
import '../../features/settings/data/repositories/mock_notification_settings_repository.dart';
import '../../features/settings/data/repositories/mock_social_settings_repository_impl.dart';
import '../../features/settings/data/repositories/notification_settings_repository_impl.dart';
import '../../features/settings/data/repositories/social_settings_repository_impl.dart';
import '../../features/settings/domain/repositories/notification_settings_repository.dart';
import '../../features/settings/domain/repositories/social_settings_repository.dart';
import '../network/dio_client.dart';
import '../storage/shared_prefs_service.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies({required bool useMockServices}) {
  final environment = useMockServices ? 'mock' : Environment.prod;
  getIt.init(environment: environment);
  _registerManualDependencies(useMockServices: useMockServices);
}

void _registerManualDependencies({required bool useMockServices}) {
  if (getIt.isRegistered<SocialSettingsRepository>()) {
    getIt.unregister<SocialSettingsRepository>();
  }

  if (useMockServices) {
    getIt.registerLazySingleton<SocialSettingsRepository>(
      () => MockSocialSettingsRepository(getIt<SharedPrefsService>()),
    );

    if (getIt.isRegistered<NotificationSettingsRepository>()) {
      getIt.unregister<NotificationSettingsRepository>();
    }
    getIt.registerLazySingleton<NotificationSettingsRepository>(
      () => MockNotificationSettingsRepository(),
    );

    if (getIt.isRegistered<ProfileRepository>()) {
      getIt.unregister<ProfileRepository>();
    }
    getIt.registerLazySingleton<ProfileRepository>(MockProfileRepository.new);

    if (getIt.isRegistered<AllGenresRepository>()) {
      getIt.unregister<AllGenresRepository>();
    }
    getIt.registerLazySingleton<AllGenresRepository>(
      MockAllGenresRepository.new,
    );

    if (getIt.isRegistered<FollowRepository>()) {
      getIt.unregister<FollowRepository>();
    }
    getIt.registerLazySingleton<FollowRepository>(MockFollowRepository.new);
  } else {
    getIt.registerLazySingleton<SocialSettingsRepository>(
      () => SocialSettingsRepositoryImpl(
        getIt<DioClient>(),
        getIt<SharedPrefsService>(),
      ),
    );

    if (getIt.isRegistered<NotificationSettingsRepository>()) {
      getIt.unregister<NotificationSettingsRepository>();
    }
    getIt.registerLazySingleton<NotificationSettingsRepository>(
      () => NotificationSettingsRepositoryImpl(getIt()),
    );
    if (getIt.isRegistered<IPlaylistRepository>()) {
      getIt.unregister<IPlaylistRepository>(); // Remove the real API repository
    }
    // Inject the mock repository instead
    getIt.registerLazySingleton<IPlaylistRepository>(
      MockPlaylistRepository.new,
    );
  }
}
