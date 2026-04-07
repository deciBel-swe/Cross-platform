import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/auth_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/web_profiles_order_provider.dart';
import '../providers/web_profiles_provider.dart';
import '../utils/web_profile_platform_utils.dart';

class EditProfileLinkScreen extends ConsumerStatefulWidget {
  const EditProfileLinkScreen({super.key});

  @override
  ConsumerState<EditProfileLinkScreen> createState() =>
      _EditProfileLinkScreenState();
}

class _EditProfileLinkScreenState extends ConsumerState<EditProfileLinkScreen> {
  final TextEditingController _linkController = TextEditingController();
  final GlobalKey<FormState> _addLinkFormKey = GlobalKey<FormState>();

  String? _pendingDeleteLink;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String link) {
    return AuthValidators.validateSocialLink(link) == null;
  }

  String _normalizeUrl(String rawLink) {
    final trimmed = rawLink.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme) {
      return trimmed;
    }

    return 'https://$trimmed';
  }

  Future<void> _addLink() async {
    final normalizedLink = _normalizeUrl(_linkController.text);
    final notifier = ref.read(webProfilesProvider.notifier);
    final socialLinks = ref.read(webProfilesProvider);

    final validationMessage = AuthValidators.validateSocialLink(normalizedLink);

    if (validationMessage != null) {
      _addLinkFormKey.currentState?.validate();
      return;
    }

    final link = normalizedLink;

    if (link.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a link')));
      return;
    }

    if (!_isValidUrl(link)) {
      _addLinkFormKey.currentState?.validate();
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
        .nonEmptyPlatforms(includeSupportLink: false)
        .length;

    if (currentLinksCount >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can add up to 3 links only')),
      );
      return;
    }

    final added = notifier.addLinkLocally(link);
    final platform = notifier.getPlatformKey(link);
    ref.read(webProfilesOrderProvider.notifier).addPlatformIfMissing(platform);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? 'Link added. Tap Save at top-right to persist.'
              : 'Failed to add link. Please try again.',
        ),
      ),
    );

    _linkController.clear();
    _addLinkFormKey.currentState?.reset();
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
              onPressed: () => context.pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
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

    if (!mounted) return;
    if (!notifier.linkAlreadyExists(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This link does not exist on your profile'),
        ),
      );
      return;
    }

    final deleted = notifier.deleteLinkLocally(link);
    final platform = notifier.getPlatformKey(link);
    ref.read(webProfilesOrderProvider.notifier).removePlatform(platform);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? 'Link removed. Tap Save'
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
      platformIcon: WebProfilePlatformUtils.iconForPlatform(platform),
      isValidUrl: _isValidUrl,
      onDelete: () => _showDeleteConfirmationDialog(link),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialLinks = ref.watch(webProfilesProvider);
    final orderedPlatforms = ref.watch(orderedWebPlatformsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Web links',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add up to 3 links. Changes are saved from top-right Save.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          Form(
            key: _addLinkFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _linkController,
              validator: (value) {
                final normalized = _normalizeUrl(value ?? '');
                return AuthValidators.validateSocialLink(normalized);
              },
              decoration: const InputDecoration(
                labelText: 'Link URL',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add),
              label: const Text('Add link'),
            ),
          ),
          const SizedBox(height: 20),
          if (orderedPlatforms.isNotEmpty) ...[
            const Text(
              'Current links',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...orderedPlatforms.map((platform) {
              final link = socialLinks.valueForPlatform(platform)!;
              return _buildLinkRow(platform: platform, link: link);
            }),
          ],
        ],
      ),
    );
  }
}

class _EditableLinkRow extends ConsumerStatefulWidget {
  const _EditableLinkRow({
    required this.platform,
    required this.link,
    required this.isDeletePending,
    required this.platformIcon,
    required this.isValidUrl,
    required this.onDelete,
  });

  final String platform;
  final String link;
  final bool isDeletePending;
  final Widget platformIcon;
  final bool Function(String) isValidUrl;
  final VoidCallback onDelete;

  @override
  ConsumerState<_EditableLinkRow> createState() => _EditableLinkRowState();
}

class _EditableLinkRowState extends ConsumerState<_EditableLinkRow> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
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

  String _normalizeUrl(String rawLink) {
    final trimmed = rawLink.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme) {
      return trimmed;
    }

    return 'https://$trimmed';
  }

  Future<void> _saveInlineEdit() async {
    final normalizedNewLink = _normalizeUrl(_controller.text);
    final notifier = ref.read(webProfilesProvider.notifier);

    final validationMessage =
        AuthValidators.validateSocialLink(normalizedNewLink);

    if (validationMessage != null) {
      _editFormKey.currentState?.validate();
      return;
    }

    final newLink = normalizedNewLink;

    if (!mounted) return;
    if (newLink.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a link')));
      return;
    }

    if (!mounted) return;
    if (!widget.isValidUrl(newLink)) {
      _editFormKey.currentState?.validate();
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

    if (!mounted) return;
    if (notifier.linkAlreadyExists(newLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This link already exists on your profile'),
        ),
      );
      return;
    }

    final edited = notifier.editLinkLocally(widget.link, newLink);

    setState(() {
      _isEditing = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          edited
              ? 'Link updated. Tap Save at top-right to persist.'
              : 'Failed to update link. Please try again.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 22, child: widget.platformIcon),
          const SizedBox(width: 10),
          Expanded(
            child: _isEditing
                ? Form(
                    key: _editFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveInlineEdit(),
                      validator: (value) {
                        final normalized = _normalizeUrl(value ?? '');
                        return AuthValidators.validateSocialLink(normalized);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: 'https://example.com',
                      ),
                    ),
                  )
                : Text(
                    widget.link,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
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
              tooltip: 'Apply',
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