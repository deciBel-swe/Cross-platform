/// Desktop Upgrade screen — SoundCloud Go+ style premium page.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Upgrade page showcasing premium features with a CTA banner.
class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        children: [
          // ---- Hero banner ----
          const _UpgradeHero(),

          const SizedBox(height: AppDimensions.paddingXl),

          // ---- Feature comparison ----
          const Text('Why Upgrade?', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.paddingMd),

          const _FeatureRow(
            icon: Icons.headphones,
            title: 'Ad-free listening',
            description: 'Enjoy uninterrupted music without any ads.',
            isFree: false,
          ),
          const _FeatureRow(
            icon: Icons.high_quality,
            title: 'HQ audio streaming',
            description: 'Listen in high-quality 256kbps AAC.',
            isFree: false,
          ),
          const _FeatureRow(
            icon: Icons.download,
            title: 'Offline listening',
            description: 'Download tracks and listen anywhere.',
            isFree: false,
          ),
          const _FeatureRow(
            icon: Icons.skip_next,
            title: 'Unlimited skips',
            description: 'Skip as many tracks as you want.',
            isFree: true,
          ),
          const _FeatureRow(
            icon: Icons.playlist_play,
            title: 'Unlimited playlists',
            description: 'Create and save as many playlists as you like.',
            isFree: true,
          ),
          const _FeatureRow(
            icon: Icons.upload,
            title: 'Extended uploads',
            description: 'Upload up to 6 hours of audio content.',
            isFree: false,
          ),

          const SizedBox(height: AppDimensions.paddingXl),

          // ---- CTA button ----
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Start Free Trial'),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingMd),

          Center(
            child: Text(
              'Try free for 30 days. Cancel anytime.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXl),
        ],
      ),
    );
  }
}

/// Hero banner with gradient and tagline.
class _UpgradeHero extends StatelessWidget {
  const _UpgradeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark, Color(0xFF1A0500)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimensions.paddingLg),
          Image.asset(
            'assets/icon/white_app_icon_trans.png',
            width: 64,
            height: 64,
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          const Text(
            'Decibel Go+',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          Text(
            'Your music. No limits.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLg),
        ],
      ),
    );
  }
}

/// A single feature comparison row.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.isFree,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppDimensions.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.cardSubtitle),
              ],
            ),
          ),
          _Badge(isPremium: !isFree),
        ],
      ),
    );
  }
}

/// Small badge showing "Free" or "Go+".
class _Badge extends StatelessWidget {
  const _Badge({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPremium ? AppColors.primary : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPremium ? 'Go+' : 'Free',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPremium ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
