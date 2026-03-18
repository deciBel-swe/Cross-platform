import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../data/repositories/social_settings_repositor_impl.dart';
import '../../domain/repositories/social_settings_repository.dart';

final socialSettingsRepositoryProvider = Provider<SocialSettingsRepository>((Ref ref) {
  final api = ref.watch(apiClientProvider);
  final cache = ref.watch(sharedPrefsServiceProvider);
  
  return SocialSettingsRepositoryImpl(api, cache);
});
