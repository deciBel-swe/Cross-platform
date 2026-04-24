import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable cached network image widget used across the entire app.
///
/// Supports both remote URLs and local file paths.
/// Provides consistent loading placeholders and error fallbacks.
class DecibelCachedImage extends StatelessWidget {
  const DecibelCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.placeholderIcon = Icons.music_note,
    this.errorIcon = Icons.broken_image,
    this.iconSize = 32,
    this.iconColor,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.placeholder,
    this.errorWidget,
  });

  /// The URL or local file path of the image.
  final String imageUrl;

  /// Optional width/height constraints.
  final double? width;
  final double? height;

  /// How the image should be inscribed into the space. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// Filter quality for the image rendering. Defaults to [FilterQuality.low].
  final FilterQuality filterQuality;

  /// Icon shown while loading or on error if no custom widget is provided.
  final IconData placeholderIcon;
  final IconData errorIcon;
  final double iconSize;
  final Color? iconColor;

  /// Optional border radius for rectangular images.
  final BorderRadius? borderRadius;

  /// Shape of the clip area. Defaults to [BoxShape.rectangle].
  final BoxShape shape;

  /// Custom placeholder widget (overrides default icon placeholder).
  final Widget? placeholder;

  /// custom error widget (overrides default icon error widget).
  final Widget? errorWidget;

  bool _isRemoteUrl(String path) {
    final uri = Uri.tryParse(path);
    final scheme = uri?.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    final defaultIconColor =
        iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant;

    final fallbackPlaceholder =
        placeholder ??
        Center(
          child: Icon(placeholderIcon, size: iconSize, color: defaultIconColor),
        );

    final fallbackError =
        errorWidget ??
        Center(
          child: Icon(errorIcon, size: iconSize, color: defaultIconColor),
        );

    Widget image;

    if (_isRemoteUrl(imageUrl)) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        filterQuality: filterQuality,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) => fallbackPlaceholder,
        errorWidget: (context, url, error) => fallbackError,
      );
    } else {
      // Local file path
      image = Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: fit,
        filterQuality: filterQuality,
        errorBuilder: (context, error, stackTrace) => fallbackError,
      );
    }

    if (shape == BoxShape.circle) {
      return ClipOval(child: image);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}
