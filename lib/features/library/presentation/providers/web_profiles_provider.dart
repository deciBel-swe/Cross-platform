import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library_profile/domain/entities/public_profile_social_links.dart';

class WebProfilesNotifier extends StateNotifier<PublicProfileSocialLinks> {
  WebProfilesNotifier() : super(const PublicProfileSocialLinks());

  void saveLink(String rawLink) {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final lower = link.toLowerCase();

    if (lower.contains('instagram.com')) {
      state = state.copyWith(instagram: link);
      return;
    }

    if (lower.contains('twitter.com') || lower.contains('x.com')) {
      state = state.copyWith(twitter: link);
      return;
    }

    state = state.copyWith(website: link);
  }
}

final webProfilesProvider =
    StateNotifierProvider<WebProfilesNotifier, PublicProfileSocialLinks>(
      (ref) => WebProfilesNotifier(),
    );
