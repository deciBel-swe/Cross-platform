import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../library_profile/domain/entities/public_profile_social_links.dart';

class SocialLinksWidget extends StatelessWidget {
  final PublicProfileSocialLinks socialLinks;

  const SocialLinksWidget({
    super.key,
    required this.socialLinks,
  });

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (socialLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (socialLinks.instagram != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram),
            tooltip: 'Instagram',
            onPressed: () => _openLink(socialLinks.instagram!),
          ),

        if (socialLinks.twitter != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xTwitter),
            tooltip: 'Twitter/X',
            onPressed: () => _openLink(socialLinks.twitter!),
          ),

        if (socialLinks.website != null)
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Website',
            onPressed: () => _openLink(socialLinks.website!),
          ),
      ],
    );
  }
}