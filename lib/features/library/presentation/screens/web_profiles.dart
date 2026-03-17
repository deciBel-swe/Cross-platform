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

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  void _saveLink() {
    final link = _linkController.text.trim();

    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a link')),
      );
      return;
    }

    ref.read(webProfilesProvider.notifier).saveLink(link);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Website Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Website link',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLink,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}