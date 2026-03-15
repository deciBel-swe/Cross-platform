import 'package:decibel/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:decibel/core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

class SubmitSection extends ConsumerWidget {
  const SubmitSection({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadNotifierProvider);
    final isLoading = state is AsyncLoading;
    final metadata = state.mapOrNull();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: isLoading ? null : () async {
          // 1. Frontend Checks
          final isFormValid = formKey.currentState!.validate();
          final hasAudioFile = metadata.audioFile != null;

          if (!hasAudioFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select an audio file to upload.'),
                backgroundColor: AppColors.errors, 
                behavior: SnackBarBehavior.floating,
              ),
            );
            return; // Stop right here if there's no file
          }

          // 2. Trigger the upload API call
          if (isFormValid && hasAudioFile) {
            final success = await ref.read(uploadNotifierProvider.notifier).submitTrack();
            
            // Best Practice: safety check after an 'await'
            if (!context.mounted) return; 

            // 3. Handle the Backend Result
            if (success) {
               context.go(RoutePaths.uploadLibrary);
            } else {
              // If Failed, Grab the exact error from Riverpod and show it.
              final errorState = ref.read(uploadNotifierProvider).error;
              final errorMessage = errorState?.toString() ?? 'Failed to upload track. Please try again.';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
                  backgroundColor: AppColors.errors,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        child: isLoading 
            ? const CircularProgressIndicator(color: AppColors.onPrimary) 
            : const Text('Save', style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
      ),
    );
  }
}