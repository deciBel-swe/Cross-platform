import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import 'message_resource_tabs.dart';

/// Selected track or playlist returned by [MessageResourcePickerSheet].
class MessageResourceSelection {
  const MessageResourceSelection({
    required this.resourceType,
    required this.resourceId,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  final String resourceType;
  final int resourceId;
  final String title;
  final String? subtitle;
  final String? imageUrl;
}

/// Bottom sheet for choosing a track or playlist to attach to a message.
///
/// The sheet lets users browse liked tracks, playlists, and uploads, then
/// returns a [MessageResourceSelection] when Done is tapped.
class MessageResourcePickerSheet extends ConsumerStatefulWidget {
  const MessageResourcePickerSheet({super.key});

  /// Opens the picker and completes with the selected resource, if any.
  static Future<MessageResourceSelection?> show(BuildContext context) {
    return showModalBottomSheet<MessageResourceSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const MessageResourcePickerSheet(),
    );
  }

  @override
  ConsumerState<MessageResourcePickerSheet> createState() =>
      _MessageResourcePickerSheetState();
}

class _MessageResourcePickerSheetState
    extends ConsumerState<MessageResourcePickerSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  MessageResourceSelection? _selection;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Stores the current resource selection.
  void _select(MessageResourceSelection selection) {
    setState(() {
      _selection = selection;
    });
  }

  /// Checks whether a tab row should render as selected.
  bool _isSelected(String type, int id) {
    return _selection?.resourceType == type && _selection?.resourceId == id;
  }

  /// Closes the sheet with the selected resource.
  void _done() {
    final selection = _selection;
    if (selection == null) return;

    Navigator.of(context).pop(selection);
  }

  @override
  Widget build(BuildContext context) {
    final canDone = _selection != null;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Semantics(
                    button: true,
                    label: 'Close resource picker',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Add track or playlist',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    enabled: canDone,
                    label: 'Attach selected resource',
                    child: SizedBox(
                      width: 84,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: canDone ? _done : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.white24,
                          disabledForegroundColor: Colors.white54,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Likes'),
                Tab(text: 'Playlists'),
                Tab(text: 'Uploads'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MessageLikedTracksTab(
                    isSelected: _isSelected,
                    onSelect: _select,
                  ),
                  MessagePlaylistsTab(
                    isSelected: _isSelected,
                    onSelect: _select,
                  ),
                  MessageUploadsTab(isSelected: _isSelected, onSelect: _select),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
