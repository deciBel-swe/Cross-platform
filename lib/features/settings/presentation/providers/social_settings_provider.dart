import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/social_settings_repository.dart';

final socialSettingsRepositoryProvider = Provider<SocialSettingsRepository>((
  Ref _,
) {
  return getIt<SocialSettingsRepository>();
});
