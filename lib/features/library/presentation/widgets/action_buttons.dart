import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/domain/entities/public_profile_social_links.dart';
import '../../../library_profile/presentation/widgets/social_links_widget.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required this.socialLinks});
  final PublicProfileSocialLinks socialLinks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            context.push(RoutePaths.editWebLink);
          },
          color: AppColors.textTertiary,
          iconSize: 29,
          icon: const Icon(Icons.edit_outlined),
        ),
        const SizedBox(width: 8),
        SocialLinksWidget(socialLinks: socialLinks),
        const Spacer(),
        IconButton(
          onPressed: () {},
          color: AppColors.textTertiary,
          iconSize: 29,
          icon: const Icon(Icons.shuffle),
        ),
        IconButton(
          iconSize: 60,
          onPressed: () {},
          icon: const Icon(Icons.play_circle_fill),
        ),
      ],
    );
  }
}
