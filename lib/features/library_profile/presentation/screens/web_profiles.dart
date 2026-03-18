import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/public_profile_social_links.dart';
import '../providers/web_profiles_provider.dart';
import '../providers/web_profiles_order_provider.dart';
import '../utils/web_profile_platform_utils.dart';

class EditProfileLinkScreen extends ConsumerStatefulWidget {
  const EditProfileLinkScreen({super.key});

  @override
  ConsumerState<EditProfileLinkScreen> createState() =>
      _EditProfileLinkScreenState();
}

class _EditProfileLinkScreenState extends ConsumerState<EditProfileLinkScreen> {
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
    return WebProfilePlatformUtils.iconForPlatform(platform);
  }

  List<String> _fallbackOrder(dynamic socialLinks) {
    return socialLinks.nonEmptyPlatforms(includeSupportLink: false);
  }

  Future<void> _saveLink() async {
    final link = _linkController.text.trim();
    final notifier = ref.read(webProfilesProvider.notifier);
    final socialLinks = ref.read(webProfilesProvider);

    if (link.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a link')));
      return;
    }

    if (!_isValidUrl(link)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a valid URL')));
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

    final currentLinksCount = socialLinks
        .nonEmptyPlatforms(includeSupportLink: true)
        .length;

    if (currentLinksCount >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can add up to 3 links only')),
      );
      return;
    }

    final synced = await notifier.saveLink(link);

    final platform = notifier.getPlatformKey(link);
    ref.read(webProfilesOrderProvider.notifier).addPlatformIfMissing(platform);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          synced
              ? 'Link saved successfully'
              : 'Failed to save link. Please try again.',
        ),
      ),
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
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
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
    final synced = await notifier.deleteLink(link);
    ref.read(webProfilesOrderProvider.notifier).removePlatform(platform);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          synced
              ? 'Link deleted successfully'
              : 'Failed to delete link. Please try again.',
        ),
      ),
    );
  }

  Widget _buildLinkRow({required String platform, required String link}) {
    final isDeletePending = _pendingDeleteLink == link;

    return _EditableLinkRow(
      platform: platform,
      link: link,
      isDeletePending: isDeletePending,
      platformIcon: _platformIcon(platform),
      isValidUrl: _isValidUrl,
      onDelete: () => _showDeleteConfirmationDialog(link),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialLinks = ref.watch(webProfilesProvider);
    final savedOrder = ref.watch(webProfilesOrderProvider);

    final orderedPlatforms = <String>[
      ...savedOrder.where((platform) {
        final link = socialLinks.valueForPlatform(platform);
        return link != null && link.trim().isNotEmpty;
      }),
      ..._fallbackOrder(socialLinks).where((platform) {
        return !savedOrder.contains(platform);
      }),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Web Profiles')),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...orderedPlatforms.map((platform) {
                  final link = socialLinks.valueForPlatform(platform)!;
                  return _buildLinkRow(platform: platform, link: link);
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableLinkRow extends ConsumerStatefulWidget {
  final String platform;
  final String link;
  final bool isDeletePending;
  final Widget platformIcon;
  final bool Function(String) isValidUrl;
  final VoidCallback onDelete;

  const _EditableLinkRow({
    required this.platform,
    required this.link,
    required this.isDeletePending,
    required this.platformIcon,
    required this.isValidUrl,
    required this.onDelete,
  });

  @override
  ConsumerState<_EditableLinkRow> createState() => _EditableLinkRowState();
}

class _EditableLinkRowState extends ConsumerState<_EditableLinkRow> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.link);
  }

  @override
  void didUpdateWidget(covariant _EditableLinkRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.link != widget.link) {
      _controller.text = widget.link;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _controller.text = widget.link;
    });
  }

  Future<void> _saveInlineEdit() async {
    final newLink = _controller.text.trim();
    final notifier = ref.read(webProfilesProvider.notifier);

    if (newLink.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a link')));
      return;
    }

    if (!widget.isValidUrl(newLink)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a valid URL')));
      return;
    }

    if (newLink == widget.link) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes were made')));
      return;
    }

    if (!notifier.isSamePlatform(widget.link, newLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Edited link must stay in the same platform. Delete it and add a new one instead.',
          ),
        ),
      );
      return;
    }

    if (notifier.linkAlreadyExists(newLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This link already exists on your profile'),
        ),
      );
      return;
    }

    final synced = await notifier.editLink(widget.link, newLink);

    setState(() {
      _isEditing = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          synced
              ? 'Link updated successfully'
              : 'Failed to update link. Please try again.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.platformIcon,
          const SizedBox(width: 10),
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveInlineEdit(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      widget.link,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
          ),
          if (!_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                  _controller.text = widget.link;
                });
              },
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
            ),
          if (_isEditing)
            IconButton(
              onPressed: _saveInlineEdit,
              icon: const Icon(Icons.check, color: Colors.green),
              tooltip: 'Save',
            ),
          if (_isEditing)
            IconButton(
              onPressed: _cancelEdit,
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          if (!_isEditing)
            IconButton(
              onPressed: widget.onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: widget.isDeletePending ? Colors.red : null,
              ),
              tooltip: 'Delete',
            ),
        ],
      ),
    );
  }
}
