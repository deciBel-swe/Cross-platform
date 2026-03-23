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
  String? _errorMessage;

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = null;
      } else if (value.contains(' ')) {
        _errorMessage = 'No spaces allowed (use underscores)';
      } else if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(value)) {
        _errorMessage = 'Only letters, numbers, and underscores';
      } else if (value.length < 3) {
        _errorMessage = 'Too short (min 3 chars)';
      } else if (value.length > 20) {
        _errorMessage = 'Too long (max 20 chars)';
      } else {
        _errorMessage = null;
      }
    });
  }

  void _handleSubmitted(String value) {
    final sanitized = value.trim();
    final currentTags = ref.read(uploadNotifierProvider).value?.tags ?? [];

    // 1. Check current error status
    if (_errorMessage != null || sanitized.isEmpty) return;

    // 2. Check for duplicates
    if (currentTags.contains(sanitized)) {
      setState(() => _errorMessage = 'Tag already exists');
      return;
    }

    // 3. Final length check
    if (sanitized.length >= 3 && sanitized.length <= 20) {
      ref.read(uploadNotifierProvider.notifier).addTag(sanitized);
      _tagController.clear();
      setState(() => _errorMessage = null);
    }
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

            onChanged: (value) => _validateInput(value),
            style: const TextStyle(color: AppColors.onPrimary),
            maxLength: 20,
            decoration: InputDecoration(
              hintText: 'e.g. decibel_1',
              hintStyle: const TextStyle(color: AppColors.textHint),

              errorText: _errorMessage,

              helperText: isAtLimit
                  ? 'Limit reached. Delete a tag to add more.'
                  : 'Letters, numbers, and underscores only.',

              helperStyle: TextStyle(
                color: isAtLimit ? AppColors.errors : AppColors.textMuted,
              ),

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
            onSubmitted: _handleSubmitted,
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
