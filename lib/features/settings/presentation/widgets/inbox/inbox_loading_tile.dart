import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class InboxLoadingTile extends StatelessWidget {
  const InboxLoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 24, backgroundColor: AppColors.surface),
      title: Text(
        'Loading...',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Loading profile...',
        style: TextStyle(color: Colors.white54, fontSize: 13),
      ),
    );
  }
}
