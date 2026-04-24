import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../utils/web_profile_platform_utils.dart';

class SocialLinksWidget extends StatelessWidget {
  const SocialLinksWidget({
    super.key,
    required this.socialLinks,
    this.maxVisibleLinks = 2,
  }) : assert(maxVisibleLinks > 0);

  final PublicProfileSocialLinks socialLinks;
  final int maxVisibleLinks;

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderedPlatforms = socialLinks.nonEmptyPlatforms(
      includeSupportLink: true,
    );

    if (orderedPlatforms.isEmpty) {
      return const SizedBox.shrink();
    }
    final visiblePlatforms = orderedPlatforms.take(maxVisibleLinks).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            for (final platform in visiblePlatforms)
              IconButton(
                icon: WebProfilePlatformUtils.iconForPlatform(platform),
                tooltip: platform,
                onPressed: () =>
                    _openLink(socialLinks.valueForPlatform(platform)!),
              ),
          ],
        ),
      ],
    );
  }
}
