import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../notifiers/notification_settings_notifier.dart';

/// Notification preference screen for account activity.
///
/// Each toggle updates optimistically through [notificationSettingsProvider]
/// and surfaces a snackbar when an update fails.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationSettingsProvider);

    ref.listen(notificationSettingsProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update failed. Settings reverted.')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const BackButton(),
      ),
      body: Semantics(
        label: 'Notification preferences',
        child: notificationState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error: $err', textAlign: TextAlign.center),
            ),
          ),
          data: (settings) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _NotificationToggleTile(
                semanticLabel: 'New Followers notification toggle',
                title: 'New Followers',
                subtitle: 'Get notified when someone follows you.',
                value: settings.notifyOnFollow,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleFollow(val),
              ),
              const SizedBox(height: 16),
              _NotificationToggleTile(
                semanticLabel: 'Likes notification toggle',
                title: 'Likes',
                subtitle: 'Get notified when someone likes your track.',
                value: settings.notifyOnLike,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleLike(val),
              ),
              const SizedBox(height: 16),
              _NotificationToggleTile(
                semanticLabel: 'Reposts notification toggle',
                title: 'Reposts',
                subtitle: 'Get notified when someone reposts your track.',
                value: settings.notifyOnRepost,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleRepost(val),
              ),
              const SizedBox(height: 16),
              _NotificationToggleTile(
                semanticLabel: 'Comments notification toggle',
                title: 'Comments and Replies',
                subtitle:
                    'Get notified when someone comments on your track or replies to your comment.',
                value: settings.notifyOnComment,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleComment(val),
              ),
              const SizedBox(height: 16),
              _NotificationToggleTile(
                semanticLabel: 'Direct Messages notification toggle',
                title: 'Direct Messages',
                subtitle: 'Get notified when you receive a new message.',
                value: settings.notifyOnDM,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleDM(val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Accessible toggle row for one notification preference.
class _NotificationToggleTile extends StatelessWidget {
  const _NotificationToggleTile({
    required this.semanticLabel,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String semanticLabel;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: value
          ? 'Currently enabled, tap to disable'
          : 'Currently disabled, tap to enable',
      toggled: value,
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        activeThumbColor: AppColors.primary,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppConstants.fontSizeMedium,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.apple,
              height: 1.4,
              fontSize: AppConstants.fontSizeSmall,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
