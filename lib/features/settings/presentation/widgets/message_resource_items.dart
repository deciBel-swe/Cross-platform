import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library/domain/entities/track.dart';
import '../../../playlists/domain/entities/playlist.dart';

/// Selectable track row used by the message resource picker.
class MessageTrackResourceTile extends StatelessWidget {
  const MessageTrackResourceTile({
    super.key,
    required this.track,
    required this.selected,
    required this.onTap,
  });

  final Track track;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final artistName = track.artist.username;
    final coverUrl = track.coverUrl;

    return Semantics(
      button: true,
      selected: selected,
      label: '${track.title} by $artistName',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              MessageArtworkBox(
                imageUrl: coverUrl,
                fallbackIcon: Icons.music_note,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MessageResourceTitleSubtitle(
                  title: track.title,
                  subtitle: artistName,
                ),
              ),
              MessageSelectionCircle(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selectable playlist row used by the message resource picker.
class MessagePlaylistResourceTile extends StatelessWidget {
  const MessagePlaylistResourceTile({
    super.key,
    required this.playlist,
    required this.selected,
    required this.onTap,
  });

  final Playlist playlist;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = playlist.coverArt;
    final subtitle =
        '${playlist.tracks.length} track${playlist.tracks.length == 1 ? '' : 's'}';

    return Semantics(
      button: true,
      selected: selected,
      label: '${playlist.title}, playlist, $subtitle',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              MessageArtworkBox(
                imageUrl: coverUrl,
                fallbackIcon: Icons.queue_music,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MessageResourceTitleSubtitle(
                  title: playlist.title,
                  subtitle: subtitle,
                ),
              ),
              MessageSelectionCircle(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square artwork image with an icon fallback for picker rows.
class MessageArtworkBox extends StatelessWidget {
  const MessageArtworkBox({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
  });

  final String? imageUrl;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 58,
          height: 58,
          color: AppColors.surface,
          child: url == null || url.isEmpty
              ? Icon(fallbackIcon, color: Colors.white54)
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Icon(fallbackIcon, color: Colors.white54),
                ),
        ),
      ),
    );
  }
}

/// One-line title and subtitle block shared by resource picker rows.
class MessageResourceTitleSubtitle extends StatelessWidget {
  const MessageResourceTitleSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}

/// Circular visual indicator for the selected picker resource.
class MessageSelectionCircle extends StatelessWidget {
  const MessageSelectionCircle({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white70, width: 2),
          color: selected ? Colors.white : Colors.transparent,
        ),
        child: selected
            ? const Icon(Icons.check, size: 18, color: Colors.black)
            : null,
      ),
    );
  }
}
