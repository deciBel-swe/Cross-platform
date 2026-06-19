import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../../upload/presentation/providers/upload_notifier.dart';
import '../providers/track_edit_provider.dart';
import '../state/track_edit_state.dart';

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
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit track'),
      ),
      body: Semantics(
        container: true,
        explicitChildNodes: true,
        label: 'Edit track screen',
        child: editAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load track editor.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.onPrimary),
          ),
        ),
        data: (state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditFileSelectionHeader(
                    state: state,
                    onPickCover: notifier.pickCoverImage,
                    onRemoveCover: notifier.markCoverForRemoval,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderDark),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.title,
                          onChanged: notifier.updateTitle,
                          enabled: !state.isSubmitting,
                          maxLength: 200,
                          style: const TextStyle(color: AppColors.onPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Title *',
                            labelStyle: TextStyle(color: AppColors.textMuted),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (value.trim().length > 200) {
                              return 'Title must be less than 200 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Genre *',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildGenreChip(
                                context,
                                'PICK GENRE',
                                Icons.search,
                                isSelected: false,
                                onTap: state.isSubmitting
                                    ? null
                                    : () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              FractionallySizedBox(
                                                heightFactor: 0.7,
                                                child: _EditGenreBottomSheet(
                                                  trackId: widget.trackId,
                                                ),
                                              ),
                                        );
                                      },
                              ),
                              if (state.genre.isNotEmpty &&
                                  !notifier.genreSuggestions.contains(
                                    state.genre,
                                  ))
                                _buildGenreChip(
                                  context,
                                  state.genre,
                                  null,
                                  isSelected: true,
                                  onTap: () {},
                                ),
                              ...notifier.genreSuggestions.map(
                                (genreName) => _buildGenreChip(
                                  context,
                                  genreName,
                                  null,
                                  isSelected: state.genre == genreName,
                                  onTap: state.isSubmitting
                                      ? null
                                      : () => notifier.updateGenre(genreName),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: AppColors.borderLight, height: 32),
                        Semantics(
                          button: true,
                          enabled: !state.isSubmitting,
                          label: state.tags.isEmpty
                              ? 'Add tags'
                              : 'Edit tags, ${state.tags.join(', ')}',
                          hint: 'Opens tag editor',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Tags',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            subtitle: Text(
                              state.tags.isEmpty
                                  ? 'Add tags to describe track for reachability'
                                  : state.tags.join(', '),
                              style: const TextStyle(
                                color: AppColors.onPrimary,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.textMuted,
                              size: 16,
                            ),
                            onTap: state.isSubmitting
                                ? null
                                : () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          _EditTagsBottomSheet(
                                            trackId: widget.trackId,
                                          ),
                                    );
                                  },
                          ),
                        ),
                        const Divider(color: AppColors.borderLight),
                        const SizedBox(height: 16),
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Privacy',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        IgnorePointer(
                          ignoring: state.isSubmitting,
                          child: RadioGroup<bool>(
                            groupValue: state.isPrivate,
                            onChanged: (val) {
                              if (val != null) {
                                notifier.updateIsPrivate(val);
                              }
                            },
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Radio<bool>(value: false),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Public',
                                            style: TextStyle(
                                              color: AppColors.onPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Anyone can find this',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<bool>(value: true),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Unlisted (Private)',
                                            style: TextStyle(
                                              color: AppColors.onPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Anyone with private link can access',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              if (state.genre.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Genre is required'),
                                  ),
                                );
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
                              ref
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
                      child: Semantics(
                        button: true,
                        enabled: !state.isSubmitting,
                        label: state.isSubmitting
                            ? 'Saving track changes'
                            : 'Save track changes',
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}

Widget _buildGenreChip(
  BuildContext context,
  String label,
  IconData? icon, {
  required bool isSelected,
  VoidCallback? onTap,
}) {
  return Semantics(
    button: true,
    selected: isSelected,
    enabled: onTap != null,
    label: isSelected ? '$label genre selected' : 'Choose $label genre',
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: isSelected ? AppColors.onPrimary : Colors.transparent,
        side: BorderSide(
          color: isSelected ? AppColors.onPrimary : AppColors.borderLight,
        ),
        avatar: icon != null
            ? Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.background : AppColors.onPrimary,
              )
            : null,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.onPrimary,
            fontSize: 12,
          ),
        ),
        onPressed: onTap,
      ),
    ),
  );
}

class _EditGenreBottomSheet extends ConsumerWidget {
  const _EditGenreBottomSheet({required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGenres = ref.watch(genreListProvider);
    final currentGenre = ref
        .watch(trackEditProvider(trackId))
        .valueOrNull
        ?.genre;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pick genre',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: allGenres.length,
              itemBuilder: (context, index) {
                final genre = allGenres[index];
                final isSelected = currentGenre == genre;

                return ListTile(
                  title: Text(
                    genre,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref
                        .read(trackEditProvider(trackId).notifier)
                        .updateGenre(genre);
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTagsBottomSheet extends ConsumerStatefulWidget {
  const _EditTagsBottomSheet({required this.trackId});

  final int trackId;

  @override
  ConsumerState<_EditTagsBottomSheet> createState() =>
      _EditTagsBottomSheetState();
}

class _EditTagsBottomSheetState extends ConsumerState<_EditTagsBottomSheet> {
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
    final currentTags =
        ref.read(trackEditProvider(widget.trackId)).valueOrNull?.tags ?? [];

    if (_errorMessage != null || sanitized.isEmpty) {
      return;
    }

    if (currentTags.contains(sanitized)) {
      setState(() => _errorMessage = 'Tag already exists');
      return;
    }

    if (sanitized.length >= 3 && sanitized.length <= 20) {
      ref.read(trackEditProvider(widget.trackId).notifier).addTag(sanitized);
      _tagController.clear();
      setState(() => _errorMessage = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(trackEditProvider(widget.trackId));
    final tags = editState.valueOrNull?.tags ?? const <String>[];
    final isAtLimit = tags.length >= 10;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
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
                '${tags.length}/10',
                style: TextStyle(
                  color: isAtLimit ? AppColors.errors : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tagController,
            enabled: !isAtLimit,
            onChanged: _validateInput,
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
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: tags
                .map(
                  (tag) => InputChip(
                    label: Text(
                      tag,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.surfaceVariant,
                    deleteIconColor: AppColors.textMuted,
                    onDeleted: () {
                      ref
                          .read(trackEditProvider(widget.trackId).notifier)
                          .removeTag(tag);
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

class _EditFileSelectionHeader extends StatelessWidget {
  const _EditFileSelectionHeader({
    required this.state,
    required this.onPickCover,
    required this.onRemoveCover,
  });

  final TrackEditState state;
  final VoidCallback onPickCover;
  final VoidCallback onRemoveCover;

  @override
  Widget build(BuildContext context) {
    final hasNetworkCover =
        !state.removeCover &&
        state.currentCoverUrl != null &&
        state.currentCoverUrl!.isNotEmpty;

    DecorationImage? image;
    if (state.newCoverImage != null) {
      image = DecorationImage(
        image: FileImage(state.newCoverImage!),
        fit: BoxFit.cover,
      );
    } else if (hasNetworkCover) {
      image = DecorationImage(
        image: CachedNetworkImageProvider(state.currentCoverUrl!),
        fit: BoxFit.cover,
      );
    }

    String coverName;
    if (state.newCoverImage != null) {
      coverName = state.newCoverImage!.path.split('/').last;
    } else if (hasNetworkCover) {
      coverName = state.currentCoverUrl!.split('/').last;
    } else {
      coverName = 'No cover selected';
    }

    return Row(
      children: [
        Semantics(
          button: true,
          image: image != null,
          enabled: !state.isSubmitting,
          label: image == null ? 'Add cover image' : 'Change cover image',
          hint: 'Opens image picker',
          child: GestureDetector(
            onTap: state.isSubmitting ? null : onPickCover,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDark),
              image: image,
            ),
            child: image == null
                ? const ExcludeSemantics(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textSecondary,
                      size: 30,
                    ),
                  )
                : null,
          ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cover image',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                coverName,
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Semantics(
                    button: true,
                    enabled: !state.isSubmitting,
                    label: 'Replace cover image',
                    child: OutlinedButton(
                      onPressed: state.isSubmitting ? null : onPickCover,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.onPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: AppColors.onPrimary,
                      ),
                      child: const Text('Replace cover'),
                    ),
                  ),
                  Semantics(
                    button: true,
                    enabled: !state.isSubmitting,
                    label: 'Remove cover image',
                    child: OutlinedButton(
                      onPressed: state.isSubmitting ? null : onRemoveCover,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text('Remove cover'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
