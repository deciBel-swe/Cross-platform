import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';
import '../widgets/liked_tracks_shortcut.dart';
import '../widgets/recently_played_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Home'),
              actions: [
                const GetProButton(),
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () {
                    context.push(RoutePaths.upload);
                  },
                ),
              ],
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LikedTracksShortcut(),
          SizedBox(height: 16),
          RecentlyPlayedSection(),
          SizedBox(height: 24),
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