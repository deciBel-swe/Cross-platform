import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'tile.dart';

class MediaCollection extends StatelessWidget {
  const MediaCollection({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Tile(
          title: 'Tracks',
          subtitle: 'View all your tracks',
          buttonText: 'See All',
          onButtonPressed: () => {/* TODO: Handle see all tracks action */},
        ),
        const SizedBox(height: 14),
        Text(
          'No tracks yet',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Tile(
          title: "Playlist",
          buttonText: "See All",
          onButtonPressed: () {
            //TODO: hndle see all playlist action
          },
        ),
        const SizedBox(height: 14),
        Text(
          'No playlists yet',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Tile(
          title: "Likes",
          buttonText: "See All",
          onButtonPressed: () {
            //TODO: hndle see all Likes action
          },
        ),
        Text(
          'No Likes yet',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
