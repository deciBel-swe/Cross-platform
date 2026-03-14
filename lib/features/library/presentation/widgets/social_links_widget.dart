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

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final hasInstagram = _hasValue(socialLinks.instagram);
    final hasTwitter = _hasValue(socialLinks.twitter);
    final hasWebsite = _hasValue(socialLinks.website);

    if (!hasInstagram && !hasTwitter && !hasWebsite) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasInstagram)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram),
            tooltip: 'Instagram',
            onPressed: () => _openLink(socialLinks.instagram!),
          ),
        if (hasTwitter)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xTwitter),
            tooltip: 'Twitter/X',
            onPressed: () => _openLink(socialLinks.twitter!),
          ),
        if (hasWebsite)
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Website',
            onPressed: () => _openLink(socialLinks.website!),
          ),
      ],
    );
  }
}