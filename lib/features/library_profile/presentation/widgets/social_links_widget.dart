import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../providers/web_profiles_order_provider.dart';
import '../utils/web_profile_platform_utils.dart';

class SocialLinksWidget extends ConsumerWidget {
  const SocialLinksWidget({super.key, required this.socialLinks});

  final PublicProfileSocialLinks socialLinks;

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderedPlatforms = ref.watch(orderedWebPlatformsProvider);

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
      width: orderedPlatforms.length * 52.0,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final newList = List<String>.from(orderedPlatforms);
          final item = newList.removeAt(oldIndex);
          newList.insert(newIndex, item);

          ref.read(webProfilesOrderProvider.notifier).updateOrder(newList);
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
