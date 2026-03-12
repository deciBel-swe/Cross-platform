import 'package:flutter/material.dart';

import '../../../library_profile/models/public_profile_social_links.dart';
import '../../../library_profile/presentation/widgets/social_links_widget.dart';

/// Empty Home page – placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SocialLinksWidget(
          socialLinks: const PublicProfileSocialLinks(
            instagram: 'https://instagram.com/flutter',
            twitter: 'https://x.com/flutterdev',
            website: 'https://flutter.dev',
          ),
        ),
      ),
    );
  }
}