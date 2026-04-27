import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/right_side_panel.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';

/// Queue manager bottom sheet.
///
/// - Drag to reorder
/// - Swipe to remove
/// - Tap to play
class QueueBottomSheet extends ConsumerWidget {
  const QueueBottomSheet({super.key, this.asSidePanel = false});

  final bool asSidePanel;

  static Future<void> show(BuildContext context) {
    if (isDesktopPanelLayout(context)) {
      return showRightSidePanel<void>(
        context: context,
        child: const QueueBottomSheet(asSidePanel: true),
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SafeArea(child: QueueBottomSheet()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final audioState = ref.watch(trackAudioProvider);
    final notifier = ref.read(trackAudioProvider.notifier);
    final queue = audioState.queue;
    final currentId = audioState.preparedTrackId;

    return Container(
      constraints: asSidePanel
          ? const BoxConstraints.expand()
          : const BoxConstraints(maxHeight: 520),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: asSidePanel
            ? const BorderRadius.horizontal(left: Radius.circular(18))
            : const BorderRadius.vertical(top: Radius.circular(24)),
        border: asSidePanel
            ? const Border(left: BorderSide(color: Colors.white12, width: 0.5))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Up next',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${queue.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: queue.isEmpty
                ? Center(
                    child: Text(
                      'Queue is empty',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    onReorder: notifier.reorderQueue,
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      final track = queue[index];
                      final isCurrent =
                          currentId != null && track.id == currentId;

                      return Dismissible(
                        key: ValueKey('queue_${track.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: theme.colorScheme.error.withValues(
                            alpha: 0.25,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        onDismissed: (_) => notifier.removeFromQueue(track.id),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(
                              Icons.drag_handle,
                              color: Colors.white54,
                            ),
                          ),
                          title: Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            track.artist.displayName ?? track.artist.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                          trailing: isCurrent
                              ? const Icon(Icons.equalizer, color: Colors.white)
                              : null,
                          onTap: () async {
                            await notifier.playFromQueueIndex(index);
                          },
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
