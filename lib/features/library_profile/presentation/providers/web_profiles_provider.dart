import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/public_profile_social_links.dart';
import '../../domain/repositories/profile_repository.dart';
import '../utils/web_profile_platform_utils.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => getIt<ProfileRepository>(),
);

class WebProfilesNotifier extends Notifier<PublicProfileSocialLinks> {
  @override
  PublicProfileSocialLinks build() {
    return const PublicProfileSocialLinks();
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  String getPlatformKey(String link) =>
      WebProfilePlatformUtils.detectPlatform(link);

  void setInitialLinks(PublicProfileSocialLinks links) {
    state = links;
  }

  bool _isValidHttpOrHttpsUrl(String link) {
    final trimmed = link.trim();

    if (trimmed.isEmpty) {
      return false;
    }

    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return false;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return false;
    }

    if ((uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.trim().isEmpty) {
      return false;
    }

    return true;
  }

  bool linkAlreadyExists(String link) {
    final trimmed = link.trim();

    return PublicProfileSocialLinks.allPlatforms.any((platform) {
      final value = state.valueForPlatform(platform);
      return value != null && value.trim() == trimmed;
    });
  }

  bool platformAlreadyExists(String link) {
    if (!_isValidHttpOrHttpsUrl(link)) {
      return false;
    }

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return state.hasValueForPlatform(platform);
  }

  String? getExistingLinkForPlatform(String link) {
    if (!_isValidHttpOrHttpsUrl(link)) {
      return null;
    }

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return state.valueForPlatform(platform);
  }

  bool isSamePlatform(String oldLink, String newLink) {
    if (!_isValidHttpOrHttpsUrl(oldLink) || !_isValidHttpOrHttpsUrl(newLink)) {
      return false;
    }

    return WebProfilePlatformUtils.detectPlatform(oldLink) ==
        WebProfilePlatformUtils.detectPlatform(newLink);
  }

  bool addLinkLocally(String rawLink) {
    final link = rawLink.trim();
    if (link.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(link)) return false;

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    state = state.copyWithPlatform(platform, link);
    return true;
  }

  bool editLinkLocally(String oldLink, String newLink) {
    final trimmedOld = oldLink.trim();
    final trimmedNew = newLink.trim();

    if (trimmedOld.isEmpty || trimmedNew.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(trimmedOld) ||
        !_isValidHttpOrHttpsUrl(trimmedNew)) {
      return false;
    }

    final oldPlatform = WebProfilePlatformUtils.detectPlatform(trimmedOld);
    final newPlatform = WebProfilePlatformUtils.detectPlatform(trimmedNew);

    if (oldPlatform == newPlatform) {
      state = state.copyWithPlatform(oldPlatform, trimmedNew);
      return true;
    }

    final nextState = state.copyWithPlatform(oldPlatform, null);
    state = nextState.copyWithPlatform(newPlatform, trimmedNew);
    return true;
  }

  bool deleteLinkLocally(String rawLink) {
    final link = rawLink.trim();
    if (link.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(link)) return false;

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    state = state.copyWithPlatform(platform, null);
    return true;
  }

  Future<bool> saveLink(String rawLink) async {
    final link = rawLink.trim();
    if (link.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(link)) return false;

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return _updateBackendAndState(
      (currentState) => currentState.copyWithPlatform(platform, link),
    );
  }

  Future<bool> editLink(String oldLink, String newLink) async {
    final trimmedOld = oldLink.trim();
    final trimmedNew = newLink.trim();

    if (trimmedOld.isEmpty || trimmedNew.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(trimmedOld) ||
        !_isValidHttpOrHttpsUrl(trimmedNew)) {
      return false;
    }

    final oldPlatform = WebProfilePlatformUtils.detectPlatform(trimmedOld);
    final newPlatform = WebProfilePlatformUtils.detectPlatform(trimmedNew);

    return _updateBackendAndState((currentState) {
      if (oldPlatform == newPlatform) {
        return currentState.copyWithPlatform(oldPlatform, trimmedNew);
      }

      final nextState = currentState.copyWithPlatform(oldPlatform, null);
      return nextState.copyWithPlatform(newPlatform, trimmedNew);
    });
  }

  Future<bool> deleteLink(String rawLink) async {
    final link = rawLink.trim();
    if (link.isEmpty) return false;
    if (!_isValidHttpOrHttpsUrl(link)) return false;

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return _updateBackendAndState(
      (currentState) => currentState.copyWithPlatform(platform, null),
    );
  }

  Future<bool> _updateBackendAndState(
    PublicProfileSocialLinks Function(PublicProfileSocialLinks) applyChanges,
  ) async {
    final currentState = state;
    final nextState = applyChanges(currentState);

    state = nextState;

    final result = await _repository.updateSocialLinks(nextState);

    result.fold(
      (failure) {
        state = currentState;
        debugPrint(
          '[WebProfilesNotifier] Failed to sync social links: $failure',
        );
      },
      (syncedLinks) {
        state = syncedLinks;
        debugPrint('[WebProfilesNotifier] Social links synced successfully.');
      },
    );

    return result.isRight();
  }
}

final webProfilesProvider =
    NotifierProvider<WebProfilesNotifier, PublicProfileSocialLinks>(
      WebProfilesNotifier.new,
    );
