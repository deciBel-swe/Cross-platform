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
    debugPrint('[AppResetNotifier] STARTING TOTAL PURIFICATION...');

    // 1. Clear Image Caches (RAM)
    debugPrint('[AppResetNotifier] Clearing PaintingBinding ImageCache...');
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // 2. Clear Image Caches (Disk)
    debugPrint('[AppResetNotifier] Clearing DefaultCacheManager (Disk)...');
    try {
      await DefaultCacheManager().emptyCache();
    } catch (e) {
      debugPrint('[AppResetNotifier] Failed to clear disk cache: $e');
    }

    // 3. Reset GetIt (DI)
    debugPrint('[AppResetNotifier] Resetting GetIt Container...');
    await GetIt.instance.reset();

    // 4. Re-initialize DI
    debugPrint(
      '[AppResetNotifier] Re-initializing DI (useMockServices: $_useMockServices)...',
    );
    configureDependencies(useMockServices: _useMockServices);

    // 5. Trigger Riverpod Reset (Destroys the keyed ProviderScope)
    debugPrint('[AppResetNotifier] Triggering Riverpod Key change...');
    state = UniqueKey();
  }
}

/// Provider for the app-wide reset key.
final appResetProvider = NotifierProvider<AppResetNotifier, Key>(
  AppResetNotifier.new,
);
