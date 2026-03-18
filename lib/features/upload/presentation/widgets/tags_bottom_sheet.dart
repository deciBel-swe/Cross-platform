import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

/// A modal bottom sheet that allows users to add and remove tags.
///
/// Enforces a maximum of 10 tags and uses a text field that listens
/// for the "Enter" key (submission) to create new tags.
class TagsBottomSheet extends ConsumerStatefulWidget {
  const TagsBottomSheet({super.key});

  @override
  ConsumerState<TagsBottomSheet> createState() => _TagsBottomSheetState();
}

class _TagsBottomSheetState extends ConsumerState<TagsBottomSheet> {
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global state so the UI updates immediately when a tag is added/removed
    final state = ref.watch(uploadNotifierProvider);
    final metadata = state.value!;
    final isAtLimit = metadata.tags.length >= 10;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        // Add padding for the keyboard so it doesn't cover the input
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Tags',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
              Text(
                '${metadata.tags.length}/10',
                style: TextStyle(
                  color: isAtLimit ? AppColors.errors : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tag Input Field
          TextField(
            controller: _tagController,
            enabled: !isAtLimit, // Disable input if they hit the 10 limit
            style: const TextStyle(color: AppColors.onPrimary),
            decoration: InputDecoration(
              hintText: isAtLimit
                  ? 'Maximum tags reached'
                  : 'Type a tag and press Enter',
              hintStyle: const TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              final trimmed = value.trim();
              if (trimmed.isNotEmpty) {
                // Add the tag via the Notifier
                ref.read(uploadNotifierProvider.notifier).addTag(trimmed);
                // Clear the text field for the next tag
                _tagController.clear();
              }
            },
          ),
          const SizedBox(height: 16),

          // Tags Display Area
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: metadata.tags
                .map(
                  (tag) => InputChip(
                    label: Text(
                      tag,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.surfaceVariant,
                    deleteIconColor: AppColors.textMuted,
                    onDeleted: () {
                      // Remove the tag via the Notifier
                      ref.read(uploadNotifierProvider.notifier).removeTag(tag);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
