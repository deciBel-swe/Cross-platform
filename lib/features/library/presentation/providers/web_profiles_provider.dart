import 'dart:convert';

import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:decibel/features/library/presentation/utils/web_profile_platform_utils.dart';

class WebProfilesNotifier extends StateNotifier<PublicProfileSocialLinks> {
  WebProfilesNotifier(this._secureStorageService)
      : super(const PublicProfileSocialLinks());

  final SecureStorageService _secureStorageService;

  static const String _baseUrl = 'http://192.168.1.4.nip.io:3000/api';

  String getPlatformKey(String link) {
    return WebProfilePlatformUtils.detectPlatform(link);
  }

  bool linkAlreadyExists(String link) {
    final trimmed = link.trim();

    return _normalizedOrNull(state.instagram) == trimmed ||
        _normalizedOrNull(state.twitter) == trimmed ||
        _normalizedOrNull(state.youtube) == trimmed ||
        _normalizedOrNull(state.tiktok) == trimmed ||
        _normalizedOrNull(state.linkedin) == trimmed ||
        _normalizedOrNull(state.snapchat) == trimmed ||
        _normalizedOrNull(state.facebook) == trimmed ||
        _normalizedOrNull(state.website) == trimmed ||
        _normalizedOrNull(state.supportLink) == trimmed;
  }

  bool platformAlreadyExists(String link) {
    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return state.hasValueForPlatform(platform);
  }

  String? getExistingLinkForPlatform(String link) {
    final platform = WebProfilePlatformUtils.detectPlatform(link);
    return state.valueForPlatform(platform);
  }

  bool isSamePlatform(String oldLink, String newLink) {
    return WebProfilePlatformUtils.detectPlatform(oldLink) ==
        WebProfilePlatformUtils.detectPlatform(newLink);
  }

  String? _normalizedOrNull(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  bool _isBackendSupported(String platform) {
    return platform == 'instagram' ||
        platform == 'twitter' ||
        platform == 'website' ||
        platform == 'supportLink';
  }

  Map<String, dynamic> _backendPayloadFromState(PublicProfileSocialLinks data) {
    return {
      'instagram': _normalizedOrNull(data.instagram),
      'twitter': _normalizedOrNull(data.twitter),
      'website': _normalizedOrNull(data.website),
      'supportLink': _normalizedOrNull(data.supportLink),
    };
  }

  PublicProfileSocialLinks _mergeBackendResponse(
    PublicProfileSocialLinks current,
    Map<String, dynamic> json,
  ) {
    return current.copyWith(
      instagram: json['instagram'] as String?,
      twitter: json['twitter'] as String?,
      website: json['website'] as String?,
      supportLink: json['supportLink'] as String?,
    );
  }

  Future<void> _patchBackend(PublicProfileSocialLinks nextState) async {
    final token = await _secureStorageService.getAccessToken();

    // Temporary mock/dev fallback:
    // if no token is available, keep feature working locally.
    if (token == null || token.trim().isEmpty) {
      if (kDebugMode) {
        debugPrint(
          '[WebProfilesNotifier] No access token found. '
          'Using local mock fallback instead of backend PATCH.',
        );
      }

      state = nextState;
      return;
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/users/me/social-links'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(_backendPayloadFromState(nextState)),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.trim().isEmpty) {
        state = nextState;
        return;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      state = _mergeBackendResponse(nextState, decoded);
      return;
    }

    throw Exception('Failed to update social links: ${response.statusCode}');
  }

  Future<void> saveLink(String rawLink) async {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final platform = WebProfilePlatformUtils.detectPlatform(link);
    final nextState = state.copyWithPlatform(platform, link);

    if (_isBackendSupported(platform)) {
      await _patchBackend(nextState);
    } else {
      state = nextState;
    }
  }

  Future<void> editLink(String oldLink, String newLink) async {
    final trimmedOld = oldLink.trim();
    final trimmedNew = newLink.trim();

    if (trimmedOld.isEmpty || trimmedNew.isEmpty) return;

    final oldPlatform = WebProfilePlatformUtils.detectPlatform(trimmedOld);
    final newPlatform = WebProfilePlatformUtils.detectPlatform(trimmedNew);

    if (oldPlatform == newPlatform) {
      final nextState = state.copyWithPlatform(oldPlatform, trimmedNew);

      if (_isBackendSupported(oldPlatform)) {
        await _patchBackend(nextState);
      } else {
        state = nextState;
      }
      return;
    }

    var nextState = state.copyWithPlatform(oldPlatform, null);
    nextState = nextState.copyWithPlatform(newPlatform, trimmedNew);

    final needsBackend =
        _isBackendSupported(oldPlatform) || _isBackendSupported(newPlatform);

    if (needsBackend) {
      await _patchBackend(nextState);
    } else {
      state = nextState;
    }
  }

  Future<void> deleteLink(String rawLink) async {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final platform = WebProfilePlatformUtils.detectPlatform(link);

    if (_isBackendSupported(platform)) {
      final backendDeleteState = state.copyWithPlatform(platform, null);
      await _patchBackend(backendDeleteState);
    } else {
      final nextState = state.copyWithPlatform(platform, '');
      state = nextState;
    }
  }
}

final webProfilesProvider =
    StateNotifierProvider<WebProfilesNotifier, PublicProfileSocialLinks>(
  (ref) => WebProfilesNotifier(ref.read(secureStorageServiceProvider)),
);