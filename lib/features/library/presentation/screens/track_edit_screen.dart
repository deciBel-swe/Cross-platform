import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../providers/track_edit_provider.dart';

class TrackEditScreen extends ConsumerStatefulWidget {
  const TrackEditScreen({super.key, required this.trackId});

  final int trackId;

  @override
  ConsumerState<TrackEditScreen> createState() => _TrackEditScreenState();
}

class _TrackEditScreenState extends ConsumerState<TrackEditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final editAsync = ref.watch(trackEditProvider(widget.trackId));
    final notifier = ref.read(trackEditProvider(widget.trackId).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Edit track'),
      ),
      body: editAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load track editor.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.onPrimary),
          ),
        ),
        data: (state) {
          final tagsInput = state.tags.join(', ');
          final releaseDateText = state.releaseDate == null
              ? 'No date selected'
              : DateFormat('yyyy-MM-dd').format(state.releaseDate!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cover',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  _CoverPreview(
                    currentCoverUrl: state.currentCoverUrl,
                    newCoverImage: state.newCoverImage,
                    removeCover: state.removeCover,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : notifier.pickCoverImage,
                        child: const Text('Replace cover'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : notifier.markCoverForRemoval,
                        child: const Text('Remove cover'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.title,
                    onChanged: notifier.updateTitle,
                    enabled: !state.isSubmitting,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      labelStyle: TextStyle(color: AppColors.textMuted),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      if (value.trim().length > 200) {
                        return 'Title must be less than 200 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: state.genre,
                    onChanged: notifier.updateGenre,
                    enabled: !state.isSubmitting,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Genre *',
                      labelStyle: TextStyle(color: AppColors.textMuted),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Genre is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: state.description,
                    onChanged: notifier.updateDescription,
                    enabled: !state.isSubmitting,
                    maxLines: 4,
                    maxLength: 2000,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: tagsInput,
                    onChanged: notifier.updateTagsFromInput,
                    enabled: !state.isSubmitting,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)',
                      labelStyle: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Release date',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    subtitle: Text(
                      releaseDateText,
                      style: const TextStyle(color: AppColors.onPrimary),
                    ),
                    trailing: IconButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    state.releaseDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                notifier.updateReleaseDate(picked);
                              }
                            },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : notifier.clearReleaseDate,
                    child: const Text('Clear date'),
                  ),
                  SwitchListTile(
                    value: state.isPrivate,
                    onChanged: state.isSubmitting
                        ? null
                        : notifier.updateIsPrivate,
                    title: const Text(
                      'Private',
                      style: TextStyle(color: AppColors.onPrimary),
                    ),
                    subtitle: const Text(
                      'Anyone with private link can access',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final success = await notifier.submit(
                                widget.trackId,
                              );
                              if (!context.mounted) {
                                return;
                              }

                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update track'),
                                  ),
                                );
                                return;
                              }

                              ref.invalidate(
                                trackPreviewProvider(widget.trackId),
                              );
                              await ref
                                  .read(uploadsProvider.notifier)
                                  .refreshTrack(widget.trackId);

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Track updated successfully'),
                                ),
                              );
                              context.pop(true);
                            },
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CoverPreview extends StatelessWidget {
  const _CoverPreview({
    required this.currentCoverUrl,
    required this.newCoverImage,
    required this.removeCover,
  });

  final String? currentCoverUrl;
  final File? newCoverImage;
  final bool removeCover;

  @override
  Widget build(BuildContext context) {
    final hasNetworkCover =
        !removeCover && currentCoverUrl != null && currentCoverUrl!.isNotEmpty;

    final image = switch ((newCoverImage, hasNetworkCover)) {
      (File file, _) => DecorationImage(
        image: FileImage(file),
        fit: BoxFit.cover,
      ),
      (null, true) => DecorationImage(
        image: NetworkImage(currentCoverUrl!),
        fit: BoxFit.cover,
      ),
      _ => null,
    };

    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        image: image,
      ),
      child: image == null
          ? const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textMuted,
              size: 40,
            )
          : null,
    );
  }
}
