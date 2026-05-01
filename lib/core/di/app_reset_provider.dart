import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'injection.dart';

/// Notifier that manages a [Key] used to reset the entire [ProviderScope].
///
/// Under the "Total Purification" strategy, this not only resets the Riverpod
/// graph but also wipes GetIt singletons and clears all image caches (RAM & Disk).
class AppResetNotifier extends Notifier<Key> {
  bool _useMockServices = false;

  void setEnvironment({required bool useMockServices}) {
    _useMockServices = useMockServices;
  }

  @override
  Key build() => const ValueKey('initial_app_key');

  Future<void> reset() async {
    // 1. Clear Image Caches (RAM)
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // 2. Clear Image Caches (Disk)
    try {
      await DefaultCacheManager().emptyCache();
    } catch (e) {
    }

    // 3. Reset GetIt (DI)
    await GetIt.instance.reset();

    // 4. Re-initialize DI
    configureDependencies(useMockServices: _useMockServices);

    // 5. Trigger Riverpod Reset (Destroys the keyed ProviderScope)
    state = UniqueKey();
  }
}

/// Provider for the app-wide reset key.
final appResetProvider = NotifierProvider<AppResetNotifier, Key>(
  AppResetNotifier.new,
);
