/// Home screen with SoundCloud-inspired discovery rails and stations.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/widgets/notification_bell_badge.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';
import '../widgets/liked_tracks_shortcut.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              title: const Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.go(RoutePaths.search),
                ),
                const GetProButton(),
                IconButton(
                  icon: const Icon(Icons.inbox),
                  onPressed: () {
                    context.push(RoutePaths.messages);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () {
                    context.push(RoutePaths.upload);
                  },
                ),

                const NotificationBellBadge(),

                const SizedBox(width: 8),
              ],
            ),
      body: const Column(
        children: [
          LikedTracksShortcut(),
          Text('Home', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}
