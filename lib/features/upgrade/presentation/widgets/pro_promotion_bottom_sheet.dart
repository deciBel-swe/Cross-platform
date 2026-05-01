import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A promotional bottom sheet shown to free-tier users when they attempt a
/// PRO-only action (e.g. downloading a track or playlist).
class ProPromotionBottomSheet extends StatelessWidget {
  const ProPromotionBottomSheet({super.key});

  /// Shows the [ProPromotionBottomSheet] as a modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProPromotionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingLg,
        AppDimensions.paddingLg,
        AppDimensions.paddingLg,
        AppDimensions.paddingLg + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLg),

          // Hero gradient banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingLg,
              horizontal: AppDimensions.paddingMd,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.download_for_offline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: AppDimensions.paddingSm),
                const Text(
                  'Decibel PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXs),
                Text(
                  'Unlock offline downloads & more',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.paddingLg),

          // Feature list
          const _FeatureRow(
            icon: Icons.download_rounded,
            text: 'Download tracks & playlists for offline listening',
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          const _FeatureRow(
            icon: Icons.high_quality_rounded,
            text: 'Higher audio quality streams',
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          const _FeatureRow(
            icon: Icons.star_rounded,
            text: 'Support the artists you love',
          ),

          const SizedBox(height: AppDimensions.paddingXl),

          // CTA
          Semantics(
            button: true,
            label: 'Upgrade to Decibel Pro',
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(RoutePaths.upgrade);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  textStyle: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Get Decibel PRO'),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingMd),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Maybe later',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppDimensions.paddingMd),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
