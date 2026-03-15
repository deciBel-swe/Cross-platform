import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/app_icon_option.dart';
import '../providers/app_icon_provider.dart';

/// App icon selector list.
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

String _labelFor(AppIconOption option) {
  return switch (option) {
    AppIconOption.classic => 'Classic',
    AppIconOption.black => 'Black',
    AppIconOption.white => 'White',
    AppIconOption.style1 => 'Style 1',
    AppIconOption.style2 => 'Style 2',
  };
}

String _assetFor(AppIconOption option) {
  return switch (option) {
    AppIconOption.classic => AppAssets.appIcon,
    AppIconOption.black => AppAssets.blackLogo,
    AppIconOption.white => AppAssets.whiteLogo,
    AppIconOption.style1 => AppAssets.style1Icon,
    AppIconOption.style2 => AppAssets.style2Icon,
  };
}
