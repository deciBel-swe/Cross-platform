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

  static const List<String> displayPlatforms = [instagram, twitter, website];

  static const List<String> allPlatforms = displayPlatforms;

  static String detectPlatform(String link) {
    final lower = link.toLowerCase();

    if (lower.contains('instagram.com')) {
      return instagram;
    }

    if (lower.contains('twitter.com') || lower.contains('x.com')) {
      return twitter;
    }

    return website;
  }

  static Widget iconForPlatform(String platform, {double size = 20}) {
    switch (platform) {
      case instagram:
        return FaIcon(FontAwesomeIcons.instagram, size: size);
      case twitter:
        return FaIcon(FontAwesomeIcons.xTwitter, size: size);
      case website:
      default:
        return Icon(Icons.public, size: size);
    }
  }
}
