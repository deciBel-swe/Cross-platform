import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// App icon selector list.
class ChangeAppIconScreen extends StatefulWidget {
  const ChangeAppIconScreen({super.key});

  static const String title = 'Change app icon';

  @override
  State<ChangeAppIconScreen> createState() => _ChangeAppIconScreenState();
}

enum AppIconOption {
  classic('Classic', AppAssets.appIcon),
  black('Black', AppAssets.blackLogo),
  white('White', AppAssets.whiteLogo);

  const AppIconOption(this.label, this.assetPath);

  final String label;
  final String assetPath;
}

class _ChangeAppIconScreenState extends State<ChangeAppIconScreen> {
  AppIconOption _selected = AppIconOption.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ChangeAppIconScreen.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AppIconOption.values
            .map(
              (option) => _AppIconOptionTile(
                option: option,
                isSelected: option == _selected,
                onTap: () => setState(() => _selected = option),
              ),
            )
            .toList(),
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
            Image.asset(option.assetPath, width: 32, height: 32),
            const SizedBox(width: 12),
            Expanded(child: Text(option.label, style: textTheme.bodyLarge)),
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
