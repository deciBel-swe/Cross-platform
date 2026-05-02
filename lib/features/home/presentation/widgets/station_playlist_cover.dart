import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../domain/entities/station_playlist.dart';

class StationPlaylistCover extends StatelessWidget {
  const StationPlaylistCover({
    super.key,
    required this.playlist,
    required this.size,
    this.borderRadius = 8,
  });

  final StationPlaylist playlist;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final coverUrls = playlist.coverUrls;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox.square(
        dimension: size,
        child: coverUrls.isEmpty
            ? _FallbackCover(kind: playlist.kind)
            : _MosaicCover(coverUrls: coverUrls),
      ),
    );
  }
}

class _MosaicCover extends StatelessWidget {
  const _MosaicCover({required this.coverUrls});

  final List<String> coverUrls;

  @override
  Widget build(BuildContext context) {
    if (coverUrls.length == 1) {
      return DecibelCachedImage(
        imageUrl: coverUrls.first,
        fit: BoxFit.cover,
        placeholder: const _CoverPlaceholder(),
        errorWidget: const _CoverPlaceholder(),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final imageUrl = coverUrls[index % coverUrls.length];
        return DecibelCachedImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: const _CoverPlaceholder(),
          errorWidget: const _CoverPlaceholder(),
        );
      },
    );
  }
}

class _FallbackCover extends StatelessWidget {
  const _FallbackCover({required this.kind});

  final StationPlaylistKind kind;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientForKind(kind),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _StationFallbackPainter(kind: kind)),
          ),
          const Center(
            child: Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.textPrimary,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Icon(Icons.music_note_rounded, color: AppColors.textMuted),
      ),
    );
  }
}

class _StationFallbackPainter extends CustomPainter {
  const _StationFallbackPainter({required this.kind});

  final StationPlaylistKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary.withValues(alpha: 0.58);

    final count = switch (kind) {
      StationPlaylistKind.likes => 5,
      StationPlaylistKind.artist => 4,
      StationPlaylistKind.genre => 6,
    };

    for (var index = 0; index < count; index += 1) {
      final inset = 12.0 + (index * 7.0);
      final rect = Rect.fromLTWH(
        inset,
        inset,
        size.width - (inset * 2),
        size.height - (inset * 2),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StationFallbackPainter oldDelegate) {
    return oldDelegate.kind != kind;
  }
}

List<Color> _gradientForKind(StationPlaylistKind kind) {
  switch (kind) {
    case StationPlaylistKind.likes:
      return const [Color(0xFF411000), Color(0xFF242424)];
    case StationPlaylistKind.artist:
      return const [Color(0xFF132A35), Color(0xFF3A1A10)];
    case StationPlaylistKind.genre:
      return const [Color(0xFF1F2D1F), Color(0xFF302130)];
  }
}
