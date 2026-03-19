import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_icon_option.dart';
import '../providers/app_icon_provider.dart';

class AppIconNotifier extends AsyncNotifier<AppIconOption> {
  @override
  Future<AppIconOption> build() async {
    final repository = ref.read(appIconRepositoryProvider);
    final selected = await repository.getSelectedIcon();

    if (_isDesktop) {
      await repository.applyIcon(selected);
    }

    return selected;
  }

  Future<void> setIcon(AppIconOption option) async {
    final repository = ref.read(appIconRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.setSelectedIcon(option);
      return option;
    });
  }

  bool get _isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
