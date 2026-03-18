import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebProfilesOrderNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void addPlatformIfMissing(String platform) {
    if (state.contains(platform)) return;
    state = [...state, platform];
  }

  void removePlatform(String platform) {
    state = state.where((item) => item != platform).toList();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final updated = [...state];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = updated;
  }
}

final webProfilesOrderProvider =
    NotifierProvider<WebProfilesOrderNotifier, List<String>>(
  WebProfilesOrderNotifier.new,
);