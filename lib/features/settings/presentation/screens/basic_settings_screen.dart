import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

/// Basic settings options.
class BasicSettingsScreen extends StatelessWidget {
  const BasicSettingsScreen({super.key});

  static const String _title = 'Basic Settings';
  static const String _changeIconTitle = 'Change app icon';
  static const String _changeIconSubtitle =
      'Custom app icons to match your style';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(_changeIconTitle, style: textTheme.titleMedium),
              subtitle: Text(_changeIconSubtitle, style: textTheme.bodySmall),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RoutePaths.changeAppIcon),
            ),
          ),
        ],
      ),
    );
  }
}
