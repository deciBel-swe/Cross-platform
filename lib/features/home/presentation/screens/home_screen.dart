/// Home screen with SoundCloud-inspired discovery rails and stations.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../discovery/domain/entities/paginated_discovery_tracks.dart';
import '../../../discovery/presentation/discovery_genres.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../notifications/presentation/widgets/notification_bell_badge.dart';
import '../../../upgrade/presentation/widgets/get_pro_button.dart';
import '../widgets/liked_tracks_shortcut.dart';
import '../widgets/section_header.dart';
import '../widgets/track_card.dart';
import '../widgets/recently_played_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedGenre = discoveryGenreOptions.first.label;

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final likesStationAsync = ref.watch(likesStationProvider);
    final popularTracksAsync = ref.watch(
      popularTracksProvider((genre: null, limit: isDesktop ? 8 : 6)),
    );
    final genreStationAsync = ref.watch(
      genreStationProvider((
        genre: _selectedGenre,
        page: 0,
        size: isDesktop ? 8 : 6,
      )),
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
                SectionHeader(
                  title: 'Based on your likes',
                  onSeeAll: () => context.push(RoutePaths.libraryLikes),
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                _TrackRailSection(
                  asyncTracks: likesStationAsync,
                  emptyMessage: 'Like a few tracks to kick-start your station.',
                ),
                const SizedBox(height: AppDimensions.paddingXl),
                SectionHeader(
                  title: 'Popular tracks',
                  onSeeAll: () => context.go(RoutePaths.search),
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                _TrackRailSection(
                  asyncTracks: popularTracksAsync,
                  emptyMessage:
                      'Popular tracks will show up here once discovery loads.',
                ),
                const SizedBox(height: AppDimensions.paddingXl),
                SectionHeader(
                  title: 'Genre station',
                  onSeeAll: () => context.go(
                    Uri(
                      path: RoutePaths.search,
                      queryParameters: <String, String>{
                        'genre': _selectedGenre,
                      },
                    ).toString(),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                _GenreSelector(
                  selectedGenre: _selectedGenre,
                  onGenreSelected: (String genre) {
                    setState(() {
                      _selectedGenre = genre;
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMd),
                _TrackRailSection(
                  asyncTracks: genreStationAsync,
                  emptyMessage:
                      'No station tracks are available for $_selectedGenre yet.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreSelector extends StatelessWidget {
  const _GenreSelector({
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: discoveryGenreOptions.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppDimensions.paddingSm),
        itemBuilder: (BuildContext context, int index) {
          final option = discoveryGenreOptions[index];
          final isSelected = option.label == selectedGenre;

          return ChoiceChip(
            label: Text(option.label),
            selected: isSelected,
            onSelected: (_) => onGenreSelected(option.label),
            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surfaceVariant,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
            ),
          );
        },
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
                    '${_formatCount(track.playCount)} plays · ${_formatCount(track.likeCount)} likes',
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
