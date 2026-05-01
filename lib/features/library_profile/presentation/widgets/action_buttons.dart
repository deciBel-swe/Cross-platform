import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/public_profile_social_links.dart';
import 'social_links_widget.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required this.socialLinks});
  final PublicProfileSocialLinks socialLinks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          identifier: 'edit_profile_button',
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              context.push(RoutePaths.editProfile);
            },
            color: AppColors.textTertiary,
            iconSize: 29,
            tooltip: 'Edit profile',
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        const SizedBox(width: 8),
        SocialLinksWidget(socialLinks: socialLinks),
        const Spacer(),
        Semantics(
          identifier: 'shuffle_playback_button',
          child: IconButton(
            onPressed: () {},
            color: AppColors.textTertiary,
            iconSize: 29,
            tooltip: 'Shuffle playback',
            icon: const Icon(Icons.shuffle),
          ),
        ),
        Semantics(
          identifier: 'play_all_button',
          child: IconButton(
            iconSize: 60,
            onPressed: () {},
            tooltip: 'Play all',
            icon: const Icon(Icons.play_circle_fill),
          ),
        ),
      ],
    );
  }
}
