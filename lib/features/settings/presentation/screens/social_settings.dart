import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../notifiers/social_settings_notifier.dart';

class SocialSettingsScreen extends ConsumerWidget {
  const SocialSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialState = ref.watch(socialSettingsProvider);

    // Watch for errors to show the rollback notification
    ref.listen(socialSettingsProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update failed. Settings reverted.')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Settings'),
        leading: const BackButton(),
      ),
      body: socialState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _SocialToggleTile(
              title: 'Private Profile',
              subtitle:
                  'When enabled, your profile is hidden from discovery and public lists.',
              value: settings.isPrivate,
              onChanged: (val) => ref
                  .read(socialSettingsProvider.notifier)
                  .toggleProfilePrivacy(val),
            ),
            const SizedBox(height: 16),
            _SocialToggleTile(
              title: 'Show Listening History',
              subtitle:
                  'Allow other users to see what you have been listening to lately.',
              value: settings.showHistory,
              onChanged: (val) => ref
                  .read(socialSettingsProvider.notifier)
                  .toggleHistoryVisibility(val),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialToggleTile extends StatelessWidget {
  const _SocialToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: AppColors.primary,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          subtitle,
          style: const TextStyle(color: AppColors.primary, height: 1.4),
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
