import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import '../notifiers/playlist_form_notifier.dart';

class CreatePlaylistBottomSheet extends ConsumerWidget {
  const CreatePlaylistBottomSheet({super.key});

  static void show(BuildContext context) {
    // ignore: inference_failure_on_function_invocation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context),
          child: const CreatePlaylistBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(playlistFormProvider(null as Playlist?));
    final notifier = ref.read(playlistFormProvider(null as Playlist?).notifier);
    final metadata = formState.valueOrNull;
    final isLoading = formState.isLoading;
    final isPublic = metadata != null && !metadata.isPrivate;

    final screenSize = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    ref.listen(playlistFormProvider(null), (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.errors,
          ),
        );
      }
    });

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.85,
          maxWidth: screenSize.width,
          minWidth: screenSize.width,
        ),
        child: Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Close button
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceVariant,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      // Title
                      const Text(
                        'Create playlist',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Save pill button
                      SizedBox(
                        width: 72,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: (!notifier.isValid || isLoading)
                              ? null
                              : () async {
                                  final success = await notifier
                                      .submitPlaylist();
                                  if (success && context.mounted) {
                                    context.pop();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            foregroundColor: AppColors.onBackground,
                            disabledBackgroundColor: AppColors.textMuted,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            isLoading ? '...' : 'Save',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Playlist Title Field
                  const Text(
                    'Playlist title',
                    style: TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    maxLength: 100,
                    autofocus: true,
                    textInputAction: TextInputAction.done,

                    onSubmitted: (_) async {
                      // Using the notifier you already declared
                      final success = await notifier.submitPlaylist();

                      if (success && context.mounted) {
                        context.pop();
                      }
                    },

                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "e.g. Qur'an",
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.textPrimary,
                          width: 1,
                        ),
                      ),
                    ),
                    onChanged: notifier.updateTitle,
                  ),

                  const SizedBox(height: 28),

                  // Make Public Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Make public',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Switch(
                        value: isPublic,
                        activeThumbColor: AppColors.onPrimary,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: AppColors.textMuted,
                        inactiveTrackColor: AppColors.surfaceVariant,
                        onChanged: (bool value) {
                          notifier.togglePrivacy(!value);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
