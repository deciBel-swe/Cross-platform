import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_paths.dart';

/// Floating action button that opens the new-message user search flow.
class InboxNewMessageFab extends StatelessWidget {
  const InboxNewMessageFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('${RoutePaths.messages}/new'),
      backgroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.edit, color: Colors.black),
    );
  }
}
