import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/station_playlist.dart';
import 'station_playlist_cover.dart';

class StationPlaylistCard extends StatelessWidget {
  const StationPlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  final StationPlaylist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const cardSize = 184.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: SizedBox(
          width: cardSize,
          height: cardSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              StationPlaylistCover(
                playlist: playlist,
                size: cardSize,
                borderRadius: AppDimensions.radiusMd,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.28),
                      AppColors.background.withValues(alpha: 0.88),
                    ],
                    stops: const [0, 0.48, 1],
                  ),
                ),
              ),
              Positioned(
                right: AppDimensions.paddingSm,
                top: AppDimensions.paddingSm,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.72),
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(
                    dimension: 38,
                    child: Icon(
                      Icons.playlist_play_rounded,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppDimensions.paddingMd,
                right: AppDimensions.paddingMd,
                bottom: AppDimensions.paddingMd,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${playlist.trackCount} tracks',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
