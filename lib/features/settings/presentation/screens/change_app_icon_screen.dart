import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/app_icon_option.dart';
import '../providers/app_icon_provider.dart';

/// Lets the user pick the app's launcher icon.
///
/// The selected option is provided by [appIconProvider] and updated as soon as
/// the user taps a different icon.
class ChangeAppIconScreen extends ConsumerWidget {
  const ChangeAppIconScreen({super.key});

  static const String title = 'Change app icon';
  static const String _errorMessage = 'Unable to load app icon options';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconsAsync = ref.watch(appIconProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(ChangeAppIconScreen.title)),
      body: iconsAsync.when(
        data: (selected) => ListView(
          padding: const EdgeInsets.all(16),
          children: AppIconOption.values
              .map(
                (option) => _AppIconOptionTile(
                  option: option,
                  isSelected: option == selected,
                  onTap: () {
                    if (option == selected) {
                      return;
                    }
                    ref.read(appIconProvider.notifier).setIcon(option);
                  },
                ),
              )
              .toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text(_errorMessage)),
      ),
    );
  }
}

/// Single selectable row for one [AppIconOption].
class _AppIconOptionTile extends StatelessWidget {
  const _AppIconOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final AppIconOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Image.asset(
              _assetFor(option),
              width: 32,
              height: 32,
              cacheWidth: 128,
              cacheHeight: 128,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_labelFor(option), style: textTheme.bodyLarge),
            ),
            _SelectionIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

/// Circular checkmark shown beside the currently selected app icon.
class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return const SizedBox(width: 24, height: 24);
    }

    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: AppColors.onPrimary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 16,
        color: AppColors.onBackground,
      ),
    );
  }
}

/// Returns the display label for an app icon option.
String _labelFor(AppIconOption option) {
  return switch (option) {
    AppIconOption.classic => 'Classic',
    AppIconOption.black => 'Black',
    AppIconOption.white => 'White',
    AppIconOption.style1 => 'Style 1',
    AppIconOption.style2 => 'Style 2',
    AppIconOption.style3 => 'Style 3',
    AppIconOption.style4 => 'Style 4',
    AppIconOption.style5 => 'Style 5',
    AppIconOption.style6White => 'Style 6 (White)',
    AppIconOption.style6Black => 'Style 6 (Black)',
  };
}

/// Returns the bundled image asset for an app icon option.
String _assetFor(AppIconOption option) {
  return switch (option) {
    AppIconOption.classic => AppAssets.appIcon,
    AppIconOption.black => AppAssets.blackLogo,
    AppIconOption.white => AppAssets.whiteLogo,
    AppIconOption.style1 => AppAssets.style1Icon,
    AppIconOption.style2 => AppAssets.style2Icon,
    AppIconOption.style3 => AppAssets.style3Icon,
    AppIconOption.style4 => AppAssets.style4Icon,
    AppIconOption.style5 => AppAssets.style5Icon,
    AppIconOption.style6White => AppAssets.style6WhiteIcon,
    AppIconOption.style6Black => AppAssets.style6BlackIcon,
  };
}
