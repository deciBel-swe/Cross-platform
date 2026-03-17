
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

/// The privacy settings for the public and private tracks and its saved as preference
/// so when the user comes again, the previous settings will be the same
/// 
/// If the user is in ProArt subscription, he has the ability to schedule his private track to be public
/// in the future, otherwise the Free user can't has this feature.
/// 
/// By default the released time will be the current time.
class PrivacySettings extends ConsumerWidget {
  const PrivacySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadNotifierProvider);
    final isLoading = state is AsyncLoading;
    final metadata = state.value!;

    // TODO: In Phase 4, replace this mocked value with the actual user profile provider
    // will be ISA: final isArtistPro = ref.watch(currentUserProvider).isPro;
    bool isArtistPro = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Privacy', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        
        // Public / Private Radio
        RadioMenuButton<bool>(
          value: false, // false = Public
          groupValue: metadata.isPrivate,
          onChanged: isLoading ? null : (val) {
            // 1. Set to Public
            ref.read(uploadNotifierProvider.notifier).togglePrivacy(val!);
            // 2. Force the schedule to turn OFF because it is public now!
            ref.read(uploadNotifierProvider.notifier).clearReleaseDate();
          },
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Public', style: TextStyle(color: AppColors.onPrimary)),
               Text('Anyone can find this', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
        ),
        RadioMenuButton<bool>(
          value: true,
          groupValue: metadata.isPrivate,
          onChanged: isLoading ? null : (val) => ref.read(uploadNotifierProvider.notifier).togglePrivacy(val!),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Unlisted (Private)', style: TextStyle(color: AppColors.onPrimary)),
               Text('Anyone with private link can access', style: TextStyle(color: AppColors.textMuted)),
            ],
          ),
        ),
        
        // Follower Exclusive (Mock)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Text('Follower Exclusive', style: TextStyle(color: AppColors.textHint)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.proBadge.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text('★ ARTIST PRO', style: TextStyle(color: AppColors.proBadge, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          subtitle: const Text('Require listener to follow you to access', style: TextStyle(color: AppColors.textHint)),
          trailing: const Icon(Icons.circle_outlined, color: AppColors.textHint),
        ),
        const SizedBox(height: 16),

        // Schedule Release Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Icon(Icons.calendar_month, color: AppColors.onPrimary, size: 16),
              ),
              const SizedBox(width: 12),
              const Text('Schedule your release with Artist Pro', style: TextStyle(color: AppColors.onPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Scheduling
        const Text('Schedule', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Set date and time to make your track\npublic.',
                style: TextStyle(color: AppColors.onPrimary),
              ),
            ),
            Switch(
              value: metadata.releaseDate != null,
              activeThumbColor: AppColors.accentTeal,
              onChanged: (isLoading || !isArtistPro) ? null : (val) async {
                  if (val) {
                    // 1. First, pick the Date
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    // 2. If they picked a date, immediately ask for the Time
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      // 3. Combine them and update the state
                      if (time != null) {
                        final scheduledDateTime = DateTime(
                          date.year, date.month, date.day, 
                          time.hour, time.minute,
                        );
                        // 1. Set the schedule
                        ref.read(uploadNotifierProvider.notifier).updateReleaseDate(scheduledDateTime);
                        // 2. Force the privacy to Private (Unlisted)
                        ref.read(uploadNotifierProvider.notifier).togglePrivacy(true);
                      }
                    }
                  } else {
                    ref.read(uploadNotifierProvider.notifier).clearReleaseDate();
                  }
              },
            ),
          ],
        ),

        // Add a  hint for free users so they know why it's disabled
        if (!isArtistPro)
          // ignore: dead_code
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Upgrade to Artist Pro to schedule releases.',
              style: TextStyle(color: AppColors.proBadge, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        
        const SizedBox(height: 16),

        // Date and time boxes
        // if the user is ProArt -> so he can schedule its art to be public in a specific time
        // if the user is free -> so he can't schedule its art and it will be always private until he triggered it manually in the future.
        Builder(
          builder: (context) {
            // 1. Determine what text to show based on Pro status
            final now = DateTime.now();
            final String dateText;
            final String timeText;
            final bool isBoxActive;

            // ignore: dead_code, "I hate this error"
            if (!isArtistPro) {
              // Free users: Force show the current date and time
              dateText = DateFormat('dd MMM yyyy').format(now);
              timeText = DateFormat('HH:mm').format(now);
              isBoxActive = false; // Keep it looking "locked" but with real data
            } // If the schedule is OFF (for both Free and Pro users), default to TODAY
            else {
              if (metadata.releaseDate != null) {
                dateText = DateFormat('dd MMM yyyy').format(metadata.releaseDate!);
                timeText = DateFormat('HH:mm').format(metadata.releaseDate!);
                isBoxActive = true; 
              } 
              // Fallback: Show today's date, but make it look disabled/inactive
              else {
                dateText = DateFormat('dd MMM yyyy').format(now);
                timeText = DateFormat('HH:mm').format(now);
                isBoxActive = false; 
              }
            }

            // 2. Build the UI
            return Row(
              children: [
                _buildDateTimeBox(
                  text: dateText,
                  isActive: isBoxActive,
                ),
                const SizedBox(width: 16),
                _buildDateTimeBox(
                  text: timeText,
                  isActive: isBoxActive,
                ),
              ],
            );
          }
        ),
      ],
    );
  }

  // Helper widget to draw the dark input boxes for the date and time
  Widget _buildDateTimeBox({required String text, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? AppColors.textMuted : Colors.transparent),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? AppColors.onPrimary : AppColors.textHint, // Dimmed if inactive
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}