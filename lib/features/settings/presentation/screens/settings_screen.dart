import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

/// Settings window that surfaces configurable app preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String _title = 'Settings';
  static const String _basicSettingsTitle = 'Basic Settings';
  static const String _basicSettingsSubtitle = 'Core app preferences';

  @override
  Widget build(BuildContext context) {
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
