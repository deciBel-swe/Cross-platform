import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import 'message_resource_tabs.dart';

class MessageResourceSelection {
  const MessageResourceSelection({
    required this.resourceType,
    required this.resourceId,
  });

  final String resourceType;
  final int resourceId;
}

class MessageResourcePickerSheet extends ConsumerStatefulWidget {
  const MessageResourcePickerSheet({super.key});

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

  String? _selectedType;
  int? _selectedId;

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

  void _select(String type, int id) {
    setState(() {
      _selectedType = type;
      _selectedId = id;
    });
  }

  bool _isSelected(String type, int id) {
    return _selectedType == type && _selectedId == id;
  }

  void _done() {
    final type = _selectedType;
    final id = _selectedId;

    if (type == null || id == null) return;

    Navigator.of(
      context,
    ).pop(MessageResourceSelection(resourceType: type, resourceId: id));
  }

  @override
  Widget build(BuildContext context) {
    final canDone = _selectedType != null && _selectedId != null;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
              child: Row(
                children: [
                  Semantics(
                    button: true,
                    label: 'Close resource picker',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
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
