import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/app_icon_option.dart';
import '../../domain/repositories/app_icon_repository.dart';
import '../notifiers/app_icon_notifier.dart';

final appIconRepositoryProvider = Provider<AppIconRepository>((_) {
  return getIt<AppIconRepository>();
});

final appIconProvider = AsyncNotifierProvider<AppIconNotifier, AppIconOption>(
  AppIconNotifier.new,
);
