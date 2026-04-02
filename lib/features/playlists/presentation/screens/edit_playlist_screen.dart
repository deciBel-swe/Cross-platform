import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import '../notifiers/playlist_form_notifier.dart';
import '../providers/edit_playlist_provider.dart';
import '../widgets/playlist_details_tab.dart';
import '../widgets/playlist_tracks_tab.dart';

/// Screen for editing metadata and tracks of an existing playlist.
class EditPlaylistScreen extends ConsumerStatefulWidget {
  const EditPlaylistScreen({super.key, required this.playlist});

  final Playlist playlist;

  @override
  ConsumerState<EditPlaylistScreen> createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends ConsumerState<EditPlaylistScreen> {
  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Discard changes?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text(
              'Keep editing',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: const Text(
              'Discard',
              style: TextStyle(color: AppColors.errors),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the form state to disable the save button if loading
    final formState = ref.watch(playlistFormProvider(widget.playlist));

    ref.watch(editPlaylistProvider(widget.playlist));

    final isLoading = formState is AsyncLoading;
    final metadata = formState.value;

    // Disable the save button if the title is empty
    final effectiveTitle = metadata != null
        ? (metadata.title.isEmpty &&
                  widget.playlist.title.isNotEmpty &&
                  metadata.title != ''
              ? widget.playlist.title
              : metadata.title)
        : widget.playlist.title;

    final isTitleValid = effectiveTitle.trim().isNotEmpty;

    // Check if metadata has changed (title, description, privacy, cover image)
    final hasMetadataChanges = ref
        .read(playlistFormProvider(widget.playlist).notifier)
        .hasChanges;

    // Check if track order has changed
    final hasTrackChanges = ref
        .read(editPlaylistProvider(widget.playlist).notifier)
        .hasChanges;

    // The screen has unsaved changes if either the details or tracks were modified
    final bool hasChanges = hasMetadataChanges || hasTrackChanges;

    final canSave = !isLoading && isTitleValid && hasChanges;

    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldDiscard = await _showDiscardDialog();
        if (shouldDiscard && context.mounted) {
          context.pop();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () async {
                if (!hasChanges) {
                  context.pop();
                  // ignore: dead_code
                } else {
                  final shouldDiscard = await _showDiscardDialog();
                  if (shouldDiscard && context.mounted) {
                    context.pop();
                  }
                }
              },
            ),
            title: const Text(
              'Edit',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: [
              // Only show the Save button if there are changes to save
              if (hasChanges)
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: TextButton(
                    // If validation fails disables the button.
                    onPressed: canSave
                        ? () async {
                            bool metadataSuccess = true;
                            bool tracksSuccess = true;

                            if (hasMetadataChanges) {
                              metadataSuccess = await ref
                                  .read(
                                    playlistFormProvider(
                                      widget.playlist,
                                    ).notifier,
                                  )
                                  .submitPlaylist();
                            }

                            if (hasTrackChanges) {
                              tracksSuccess = await ref
                                  .read(
                                    editPlaylistProvider(
                                      widget.playlist,
                                    ).notifier,
                                  )
                                  .saveChanges();
                            }

                            if (metadataSuccess &&
                                tracksSuccess &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Changes saved successfully!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                              context.pop();
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: canSave
                          ? AppColors.textPrimary
                          : AppColors.surfaceVariant,
                      foregroundColor: canSave
                          ? AppColors.background
                          : AppColors.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.background,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
            ],
            bottom: const TabBar(
              indicatorColor: AppColors.textPrimary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textMuted,
              dividerColor: AppColors.borderDark,
              tabs: [
                Tab(text: 'Tracks'),
                Tab(text: 'Details'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PlaylistTracksTab(playlist: widget.playlist),
              PlaylistDetailsTab(playlist: widget.playlist),
            ],
          ),
        ),
      ),
    );
  }
}
