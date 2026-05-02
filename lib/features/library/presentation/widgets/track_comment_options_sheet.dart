import 'package:flutter/material.dart';

/// Shows actions for a comment and returns whether deletion was requested.
Future<bool?> showTrackCommentOptionsSheet(
  BuildContext context,
  ThemeData theme,
) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text(
              'Delete comment',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(sheetContext, true);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}
