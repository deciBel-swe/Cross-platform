import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

class SubmitSection extends ConsumerWidget {
  const SubmitSection({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadNotifierProvider);
    final isLoading = state.isLoading;
    final metadata = state.valueOrNull;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                // Safety check to prevent ! error
                if (metadata == null) return;

                // 1. Frontend Checks
                final isFormValid = formKey.currentState!.validate();
                final hasAudioFile = metadata.audioFile != null;
                final hasGenre = metadata.genre.isNotEmpty;
                final isGenreValidLength = metadata.genre.length <= 100;

                if (!hasAudioFile) {
                  ScaffoldMessenger.of(
                    context,
                  ).clearSnackBars(); // clear existed SnackBar if existed from previous error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an audio file to upload.'),
                      backgroundColor: AppColors.errors,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return; // Stop right here if there's no file
                }

                if (!hasGenre) {
                  ScaffoldMessenger.of(
                    context,
                  ).clearSnackBars(); // clear existed SnackBar if existed from previous error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a genre for your track.'),
                      backgroundColor: AppColors.errors,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return; // Stop right here if there's no genre
                }

                if (!isGenreValidLength) {
                  ScaffoldMessenger.of(
                    context,
                  ).clearSnackBars(); // clear existed SnackBar if existed from previous error
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Genre must be less than 100 characters.'),
                      backgroundColor: AppColors.errors,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return; // Stop right here if there's no genre
                }

                // 2. Trigger the upload API call
                if (isFormValid && hasAudioFile) {
                  // Fire and forget upload, keep running in background!
                  ref.read(uploadNotifierProvider.notifier).submitTrack();

                  // 3. Immediately kick user out to home screen per requirements
                  context.go(RoutePaths.home);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload started in background...'),
                      backgroundColor: AppColors.accentTeal,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
        child: isLoading
            ? Semantics(
                label: 'Uploading track...',
                child: const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.onPrimary,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Semantics(
                button: true,
                label: 'Save track details',
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
