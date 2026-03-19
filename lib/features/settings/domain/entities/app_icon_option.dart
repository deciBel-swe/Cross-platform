/// Available app icon options.
enum AppIconOption { classic, black, white, style1, style2 }

extension AppIconOptionX on AppIconOption {
  String get storageKey => name;

  String? get alternateIconName => switch (this) {
    AppIconOption.classic => null,
    AppIconOption.black => 'black',
    AppIconOption.white => 'white',
    AppIconOption.style1 => 'style1',
    AppIconOption.style2 => 'style2',
  };

  static AppIconOption fromStorage(String? value) {
    return AppIconOption.values.firstWhere(
      (option) => option.storageKey == value,
      orElse: () => AppIconOption.classic,
    );
  }
}
