import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// App bar used by the direct messages inbox on non-desktop layouts.
///
/// Exposes the page title as a semantic header while keeping the visual style
/// aligned with the dark inbox surface.
class InboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InboxAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Semantics(
        header: true,
        child: const Text(
          'Direct Messages',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
