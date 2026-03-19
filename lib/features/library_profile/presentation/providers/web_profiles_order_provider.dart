import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/web_profiles_provider.dart';

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

  void updateOrder(List<String> newOrder) {
    state = List.from(newOrder);
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final updated = [...state];
    // Safety check for out-of-bounds, though updateOrder should be used for full lists
    if (oldIndex < 0 || oldIndex >= updated.length) return;

    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = updated;
  }
}

final webProfilesOrderProvider =
    NotifierProvider<WebProfilesOrderNotifier, List<String>>(
      WebProfilesOrderNotifier.new,
    );

/// Consolidated provider that merges the saved order with any new links
/// that haven't been ordered yet.
final orderedWebPlatformsProvider = Provider<List<String>>((ref) {
  final socialLinks = ref.watch(webProfilesProvider);
  final savedOrder = ref.watch(webProfilesOrderProvider);

  // Fallback: links that have values but aren't in savedOrder yet
  final fallback = socialLinks.nonEmptyPlatforms(includeSupportLink: false);

  return <String>[
    // 1. Items from savedOrder that still have values
    ...savedOrder.where((p) => socialLinks.hasValueForPlatform(p)),
    // 2. Items from fallback that are NOT in savedOrder
    ...fallback.where((p) => !savedOrder.contains(p)),
  ];
});
