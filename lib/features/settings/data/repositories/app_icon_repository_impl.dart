import 'dart:io';

import 'package:flutter/services.dart';

import 'package:dynamic_app_icon_flutter_plus/dynamic_app_icon_flutter_plus.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/entities/app_icon_option.dart';
import '../../domain/repositories/app_icon_repository.dart';

/// Applies and persists the selected app icon.
class AppIconRepositoryImpl implements AppIconRepository {
  AppIconRepositoryImpl(this._prefsService);

  static const String _storageKey = 'selected_app_icon';

  static final Map<String, String> _desktopIconCache = {};

  final SharedPrefsService _prefsService;

  @override
  Future<AppIconOption> getSelectedIcon() async {
    final stored = await _prefsService.getString(_storageKey);
    return AppIconOptionX.fromStorage(stored);
  }

  @override
  Future<void> setSelectedIcon(AppIconOption option) async {
    await _applyIcon(option);
    await _prefsService.setString(_storageKey, option.storageKey);
  }

  @override
  Future<void> applyIcon(AppIconOption option) async {
    if (_isDesktop) {
      await _applyDesktopIcon(option);
    }
  }

  Future<void> _applyIcon(AppIconOption option) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final isSupported =
          await DynamicAppIconFlutterPlus.supportsAlternateIcons;
      if (isSupported) {
        await DynamicAppIconFlutterPlus.setAlternateIconName(
          option.alternateIconName,
        );
      }
    }

    if (_isDesktop) {
      await _applyDesktopIcon(option);
    }
  }

  Future<void> _applyDesktopIcon(AppIconOption option) async {
    final assetPath = _desktopAssetFor(option);
    final iconPath = await _resolveDesktopIconPath(assetPath);
    await windowManager.setIcon(iconPath);
  }

  Future<String> _resolveDesktopIconPath(String assetPath) async {
    final cached = _desktopIconCache[assetPath];
    if (cached != null && File(cached).existsSync()) {
      return cached;
    }

    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final fileName = assetPath.split('/').last;
    final tempDir = await Directory.systemTemp.createTemp('decibel_icon_');
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    _desktopIconCache[assetPath] = file.path;
    return file.path;
  }

  String _desktopAssetFor(AppIconOption option) {
    if (Platform.isWindows) {
      return switch (option) {
        AppIconOption.classic => AppAssets.desktopIconClassic,
        AppIconOption.black => AppAssets.desktopIconBlack,
        AppIconOption.white => AppAssets.desktopIconWhite,
        AppIconOption.style1 => AppAssets.style1Icon,
        AppIconOption.style2 => AppAssets.style2Icon,
      };
    }

    return switch (option) {
      AppIconOption.classic => AppAssets.appIcon,
      AppIconOption.black => AppAssets.blackLogo,
      AppIconOption.white => AppAssets.whiteLogo,
      AppIconOption.style1 => AppAssets.style1Icon,
      AppIconOption.style2 => AppAssets.style2Icon,
    };
  }

  bool get _isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
