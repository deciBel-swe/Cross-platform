/// Available app icon options.
enum AppIconOption {
  classic,
  black,
  white,
  style1,
  style2,
  style3,
  style4,
  style5,
  style6White,
  style6Black,
}

extension AppIconOptionX on AppIconOption {
  String get storageKey => name;

  String? get alternateIconName => switch (this) {
    AppIconOption.classic => null,
    AppIconOption.black => 'black',
    AppIconOption.white => 'white',
    AppIconOption.style1 => 'style1',
    AppIconOption.style2 => 'style2',
    AppIconOption.style3 => 'style3',
    AppIconOption.style4 => 'style4',
    AppIconOption.style5 => 'style5',
    AppIconOption.style6White => 'style6White',
    AppIconOption.style6Black => 'style6Black',
  };

  static AppIconOption fromStorage(String? value) {
    return AppIconOption.values.firstWhere(
      (option) => option.storageKey == value,
      orElse: () => AppIconOption.classic,
    );
  }
}
