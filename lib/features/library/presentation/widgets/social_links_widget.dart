import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/web_profiles_order_provider.dart';
import '../../../library_profile/domain/entities/public_profile_social_links.dart';

class SocialLinksWidget extends ConsumerWidget {
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

  String? _linkForPlatform(String platform) {
    switch (platform) {
      case 'instagram':
        return socialLinks.instagram;
      case 'twitter':
        return socialLinks.twitter;
      case 'youtube':
        return socialLinks.youtube;
      case 'tiktok':
        return socialLinks.tiktok;
      case 'linkedin':
        return socialLinks.linkedin;
      case 'snapchat':
        return socialLinks.snapchat;
      case 'facebook':
        return socialLinks.facebook;
      case 'website':
        return socialLinks.website;
      default:
        return null;
    }
  }

  Widget _iconForPlatform(String platform) {
    switch (platform) {
      case 'instagram':
        return const FaIcon(FontAwesomeIcons.instagram);
      case 'twitter':
        return const FaIcon(FontAwesomeIcons.xTwitter);
      case 'youtube':
        return const FaIcon(FontAwesomeIcons.youtube);
      case 'tiktok':
        return const FaIcon(FontAwesomeIcons.tiktok);
      case 'linkedin':
        return const FaIcon(FontAwesomeIcons.linkedin);
      case 'snapchat':
        return const FaIcon(FontAwesomeIcons.snapchat);
      case 'facebook':
        return const FaIcon(FontAwesomeIcons.facebook);
      case 'website':
        return const Icon(Icons.public);
      default:
        return const Icon(Icons.public);
    }
  }

  List<String> _fallbackOrder() {
    final result = <String>[];

    if (_hasValue(socialLinks.instagram)) result.add('instagram');
    if (_hasValue(socialLinks.twitter)) result.add('twitter');
    if (_hasValue(socialLinks.youtube)) result.add('youtube');
    if (_hasValue(socialLinks.tiktok)) result.add('tiktok');
    if (_hasValue(socialLinks.linkedin)) result.add('linkedin');
    if (_hasValue(socialLinks.snapchat)) result.add('snapchat');
    if (_hasValue(socialLinks.facebook)) result.add('facebook');
    if (_hasValue(socialLinks.website)) result.add('website');

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedOrder = ref.watch(webProfilesOrderProvider);
    final fallback = _fallbackOrder();

    final orderedPlatforms = <String>[
      ...savedOrder.where((platform) => _hasValue(_linkForPlatform(platform))),
      ...fallback.where((platform) => !savedOrder.contains(platform)),
    ];

    if (orderedPlatforms.isEmpty) {
      return const SizedBox.shrink();
    }

    if (orderedPlatforms.length == 1) {
      final platform = orderedPlatforms.first;
      final link = _linkForPlatform(platform)!;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: _iconForPlatform(platform),
            tooltip: platform,
            onPressed: () => _openLink(link),
          ),
        ],
      );
    }

    return SizedBox(
      height: 56,
      width: orderedPlatforms.length * 52,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          ref.read(webProfilesOrderProvider.notifier).reorder(
                oldIndex,
                newIndex,
              );
        },
        itemCount: orderedPlatforms.length,
        itemBuilder: (context, index) {
          final platform = orderedPlatforms[index];
          final link = _linkForPlatform(platform)!;

          return ReorderableDragStartListener(
            key: ValueKey(platform),
            index: index,
            child: IconButton(
              icon: _iconForPlatform(platform),
              tooltip: platform,
              onPressed: () => _openLink(link),
            ),
          );
        },
      ),
    );
  }
}