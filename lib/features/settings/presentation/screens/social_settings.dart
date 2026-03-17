import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../notifiers/social_settings_notifier.dart';

class SocialSettingsScreen extends ConsumerWidget {
  const SocialSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(socialSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Social Settings')),
      body: SafeArea(
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading settings: $err')),
          data: (state) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionHeader('Social networking'),
              _SettingTile(
                title: 'Show comments and reactions on the waveform',
                subtitle: 'Waveform comments and reactions are visible in the fullscreen player',
                value: state.showWaveform,
                onChanged: (val) => ref.read(socialSettingsProvider.notifier).setToggle('waveform', val),
              ),
              _SettingTile(
                title: 'Show my activities in social discovery playlists and modules',
                subtitle: 'Your Likes, Reactions and other engagement may be shown to other users...',
                value: state.showActivities,
                onChanged: (val) => ref.read(socialSettingsProvider.notifier).setToggle('activities', val),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Insights visibility'),
              _SettingTile(
                title: 'Show when I\'m a First or Top Fan',
                subtitle: 'You will appear in public First Fans and Top Fans lists',
                value: state.showTopFan,
                onChanged: (val) => ref.read(socialSettingsProvider.notifier).setToggle('top_fan', val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Private Helper Widgets ---

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _SettingTile extends StatelessWidget {

  const _SettingTile({required this.title, required this.subtitle, required this.value, required this.onChanged});
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged,activeThumbColor:AppColors.proBadge ,),
        ],
      ),
    );
  }
}