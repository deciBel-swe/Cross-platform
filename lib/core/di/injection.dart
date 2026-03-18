/// GetIt + Injectable service locator setup.
library;

import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';

import '../../features/settings/data/repositories/app_icon_repository_impl.dart';
import '../../features/settings/domain/repositories/app_icon_repository.dart';
import '../storage/shared_prefs_service.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init(environment: 'mock');
  _registerSettingsDependencies();
}

void _registerSettingsDependencies() {
  if (!getIt.isRegistered<AppIconRepository>()) {
    getIt.registerLazySingleton<AppIconRepository>(
      () => AppIconRepositoryImpl(SharedPrefsService()),
    );
  }
}
