import '../entities/app_icon_option.dart';

/// Repository contract for reading and updating the active app icon.
abstract class AppIconRepository {
  Future<AppIconOption> getSelectedIcon();

  Future<void> setSelectedIcon(AppIconOption option);

  Future<void> applyIcon(AppIconOption option);
}
