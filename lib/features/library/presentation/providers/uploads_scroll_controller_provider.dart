import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'uploads_provider.dart';

final uploadsScrollControllerProvider = Provider.autoDispose<ScrollController>((
  ref,
) {
  final controller = ScrollController();

  void onScroll() {
    if (!controller.hasClients) return;
    final position = controller.position;

    // Load next page when the user is close to the bottom.
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(uploadsProvider.notifier).loadNextPage();
    }
  }

  controller.addListener(onScroll);

  ref.onDispose(() {
    controller.removeListener(onScroll);
    controller.dispose();
  });

  return controller;
});
