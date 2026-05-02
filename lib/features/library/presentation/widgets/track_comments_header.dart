import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/track_comment_provider.dart';
import '../state/track_comment_state.dart';

class TrackCommentsHeader extends ConsumerWidget {
  const TrackCommentsHeader({
    super.key,
    required this.commentCount,
    required this.trackId,
  });

  final int commentCount;
  final int trackId;

  /// Builds the comments header with count and sorting controls.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentSort = ref.watch(trackCommentsProvider(trackId)).sortOption;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 24),
          ),
          Text(
            '$commentCount comments',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => _showSortOptions(context, ref, theme, currentSort),
            child: const Icon(Icons.tune, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  /// Shows the sort option sheet.
  void _showSortOptions(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    CommentSortOption currentSort,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _buildSortOptionTile(
                context,
                ref,
                title: 'Newest',
                option: CommentSortOption.newest,
                currentSort: currentSort,
              ),
              _buildSortOptionTile(
                context,
                ref,
                title: 'Oldest',
                option: CommentSortOption.oldest,
                currentSort: currentSort,
              ),
              _buildSortOptionTile(
                context,
                ref,
                title: 'Track Time',
                option: CommentSortOption.trackTime,
                currentSort: currentSort,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Builds a selectable sort option row.
  Widget _buildSortOptionTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required CommentSortOption option,
    required CommentSortOption currentSort,
  }) {
    final isSelected = option == currentSort;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.black),
            )
          : null,
      onTap: () {
        ref
            .read(trackCommentsProvider(trackId).notifier)
            .changeSortOption(option);
        Navigator.pop(context);
      },
    );
  }
}
