/// Home screen with SoundCloud-inspired discovery rails and stations.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/auto_scrolling_text.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../discovery/domain/entities/discovery_track.dart';
import '../../../discovery/domain/entities/paginated_discovery_tracks.dart';
import '../../../discovery/presentation/discovery_genres.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../notifications/presentation/widgets/notification_bell_badge.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';
import '../../domain/entities/station_playlist.dart';
import '../utils/discovery_track_mapper.dart';
import '../widgets/liked_tracks_shortcut.dart';
import '../widgets/section_header.dart';
import '../widgets/station_playlist_card.dart';
import '../widgets/track_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final stationPageSize = isDesktop ? 12 : 8;
    final likesStationAsync = ref.watch(likesStationProvider);
    final artistStationAsync = ref.watch(
      artistStationProvider((page: 0, size: stationPageSize)),
    );
    final genreStationAsync = ref.watch(
      genreStationProvider((page: 0, size: stationPageSize)),
    );
    final popularTracksAsync = ref.watch(
      popularTracksProvider((page: 0, size: isDesktop ? 8 : 6)),
    );
    final horizontalPadding = isDesktop
        ? AppDimensions.paddingXl
        : AppDimensions.paddingMd;
    final topPadding = isDesktop
        ? AppDimensions.paddingXl
        : AppDimensions.paddingSm;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              title: const Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.go(RoutePaths.search),
                ),
                const GetProButton(),
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () => context.push(RoutePaths.upload),
                ),
                const NotificationBellBadge(),
                const SizedBox(width: 8),
              ],
            ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, topPadding, 0, AppDimensions.paddingXl),
        children: <Widget>[
          if (isDesktop)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Home', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppDimensions.paddingSm),
                  Text(
                    'Popular tracks and discovery stations.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLg),
                ],
              ),
            ),
          const LikedTracksShortcut(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: AppDimensions.paddingXl),
                const SectionHeader(title: 'Stations'),
                const SizedBox(height: AppDimensions.paddingMd),
                _StationsRailSection(
                  entries: [
                    _StationRailEntry(
                      asyncTracks: likesStationAsync,
                      kind: StationPlaylistKind.likes,
                      routePath: RoutePaths.homeLikesStation,
                      emptyMessage:
                          'Like a few tracks to kick-start your station.',
                    ),
                    _StationRailEntry(
                      asyncTracks: artistStationAsync,
                      kind: StationPlaylistKind.artist,
                      routePath: RoutePaths.homeArtistStation,
                      emptyMessage:
                          'Artist recommendations will show up after more listening.',
                    ),
                    _StationRailEntry(
                      asyncTracks: genreStationAsync,
                      kind: StationPlaylistKind.genre,
                      routePath: RoutePaths.homeGenreStation,
                      emptyMessage:
                          'Genre recommendations are quiet right now.',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXl),
                _HotForYouSection(
                  asyncTrackSources: [
                    popularTracksAsync,
                    likesStationAsync,
                    artistStationAsync,
                    genreStationAsync,
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXl),
                SectionHeader(
                  title: 'Popular tracks',
                  onSeeAll: () =>
                      context.push(RoutePaths.homePopularCollection),
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                _TrackRailSection(
                  asyncTracks: popularTracksAsync,
                  emptyMessage:
                      'Popular tracks will show up here once discovery loads.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StationRailEntry {
  const _StationRailEntry({
    required this.asyncTracks,
    required this.kind,
    required this.routePath,
    required this.emptyMessage,
  });

  final AsyncValue<PaginatedDiscoveryTracks> asyncTracks;
  final StationPlaylistKind kind;
  final String routePath;
  final String emptyMessage;
}

class _StationsRailSection extends StatelessWidget {
  const _StationsRailSection({required this.entries});

  final List<_StationRailEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.paddingMd),
        itemBuilder: (context, index) {
          return _StationRailCard(entry: entries[index]);
        },
      ),
    );
  }
}

class _StationRailCard extends StatelessWidget {
  const _StationRailCard({required this.entry});

  final _StationRailEntry entry;

  @override
  Widget build(BuildContext context) {
    return entry.asyncTracks.when(
      data: (response) {
        final playlist = StationPlaylist.fromTracks(
          kind: entry.kind,
          tracks: response.content,
        );

        if (playlist.tracks.isEmpty) {
          return _StationEmptyCard(
            title: entry.kind.title,
            message: entry.emptyMessage,
          );
        }

        return StationPlaylistCard(
          playlist: playlist,
          onTap: () => context.push(entry.routePath),
        );
      },
      loading: () => const _StationPlaylistPlaceholder(),
      error: (error, stackTrace) => _StationEmptyCard(
        title: entry.kind.title,
        message: error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      ),
    );
  }
}

class _TrackRailSection extends StatelessWidget {
  const _TrackRailSection({
    required this.asyncTracks,
    required this.emptyMessage,
  });

  final AsyncValue<PaginatedDiscoveryTracks> asyncTracks;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return asyncTracks.when(
      data: (PaginatedDiscoveryTracks response) {
        if (response.content.isEmpty) {
          return _SectionMessageCard(message: emptyMessage);
        }

        return SizedBox(
          height: 286,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: response.content.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: AppDimensions.paddingMd),
            itemBuilder: (BuildContext context, int index) {
              final track = response.content[index];

              return TrackCard(
                title: track.title,
                artist: track.artist.displayName ?? track.artist.username,
                imageUrl: track.coverUrl,
                gradientColors: _colorsForGenre(track.genre),
                tagLabel: track.genre,
                supportingText:
                    '${_formatCount(track.playCount)} plays - ${_formatCount(track.likeCount)} likes',
                onTap: () => context.push(RoutePaths.trackPreview(track.id)),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 286,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: AppDimensions.paddingMd),
          itemBuilder: (BuildContext context, int index) {
            return const _TrackCardPlaceholder();
          },
        ),
      ),
      error: (Object error, StackTrace stackTrace) {
        return _SectionMessageCard(
          message: error.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      },
    );
  }
}

class _HotForYouSection extends ConsumerWidget {
  const _HotForYouSection({required this.asyncTrackSources});

  final List<AsyncValue<PaginatedDiscoveryTracks>> asyncTrackSources;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responses = <PaginatedDiscoveryTracks>[];
    Object? firstError;
    var isLoading = false;

    for (final source in asyncTrackSources) {
      source.when<void>(
        data: responses.add,
        loading: () => isLoading = true,
        error: (error, stackTrace) => firstError ??= error,
      );
    }

    final tracks = _dedupeTracks(responses);
    final track = _selectHotTrack(tracks);
    if (track == null) {
      if (isLoading) {
        return const _HotForYouPlaceholder();
      }
      if (firstError != null) {
        return _SectionMessageCard(
          message: firstError.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
      return const SizedBox.shrink();
    }

    final playableTrack = discoveryTrackToLibraryTrack(track);
    final queue = discoveryTracksToLibraryTracks(tracks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TODAY'S PICK",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXs),
        Row(
          children: [
            Text(
              'Hot For You',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 30),
            ),
            const SizedBox(width: AppDimensions.paddingXs),
            const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        _HotForYouCard(
          track: track,
          onPlay: () {
            ref
                .read(trackAudioProvider.notifier)
                .playTrack(track: playableTrack, queue: queue, autoPlay: true);
          },
        ),
      ],
    );
  }

  List<DiscoveryTrack> _dedupeTracks(
    Iterable<PaginatedDiscoveryTracks> responses,
  ) {
    final tracksById = <int, DiscoveryTrack>{};
    for (final response in responses) {
      for (final track in response.content) {
        tracksById.putIfAbsent(track.id, () => track);
      }
    }
    return tracksById.values.toList(growable: false);
  }

  DiscoveryTrack? _selectHotTrack(List<DiscoveryTrack> tracks) {
    if (tracks.isEmpty) {
      return null;
    }

    final playableTracks = tracks.where(_hasPlayableUrl).toList();
    final candidates = playableTracks.isEmpty ? tracks : playableTracks;

    var selected = candidates.first;
    for (final track in candidates.skip(1)) {
      if (track.likeCount > selected.likeCount) {
        selected = track;
      }
    }
    return selected.likeCount > 0 ? selected : candidates.first;
  }

  bool _hasPlayableUrl(DiscoveryTrack track) {
    final trackUrl = track.trackUrl?.trim();
    final previewUrl = track.trackPreviewUrl?.trim();
    return (trackUrl != null && trackUrl.isNotEmpty) ||
        (previewUrl != null && previewUrl.isNotEmpty);
  }
}

class _HotForYouCard extends StatelessWidget {
  const _HotForYouCard({required this.track, required this.onPlay});

  final DiscoveryTrack track;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final coverUrl = track.coverUrl?.trim();
    final artistName = track.artist.displayName ?? track.artist.username;
    final likeLine = track.likeCount > 0
        ? '${_formatCount(track.likeCount)} people just liked this track'
        : 'Picked for your next listen';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Ink(
          height: 148,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.borderDark, width: 1),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (coverUrl != null && coverUrl.isNotEmpty)
                Opacity(
                  opacity: 0.22,
                  child: DecibelCachedImage(
                    imageUrl: coverUrl,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF32160E), Color(0xFF251B26)],
                    ),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.background.withValues(alpha: 0.28),
                      AppColors.surface.withValues(alpha: 0.82),
                      const Color(0xFF3D1218).withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 94,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.centerLeft,
                              children: [
                                const Positioned(
                                  left: 32,
                                  child: _VinylDisc(size: 72),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMd,
                                  ),
                                  child: SizedBox.square(
                                    dimension: 66,
                                    child:
                                        coverUrl != null && coverUrl.isNotEmpty
                                        ? DecibelCachedImage(
                                            imageUrl: coverUrl,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                const _HotCoverFallback(),
                                            errorWidget:
                                                const _HotCoverFallback(),
                                          )
                                        : const _HotCoverFallback(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoScrollingText(
                                  text: track.title,
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    fontSize: 21,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingXs),
                                Text(
                                  artistName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingSm),
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.textPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox.square(
                              dimension: 52,
                              child: IconButton(
                                onPressed: onPlay,
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.background,
                                  size: 34,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSm),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: AppDimensions.paddingSm),
                        Expanded(
                          child: Text(
                            likeLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VinylDisc extends StatelessWidget {
  const _VinylDisc({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF151515),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Center(
        child: Container(
          width: size * 0.18,
          height: size * 0.18,
          decoration: const BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _HotCoverFallback extends StatelessWidget {
  const _HotCoverFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A1D12), Color(0xFF2A2737)],
        ),
      ),
      child: Center(
        child: Icon(Icons.music_note_rounded, color: AppColors.textSecondary),
      ),
    );
  }
}

class _HotForYouPlaceholder extends StatelessWidget {
  const _HotForYouPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSm),
        Container(
          width: 190,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        Container(
          height: 148,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
      ],
    );
  }
}

class _TrackCardPlaceholder extends StatelessWidget {
  const _TrackCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.trackCardSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: AppDimensions.trackCardArtSize,
            height: AppDimensions.trackCardArtSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSm),
          Container(
            width: 140,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 96,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationPlaylistPlaceholder extends StatelessWidget {
  const _StationPlaylistPlaceholder();

  @override
  Widget build(BuildContext context) {
    const cardSize = 184.0;

    return SizedBox.square(
      dimension: cardSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              Container(
                height: 10,
                width: 132,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationEmptyCard extends StatelessWidget {
  const _StationEmptyCard({
    required this.title,
    required this.message,
    this.isError = false,
  });

  final String title;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    const cardSize = 184.0;

    return SizedBox.square(
      dimension: cardSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isError ? AppColors.errors : AppColors.borderDark,
            width: 0.6,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.graphic_eq,
                color: isError ? AppColors.errors : AppColors.primary,
                size: 32,
              ),
              const SizedBox(height: AppDimensions.paddingMd),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionMessageCard extends StatelessWidget {
  const _SectionMessageCard({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isError ? AppColors.errors : AppColors.borderDark,
          width: 0.6,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isError ? Icons.error_outline : Icons.graphic_eq,
            color: isError ? AppColors.errors : AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.paddingMd),
          Expanded(child: Text(message, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}

List<Color> _colorsForGenre(String? genre) {
  final normalizedGenre = genre?.trim().toLowerCase();

  for (final DiscoveryGenreOption option in discoveryGenreOptions) {
    if (option.label.toLowerCase() == normalizedGenre) {
      return option.colors;
    }
  }

  return const <Color>[AppColors.surfaceLight, AppColors.surfaceContainer];
}

String _formatCount(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    final formattedValue = (value / 1000).toStringAsFixed(
      value % 1000 == 0 ? 0 : 1,
    );
    return '${formattedValue}K';
  }
  return value.toString();
}
