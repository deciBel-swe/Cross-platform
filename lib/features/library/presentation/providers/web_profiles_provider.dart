import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';

class WebProfilesNotifier extends StateNotifier<PublicProfileSocialLinks> {
  WebProfilesNotifier() : super(const PublicProfileSocialLinks());

  String _detectPlatform(String link) {
    final lower = link.toLowerCase();

    if (lower.contains('instagram.com')) {
      return 'instagram';
    }

    if (lower.contains('twitter.com') || lower.contains('x.com')) {
      return 'twitter';
    }

    return 'website';
  }

  bool linkAlreadyExists(String link) {
    final trimmed = link.trim();
    final platform = _detectPlatform(trimmed);

    switch (platform) {
      case 'instagram':
        return state.instagram == trimmed;
      case 'twitter':
        return state.twitter == trimmed;
      case 'website':
        return state.website == trimmed;
      default:
        return false;
    }
  }

  bool platformAlreadyExists(String link) {
    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        return state.instagram != null && state.instagram!.trim().isNotEmpty;
      case 'twitter':
        return state.twitter != null && state.twitter!.trim().isNotEmpty;
      case 'website':
        return state.website != null && state.website!.trim().isNotEmpty;
      default:
        return false;
    }
  }

  String? getExistingLinkForPlatform(String link) {
    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        return state.instagram;
      case 'twitter':
        return state.twitter;
      case 'website':
        return state.website;
      default:
        return null;
    }
  }

  void saveLink(String rawLink) {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        state = state.copyWith(instagram: link);
        break;
      case 'twitter':
        state = state.copyWith(twitter: link);
        break;
      case 'website':
        state = state.copyWith(website: link);
        break;
    }
  }

  void editLink(String rawLink) {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        state = state.copyWith(instagram: link);
        break;
      case 'twitter':
        state = state.copyWith(twitter: link);
        break;
      case 'website':
        state = state.copyWith(website: link);
        break;
    }
  }

void deleteLink(String rawLink) {
  final link = rawLink.trim();
  if (link.isEmpty) return;

  if (state.instagram == link) {
    state = state.copyWith(instagram: '');
    return;
  }

  if (state.twitter == link) {
    state = state.copyWith(twitter: '');
    return;
  }

  if (state.website == link) {
    state = state.copyWith(website: '');
    return;
  }
}
}

final webProfilesProvider =
    StateNotifierProvider<WebProfilesNotifier, PublicProfileSocialLinks>(
  (ref) => WebProfilesNotifier(),
);