import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/track_upload_metadata.dart';

/// A widget that displays a circular progress indicator for the track completion.
/// Tapping it reveals a bottom sheet with a detailed split-layout breakdown.
class TrackInfoChecklist extends StatelessWidget {
  const TrackInfoChecklist({super.key, required this.metadata});
  final TrackUploadMetadata metadata;

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = metadata.title.trim().isNotEmpty;
    final bool hasArtwork = metadata.coverImage != null;
    final bool hasGenre = metadata.genre.isNotEmpty;
    final bool hasDescription = metadata.description.isNotEmpty;

    int completed = 0;
    if (hasTitle) completed++;
    if (hasArtwork) completed++;
    if (hasGenre) completed++;
    if (hasDescription) completed++;

    final progress = completed / 4.0;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        _showChecklistDetails(
          context,
          completed,
          progress,
          hasTitle,
          hasArtwork,
          hasGenre,
          hasDescription,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track info checklist',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fans play more when your track info is complete. Tap to learn more.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[900],
                    color: AppColors.accentPurple,
                    strokeWidth: 3,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$completed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const TextSpan(
                        text: '/4',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // The Split-Layout Bottom Sheet

  void _showChecklistDetails(
    BuildContext context,
    int completed,
    double progress,
    bool hasTitle,
    bool hasArtwork,
    bool hasGenre,
    bool hasDescription,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color:
                AppColors.background, // Match the dark backdrop from screenshot
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Headers
              const Text(
                'Get everything in place',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fans are more likely to play your music when you complete these:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Layout Row: Big Progress Indicator + Checklist
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Massive Progress Ring
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[900],
                            color: AppColors.accentPurple,
                            strokeWidth: 4,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$completed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const TextSpan(
                                text: '/4',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Right Side: The Checklist Items
                  Expanded(
                    child: Column(
                      children: [
                        _ChecklistItem(
                          title: 'Track title',
                          isCompleted: hasTitle,
                          subtitle: "TIP: Don't include artist names",
                        ),
                        const SizedBox(height: 16),
                        _ChecklistItem(
                          title: 'Artwork',
                          isCompleted: hasArtwork,
                        ),
                        const SizedBox(height: 16),
                        _ChecklistItem(title: 'Genre', isCompleted: hasGenre),
                        const SizedBox(height: 16),
                        _ChecklistItem(
                          title: 'Description',
                          isCompleted: hasDescription,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // The Pill Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Ok, got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

/// Helper widget to draw each row in the new checklist design
class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.title,
    required this.isCompleted,
    this.subtitle,
  });
  final String title;
  final bool isCompleted;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: subtitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // The Custom Icon (White filled checkmark vs outline)
        Icon(
          isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 12),

        // The Text Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
