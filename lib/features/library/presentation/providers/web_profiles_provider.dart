import 'dart:convert';

import 'package:decibel/core/storage/secure_storage_service.dart';
import 'package:decibel/features/auth/presentation/providers/auth_provider.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class WebProfilesNotifier extends StateNotifier<PublicProfileSocialLinks> {
  WebProfilesNotifier(this._secureStorageService)
      : super(const PublicProfileSocialLinks());

  final SecureStorageService _secureStorageService;

  static const String _baseUrl = 'http://192.168.1.4.nip.io:3000/api';

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

    if (lower.contains('patreon.com') ||
        lower.contains('buymeacoffee.com') ||
        lower.contains('ko-fi.com')) {
      return 'supportLink';
    }

    return 'website';
  }

  String getPlatformKey(String link) {
    return _detectPlatform(link);
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
    final platform = _detectPlatform(link);

    switch (platform) {
      case 'instagram':
        return _hasValue(state.instagram);
      case 'twitter':
        return _hasValue(state.twitter);
      case 'youtube':
        return _hasValue(state.youtube);
      case 'tiktok':
        return _hasValue(state.tiktok);
      case 'linkedin':
        return _hasValue(state.linkedin);
      case 'snapchat':
        return _hasValue(state.snapchat);
      case 'facebook':
        return _hasValue(state.facebook);
      case 'website':
        return _hasValue(state.website);
      case 'supportLink':
        return _hasValue(state.supportLink);
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
      case 'supportLink':
        return state.supportLink;
      default:
        return null;
    }
  }

  bool isSamePlatform(String oldLink, String newLink) {
    return _detectPlatform(oldLink) == _detectPlatform(newLink);
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
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

  PublicProfileSocialLinks _copyWithPlatform(
    PublicProfileSocialLinks current,
    String platform,
    String? value,
  ) {
    switch (platform) {
      case 'instagram':
        return current.copyWith(instagram: value);
      case 'twitter':
        return current.copyWith(twitter: value);
      case 'youtube':
        return current.copyWith(youtube: value);
      case 'tiktok':
        return current.copyWith(tiktok: value);
      case 'linkedin':
        return current.copyWith(linkedin: value);
      case 'snapchat':
        return current.copyWith(snapchat: value);
      case 'facebook':
        return current.copyWith(facebook: value);
      case 'website':
        return current.copyWith(website: value);
      case 'supportLink':
        return current.copyWith(supportLink: value);
      default:
        return current;
    }
  }

  Future<void> saveLink(String rawLink) async {
    final link = rawLink.trim();
    if (link.isEmpty) return;

    final platform = _detectPlatform(link);
    final nextState = _copyWithPlatform(state, platform, link);

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

    final oldPlatform = _detectPlatform(trimmedOld);
    final newPlatform = _detectPlatform(trimmedNew);

    if (oldPlatform == newPlatform) {
      final nextState = _copyWithPlatform(state, oldPlatform, trimmedNew);

      if (_isBackendSupported(oldPlatform)) {
        await _patchBackend(nextState);
      } else {
        state = nextState;
      }
      return;
    }

    var nextState = _copyWithPlatform(state, oldPlatform, null);
    nextState = _copyWithPlatform(nextState, newPlatform, trimmedNew);

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

    final platform = _detectPlatform(link);

    if (_isBackendSupported(platform)) {
      final backendDeleteState = _copyWithPlatform(state, platform, null);
      await _patchBackend(backendDeleteState);
    } else {
      final nextState = _copyWithPlatform(state, platform, '');
      state = nextState;
    }
  }
}

final webProfilesProvider =
    StateNotifierProvider<WebProfilesNotifier, PublicProfileSocialLinks>(
  (ref) => WebProfilesNotifier(ref.read(secureStorageServiceProvider)),
);