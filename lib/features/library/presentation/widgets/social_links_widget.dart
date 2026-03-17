import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/web_profiles_order_provider.dart';
import '../utils/web_profile_platform_utils.dart';
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

  List<String> _fallbackOrder() {
    return socialLinks.nonEmptyPlatforms(includeSupportLink: false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedOrder = ref.watch(webProfilesOrderProvider);
    final fallback = _fallbackOrder();

    final orderedPlatforms = <String>[
      ...savedOrder.where((platform) => socialLinks.hasValueForPlatform(platform)),
      ...fallback.where((platform) => !savedOrder.contains(platform)),
    ];

    if (orderedPlatforms.isEmpty) {
      return const SizedBox.shrink();
    }

    if (orderedPlatforms.length == 1) {
      final platform = orderedPlatforms.first;
      final link = socialLinks.valueForPlatform(platform)!;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: WebProfilePlatformUtils.iconForPlatform(platform),
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
          final link = socialLinks.valueForPlatform(platform)!;

          return ReorderableDragStartListener(
            key: ValueKey(platform),
            index: index,
            child: IconButton(
              icon: WebProfilePlatformUtils.iconForPlatform(platform),
              tooltip: platform,
              onPressed: () => _openLink(link),
            ),
          );
        },
      ),
    );
  }
}