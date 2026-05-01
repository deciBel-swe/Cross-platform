import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/widgets/follow_button.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';
import '../../../engagement/presentation/widgets/track_report_bottom_sheet.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/track.dart';
import '../widgets/track_comments_bottom_sheet.dart';
import '../widgets/track_more_options_menu.dart';

/// Screen displaying detailed information "behind" a track.
class BehindTrackScreen extends ConsumerWidget {
  const BehindTrackScreen({super.key, required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(trackPreviewProvider(trackId));

    return Scaffold(
      backgroundColor: const Color(
        0xFF121212,
      ), // Solid dark background matching the reference
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (data) => _BehindTrackContent(
          track: data.track,
          duration: data.track.duration.inSeconds,
        ),
      ),
    );
  }
}

class _BehindTrackContent extends StatelessWidget {
  const _BehindTrackContent({required this.track, required this.duration});

  final Track track;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _Header(trackId: track.id),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TrackInfoSection(track: track, duration: duration),
                  const SizedBox(height: 24),
                  _SocialSection(track: track),
                  const SizedBox(height: 24),
                  _DescriptionSection(description: track.description),
                  const SizedBox(height: 24),
                  _TagsSection(tags: track.tags),
                  const SizedBox(height: 32),
                  _ArtistProfileSection(artist: track.artist),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {
              // Cast functionality placeholder
            },
          ),
        ],
      ),
    );
  }
}

class _TrackInfoSection extends ConsumerWidget {
  const _TrackInfoSection({required this.track, required this.duration});

  final Track track;
  final int duration;

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat(
      'd MMM yyyy',
    ).format(track.releaseDate.toLocal());
    final formattedUploadDate = DateFormat(
      'd MMM yyyy',
    ).format(track.createdAt.toLocal());
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final durationText = duration > 0
        ? '$minutes:${seconds.toString().padLeft(2, '0')}'
        : '0:00';

    final playsFormatted = _formatCount(track.playCount);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DecibelCachedImage(
            imageUrl: track.coverUrl ?? '',
            width: 100, // Matched to reference scale
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                track.artist.username,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '$playsFormatted • $durationText',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Released $formattedDate',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // const SizedBox(height: 4),
              // Text(
              //   'Uploaded $formattedUploadDate',
              //   style: const TextStyle(color: Colors.white70, fontSize: 13),
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialSection extends ConsumerWidget {
  const _SocialSection({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioNotifier = ref.read(trackAudioProvider.notifier);
    final audioState = ref.watch(trackAudioProvider);
    final isPlaying =
        audioState.isPlaying && audioState.preparedTrackId == track.id;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
          trackId: track.id,
          isLiked: track.isLiked,
          likeCount: track.likeCount,
          iconSize: 24,
          fontSize: 15,
        ),
        const SizedBox(width: 20),
        RepostButton(
          trackId: track.id,
          isReposted: track.isReposted,
          repostCount: track.repostCount,
          iconSize: 24,
          fontSize: 15,
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => TrackCommentsBottomSheet.show(
            context,
            trackId: track.id,
            track: track,
          ),
          child: const _SocialItem(
            icon: Icons.chat_bubble_outline,
            count: 1, // Comment count placeholder
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () async {
            final option = await showTrackMoreOptionsMenu(
              context: context,
              includeDelete: false, // Or true based on ownership
            );

            if (context.mounted && option != null) {
              switch (option) {
                case TrackMoreOption.report:
                  await TrackReportBottomSheet.show(context, track.id);
                case TrackMoreOption.goToArtist:
                  context.go(RoutePaths.publicProfile(track.artist.username));
                case TrackMoreOption.share:
                  // Implement share logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing track...')),
                  );
                case TrackMoreOption.copyLink:
                  // Implement copy link logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                default:
                  // Handle other options if needed
                  break;
              }
            }
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              audioNotifier.pause();
            } else {
              audioNotifier.playTrack(track: track);
            }
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialItem extends StatelessWidget {
  const _SocialItem({
    required this.icon,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 6),
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatefulWidget {
  const _DescriptionSection({this.description});

  final String? description;

  @override
  State<_DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<_DescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final text = widget.description!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: _isExpanded ? null : 2,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Text(
            _isExpanded ? 'Show less' : 'Show more',
            style: const TextStyle(
              color: Colors.blueAccent, // Blue to match the reference
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _TagChip(label: tag)).toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(
          Uri(
            path: RoutePaths.search,
            queryParameters: {'q': label},
          ).toString(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A), // Dark grey pill matching reference
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '# $label',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ArtistProfileSection extends StatelessWidget {
  const _ArtistProfileSection({required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go(RoutePaths.publicProfile(artist.username)),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.surfaceVariant,
            backgroundImage: artist.avatarUrl != null
                ? NetworkImage(artist.avatarUrl!)
                : null,
            child: artist.avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 26)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => context.go(RoutePaths.publicProfile(artist.username)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.displayName ?? artist.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (artist.location != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    artist.location!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
        FollowButton(userId: artist.id, isFollowedBy: false),
      ],
    );
  }
}
