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
        // Load more when within 200 pixels from the bottom
        const delta = 200.0;
        if (maxScroll - currentScroll <= delta) {
          ref.read(likedTracksProvider.notifier).loadMore();
        }
      });

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });
