import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Settings window that surfaces configurable app preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String _title = 'Settings';
  static const String _basicSettingsTitle = 'Basic Settings';
  static const String _basicSettingsSubtitle = 'Core app preferences';
  static const String _socalSettingsTitle = 'Social Settings';
  static const String _socalSettingsSubtitle = 'Privacy Settings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsNavigationTile(
            title: _basicSettingsTitle,
            subtitle: _basicSettingsSubtitle,
            onTap: () => context.push(RoutePaths.basicSettings),
          ),
          _SettingsNavigationTile(
            title: _socalSettingsTitle,
            subtitle: _socalSettingsSubtitle,
            onTap: () => context.push(RoutePaths.socialSettings),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavigationTile extends StatelessWidget {
  const _SettingsNavigationTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        title: Text(title, style: textTheme.titleMedium),
        subtitle: Text(subtitle, style: textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
