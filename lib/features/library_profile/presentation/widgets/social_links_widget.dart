import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/public_profile_social_links.dart';

typedef LinkLauncher = Future<bool> Function(Uri uri);

class SocialLinksWidget extends StatelessWidget {
  final PublicProfileSocialLinks socialLinks;
  final LinkLauncher launcher;

  const SocialLinksWidget({
    super.key,
    required this.socialLinks,
    this.launcher = _defaultLauncher,
  });

  static Future<bool> _defaultLauncher(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launcher(uri)) {
      throw Exception('Could not open $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (socialLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
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