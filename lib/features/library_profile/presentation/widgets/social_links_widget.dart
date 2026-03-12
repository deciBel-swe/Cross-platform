import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/public_profile_social_links.dart';

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

Future<void> _openLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);

  if (uri == null) return;

  final launched = await launcher(uri);

  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open link'),
      ),
    );
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
            onPressed: () => _openLink(context, socialLinks.instagram!),
          ),
        if (socialLinks.twitter != null)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xTwitter),
            tooltip: 'Twitter/X',
            onPressed: () => _openLink(context, socialLinks.twitter!),
          ),
        if (socialLinks.website != null)
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Website',
            onPressed: () => _openLink(context, socialLinks.website!),
          ),
      ],
    );
  }
}