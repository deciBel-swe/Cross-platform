import 'package:decibel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/upload_notifier.dart';

/// Displays the selected track's cover art and audio file name.
///
/// Allows the user to tap the cover art placeholder to open the device gallery,
/// and provides an outlined button to swap the currently selected audio file.
class FileSelectionHeader extends ConsumerWidget {
  const FileSelectionHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the global upload state to rebuild when a new file is picked
    final state = ref.watch(uploadNotifierProvider);
    final isLoading = state is AsyncLoading;
    final metadata = state.value!;

    String fileDetails = '';
    if (metadata.audioFile != null) {
      final file = metadata.audioFile!;
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toUpperCase();
      final sizeInMB = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);

      fileDetails = '$extension - $sizeInMB(MB)';
    }

    return Row(
      children: [
        // Cover Art Picker
        GestureDetector(
          // check the app is loading to allow the notifier to add the cover image on the user select the photo
          onTap: isLoading
              ? null
              : () =>
                    ref.read(uploadNotifierProvider.notifier).pickCoverImage(),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!, width: 1),
              // Show the selected image if it exists
              image: metadata.coverImage != null
                  ? DecorationImage(
                      image: FileImage(metadata.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            // Show a placeholder icon if no image is selected
            child: metadata.coverImage == null
                ? const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.textSecondary,
                    size: 30,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 16),

        // File Info & Replace Button
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'File name',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              // Truncate long file names
              Text(
                metadata.audioFile?.path.split('/').last ?? 'No file selected',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Display the formatted size and extention here
              if (fileDetails.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  fileDetails,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () => ref
                          .read(uploadNotifierProvider.notifier)
                          .pickAudioFile(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.onPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Replace file'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
