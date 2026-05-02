import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/upgrade_remote_datasource.dart';
import '../../data/repositories/upgrade_repository_impl.dart';
import '../../domain/repositories/upgrade_repository.dart';
import '../notifiers/upgrade_notifier.dart';

final upgradeRemoteDatasourceProvider = Provider<IUpgradeRemoteDatasource>((
  ref,
) {
  return UpgradeRemoteDatasource(getIt<DioClient>());
});

final upgradeRepositoryProvider = Provider<UpgradeRepository>((ref) {
  return UpgradeRepositoryImpl(ref.read(upgradeRemoteDatasourceProvider));
});

/// Exposes [SecureStorageService] from GetIt for use in the upgrade notifier.
final secureStorageServiceProvider = Provider<SecureStorageService>(
  (_) => getIt<SecureStorageService>(),
);

final upgradeNotifierProvider =
    AsyncNotifierProvider.autoDispose<UpgradeNotifier, UpgradeViewState>(
      UpgradeNotifier.new,
    );
