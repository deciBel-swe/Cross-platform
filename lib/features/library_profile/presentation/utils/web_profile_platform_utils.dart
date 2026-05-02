import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WebProfilePlatformUtils {
  static const String instagram = 'instagram';
  static const String twitter = 'twitter';
  static const String youtube = 'youtube';
  static const String tiktok = 'tiktok';
  static const String linkedin = 'linkedin';
  static const String snapchat = 'snapchat';
  static const String facebook = 'facebook';
  static const String website = 'website';
  static const String supportLink = 'supportLink';

  static const List<String> displayPlatforms = [
    instagram,
    twitter,
    youtube,
    tiktok,
    linkedin,
    snapchat,
    facebook,
    website,
  ];

  static const List<String> allPlatforms = [...displayPlatforms, supportLink];

  static String detectPlatform(String link) {
    final lower = link.toLowerCase();

    if (lower.contains('instagram.com')) {
      return instagram;
    }

    if (lower.contains('twitter.com') || lower.contains('x.com')) {
      return twitter;
    }

    if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
      return youtube;
    }

    if (lower.contains('tiktok.com')) {
      return tiktok;
    }

    if (lower.contains('linkedin.com')) {
      return linkedin;
    }

    if (lower.contains('snapchat.com')) {
      return snapchat;
    }

    if (lower.contains('facebook.com') || lower.contains('fb.com')) {
      return facebook;
    }

    if (lower.contains('patreon.com') ||
        lower.contains('buymeacoffee.com') ||
        lower.contains('ko-fi.com')) {
      return supportLink;
    }

    return website;
  }

  static Widget iconForPlatform(String platform, {double size = 20}) {
    switch (platform) {
      case instagram:
        return FaIcon(FontAwesomeIcons.instagram, size: size);
      case twitter:
        return FaIcon(FontAwesomeIcons.xTwitter, size: size);
      case youtube:
        return FaIcon(FontAwesomeIcons.youtube, size: size);
      case tiktok:
        return FaIcon(FontAwesomeIcons.tiktok, size: size);
      case linkedin:
        return FaIcon(FontAwesomeIcons.linkedin, size: size);
      case snapchat:
        return FaIcon(FontAwesomeIcons.snapchat, size: size);
      case facebook:
        return FaIcon(FontAwesomeIcons.facebook, size: size);
      case website:
      case supportLink:
      default:
        return Icon(Icons.public, size: size);
    }
  }
}
