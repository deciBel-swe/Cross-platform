import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'liked_tracks_notifier.dart';

/// Provides a ScrollController that automatically triggers loadMore when
/// the user scrolls near the bottom of the liked tracks list.
final likedTracksScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) {
      final controller = ScrollController();

      controller.addListener(() {
        if (!controller.hasClients) return;

        final maxScroll = controller.position.maxScrollExtent;
        final currentScroll = controller.position.pixels;
        final delta =
            MediaQueryData.fromView(
              WidgetsBinding.instance.window,
            ).size.height *
            0.25;

        // Load more when within 25% of a screen height from the bottom
        if (maxScroll - currentScroll <= delta) {
          ref.read(likedTracksProvider.notifier).loadMore();
        }
      });

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });
