import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/web_profiles_provider.dart';

class EditProfileLinkScreen extends ConsumerStatefulWidget {
  const EditProfileLinkScreen({super.key});

  @override
  ConsumerState<EditProfileLinkScreen> createState() =>
      _EditProfileLinkScreenState();
}

class _EditProfileLinkScreenState
    extends ConsumerState<EditProfileLinkScreen> {
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _editLinkController = TextEditingController();
  final TextEditingController _deleteLinkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    _editLinkController.dispose();
    _deleteLinkController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String link) {
    final uri = Uri.tryParse(link);
    return uri != null && uri.hasScheme && uri.hasAuthority;
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
          content: Text('A link for this platform already exists. Use Edit instead.'),
        ),
      );
      return;
    }

    notifier.saveLink(link);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link saved successfully')),
    );

    _linkController.clear();
  }

  void _editLink() {
    final link = _editLinkController.text.trim();
    final notifier = ref.read(webProfilesProvider.notifier);
    final existingLink = notifier.getExistingLinkForPlatform(link);

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

    if (existingLink == null || existingLink.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existing link for this platform to edit'),
        ),
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

    notifier.editLink(link);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link updated successfully')),
    );

    _editLinkController.clear();
  }

void _deleteLink() {
  final link = _deleteLinkController.text.trim();
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

  if (!notifier.linkAlreadyExists(link)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This link does not exist on your profile'),
      ),
    );
    return;
  }

  notifier.deleteLink(link);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Link deleted successfully')),
  );

  _deleteLinkController.clear();
}

  @override
  Widget build(BuildContext context) {
    final socialLinks = ref.watch(webProfilesProvider);

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
              if (!socialLinks.isEmpty) ...[
                const Text(
                  'Current Links',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (socialLinks.instagram != null &&
                    socialLinks.instagram!.trim().isNotEmpty)
                  Text('Instagram: ${socialLinks.instagram}'),
                if (socialLinks.twitter != null &&
                    socialLinks.twitter!.trim().isNotEmpty)
                  Text('Twitter/X: ${socialLinks.twitter}'),
                if (socialLinks.website != null &&
                    socialLinks.website!.trim().isNotEmpty)
                  Text('Website: ${socialLinks.website}'),
                const SizedBox(height: 24),
              ],
              TextField(
                controller: _editLinkController,
                decoration: const InputDecoration(
                  labelText: 'Edit existing link',
                  hintText: 'Enter updated link',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _editLink,
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _deleteLinkController,
                decoration: const InputDecoration(
                  labelText: 'Delete existing link',
                  hintText: 'Enter link platform to delete',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deleteLink,
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}