import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/web_profiles_provider.dart';
import '../providers/web_profiles_order_provider.dart';

class EditProfileLinkScreen extends ConsumerStatefulWidget {
  const EditProfileLinkScreen({super.key});

  @override
  ConsumerState<EditProfileLinkScreen> createState() =>
      _EditProfileLinkScreenState();
}

class _EditProfileLinkScreenState
    extends ConsumerState<EditProfileLinkScreen> {
  final TextEditingController _linkController = TextEditingController();

  String? _pendingDeleteLink;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String link) {
    final uri = Uri.tryParse(link);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  Widget _platformIcon(String platform) {
    switch (platform) {
      case 'instagram':
        return const FaIcon(FontAwesomeIcons.instagram, size: 20);
      case 'twitter':
        return const FaIcon(FontAwesomeIcons.xTwitter, size: 20);
      case 'youtube':
        return const FaIcon(FontAwesomeIcons.youtube, size: 20);
      case 'tiktok':
        return const FaIcon(FontAwesomeIcons.tiktok, size: 20);
      case 'linkedin':
        return const FaIcon(FontAwesomeIcons.linkedin, size: 20);
      case 'snapchat':
        return const FaIcon(FontAwesomeIcons.snapchat, size: 20);
      case 'facebook':
        return const FaIcon(FontAwesomeIcons.facebook, size: 20);
      case 'website':
        return const Icon(Icons.public, size: 20);
      default:
        return const Icon(Icons.public, size: 20);
    }
  }

  String? _linkForPlatform(String platform, dynamic socialLinks) {
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

  List<String> _fallbackOrder(dynamic socialLinks) {
    final result = <String>[];

    bool hasValue(String? value) => value != null && value.trim().isNotEmpty;

    if (hasValue(socialLinks.instagram)) result.add('instagram');
    if (hasValue(socialLinks.twitter)) result.add('twitter');
    if (hasValue(socialLinks.youtube)) result.add('youtube');
    if (hasValue(socialLinks.tiktok)) result.add('tiktok');
    if (hasValue(socialLinks.linkedin)) result.add('linkedin');
    if (hasValue(socialLinks.snapchat)) result.add('snapchat');
    if (hasValue(socialLinks.facebook)) result.add('facebook');
    if (hasValue(socialLinks.website)) result.add('website');

    return result;
  }

  void _saveLink() {
    final link = _linkController.text.trim();
    final notifier = ref.read(webProfilesProvider.notifier);

    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a link')),
      );
      return;
    }

    if (!_isValidUrl(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }

    if (notifier.linkAlreadyExists(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This link already exists on your profile'),
        ),
      );
      return;
    }

    if (notifier.platformAlreadyExists(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A link for this platform already exists. Use Edit instead.',
          ),
        ),
      );
      return;
    }

    notifier.saveLink(link);

    final platform = notifier.getPlatformKey(link);
    ref.read(webProfilesOrderProvider.notifier).addPlatformIfMissing(platform);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link saved successfully')),
    );

    _linkController.clear();
  }

  Future<void> _showDeleteConfirmationDialog(String link) async {
    setState(() {
      _pendingDeleteLink = link;
    });

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete link?'),
          content: Text('Are you sure you want to delete:\n\n$link'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    setState(() {
      _pendingDeleteLink = null;
    });

    if (confirmed != true) return;

    final notifier = ref.read(webProfilesProvider.notifier);

    if (!notifier.linkAlreadyExists(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This link does not exist on your profile'),
        ),
      );
      return;
    }

    final platform = notifier.getPlatformKey(link);
    notifier.deleteLink(link);
    ref.read(webProfilesOrderProvider.notifier).removePlatform(platform);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link deleted successfully')),
    );
  }

  Future<void> _showEditLinkDialog(String oldLink) async {
    final controller = TextEditingController(text: oldLink);
    final notifier = ref.read(webProfilesProvider.notifier);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit link'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Link',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newLink = controller.text.trim();

                if (newLink.isEmpty) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Please enter a link')),
                  );
                  return;
                }

                if (!_isValidUrl(newLink)) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid URL')),
                  );
                  return;
                }

                if (newLink == oldLink) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('No changes were made')),
                  );
                  return;
                }

                if (!notifier.isSamePlatform(oldLink, newLink)) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Edited link must stay in the same platform. Delete it and add a new one instead.',
                      ),
                    ),
                  );
                  return;
                }

                if (notifier.linkAlreadyExists(newLink)) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This link already exists on your profile',
                      ),
                    ),
                  );
                  return;
                }

                notifier.editLink(oldLink, newLink);

                controller.dispose();
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Link updated successfully'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLinkRow({
    required String platform,
    required String link,
  }) {
    final isDeletePending = _pendingDeleteLink == link;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _platformIcon(platform),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              link,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          IconButton(
            onPressed: () => _showEditLinkDialog(link),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(link),
            icon: Icon(
              Icons.delete_outline,
              color: isDeletePending ? Colors.red : null,
            ),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialLinks = ref.watch(webProfilesProvider);
    final savedOrder = ref.watch(webProfilesOrderProvider);

    final orderedPlatforms = <String>[
      ...savedOrder.where((platform) {
        final link = _linkForPlatform(platform, socialLinks);
        return link != null && link.trim().isNotEmpty;
      }),
      ..._fallbackOrder(socialLinks).where((platform) {
        return !savedOrder.contains(platform);
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Profiles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Add new link',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveLink,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 30),
              if (orderedPlatforms.isNotEmpty) ...[
                const Text(
                  'Current Links',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...orderedPlatforms.map((platform) {
                  final link = _linkForPlatform(platform, socialLinks)!;
                  return _buildLinkRow(
                    platform: platform,
                    link: link,
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}