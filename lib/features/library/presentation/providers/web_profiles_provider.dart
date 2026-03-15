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

    if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
      return 'youtube';
    }

    if (lower.contains('tiktok.com')) {
      return 'tiktok';
    }

    if (lower.contains('linkedin.com')) {
      return 'linkedin';
    }

    if (lower.contains('snapchat.com')) {
      return 'snapchat';
    }

    if (lower.contains('facebook.com') || lower.contains('fb.com')) {
      return 'facebook';
    }

    return 'website';
  }

  String getPlatformKey(String link) {
    return _detectPlatform(link);
  }

  bool linkAlreadyExists(String link) {
    final trimmed = link.trim();

    return state.instagram == trimmed ||
        state.twitter == trimmed ||
        state.youtube == trimmed ||
        state.tiktok == trimmed ||
        state.linkedin == trimmed ||
        state.snapchat == trimmed ||
        state.facebook == trimmed ||
        state.website == trimmed;
  }

  bool platformAlreadyExists(String link) {
    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        return state.instagram != null && state.instagram!.trim().isNotEmpty;
      case 'twitter':
        return state.twitter != null && state.twitter!.trim().isNotEmpty;
      case 'youtube':
        return state.youtube != null && state.youtube!.trim().isNotEmpty;
      case 'tiktok':
        return state.tiktok != null && state.tiktok!.trim().isNotEmpty;
      case 'linkedin':
        return state.linkedin != null && state.linkedin!.trim().isNotEmpty;
      case 'snapchat':
        return state.snapchat != null && state.snapchat!.trim().isNotEmpty;
      case 'facebook':
        return state.facebook != null && state.facebook!.trim().isNotEmpty;
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
      case 'youtube':
        return state.youtube;
      case 'tiktok':
        return state.tiktok;
      case 'linkedin':
        return state.linkedin;
      case 'snapchat':
        return state.snapchat;
      case 'facebook':
        return state.facebook;
      case 'website':
        return state.website;
      default:
        return null;
    }
  }

  bool isSamePlatform(String oldLink, String newLink) {
    return _detectPlatform(oldLink) == _detectPlatform(newLink);
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
      case 'youtube':
        state = state.copyWith(youtube: link);
        break;
      case 'tiktok':
        state = state.copyWith(tiktok: link);
        break;
      case 'linkedin':
        state = state.copyWith(linkedin: link);
        break;
      case 'snapchat':
        state = state.copyWith(snapchat: link);
        break;
      case 'facebook':
        state = state.copyWith(facebook: link);
        break;
      case 'website':
        state = state.copyWith(website: link);
        break;
    }
  }

  void editLink(String oldLink, String newLink) {
    final trimmedOld = oldLink.trim();
    final trimmedNew = newLink.trim();

    if (trimmedOld.isEmpty || trimmedNew.isEmpty) return;

    if (state.instagram == trimmedOld) {
      state = state.copyWith(instagram: trimmedNew);
      return;
    }

    if (state.twitter == trimmedOld) {
      state = state.copyWith(twitter: trimmedNew);
      return;
    }

    if (state.youtube == trimmedOld) {
      state = state.copyWith(youtube: trimmedNew);
      return;
    }

    if (state.tiktok == trimmedOld) {
      state = state.copyWith(tiktok: trimmedNew);
      return;
    }

    if (state.linkedin == trimmedOld) {
      state = state.copyWith(linkedin: trimmedNew);
      return;
    }

    if (state.snapchat == trimmedOld) {
      state = state.copyWith(snapchat: trimmedNew);
      return;
    }

    if (state.facebook == trimmedOld) {
      state = state.copyWith(facebook: trimmedNew);
      return;
    }

    if (state.website == trimmedOld) {
      state = state.copyWith(website: trimmedNew);
      return;
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

    if (state.youtube == link) {
      state = state.copyWith(youtube: '');
      return;
    }

    if (state.tiktok == link) {
      state = state.copyWith(tiktok: '');
      return;
    }

    if (state.linkedin == link) {
      state = state.copyWith(linkedin: '');
      return;
    }

    if (state.snapchat == link) {
      state = state.copyWith(snapchat: '');
      return;
    }

    if (state.facebook == link) {
      state = state.copyWith(facebook: '');
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