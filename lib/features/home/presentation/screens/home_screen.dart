/// Desktop Home screen — SoundCloud-style with horizontal carousels.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/router/route_paths.dart';

/// Empty Home page – placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: isDesktop
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () {
                    context.push(RoutePaths.upload);
                  },
                ),
              ],
      ),
      body: const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}
