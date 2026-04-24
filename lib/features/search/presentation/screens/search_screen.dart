/// Search screen with routed queries, filters, and genre-led stations.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../discovery/domain/entities/discovery_playlist.dart';
import '../../../discovery/domain/entities/discovery_search_response.dart';
import '../../../discovery/domain/entities/discovery_search_type.dart';
import '../../../discovery/domain/entities/discovery_track.dart';
import '../../../discovery/domain/entities/discovery_user.dart';
import '../../../discovery/domain/entities/paginated_discovery_tracks.dart';
import '../../../discovery/presentation/discovery_genres.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../widgets/genre_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _queryController;
  Timer? _debounce;
  DiscoverySearchType _selectedType = DiscoverySearchType.all;
  String _selectedGenre = discoveryGenreOptions.first.label;

  String? _lastSyncedQuery;
  String? _lastSyncedType;
  String? _lastSyncedGenre;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncFromRoute();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktopLayout(context);
    final uri = GoRouterState.of(context).uri;
    final routeQuery = uri.queryParameters['q']?.trim() ?? '';
    final routeGenre = uri.queryParameters['genre']?.trim() ?? _selectedGenre;
    final hasSearchQuery = routeQuery.length >= 2;
    final hasTooShortQuery = routeQuery.isNotEmpty && routeQuery.length < 2;

    final searchAsync = hasSearchQuery
        ? ref.watch(
            searchResultsProvider(
              (
                query: routeQuery,
                type: _selectedType,
                page: 0,
                size: 20,
              ),
            ),
          )
        : null;
    final genreStationAsync = ref.watch(
      genreStationProvider(
        (genre: routeGenre, page: 0, size: isDesktop ? 10 : 6),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              title: const Text('Search'),
            ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingMd,
          isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingMd,
          isDesktop ? AppDimensions.paddingXl : AppDimensions.paddingMd,
          AppDimensions.paddingXl,
        ),
        children: <Widget>[
          if (isDesktop) ...<Widget>[
            const Text('Search', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              'Artists, tracks, playlists, and radio-style stations in one place.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLg),
          ],
          _SearchInputBar(
            controller: _queryController,
            onChanged: _handleQueryChanged,
            onSubmitted: (_) => _applyRouteState(),
            onClear: _handleClear,
            hasText: _queryController.text.trim().isNotEmpty,
          ),
          const SizedBox(height: AppDimensions.paddingLg),
          _SearchTypeBar(
            selectedType: _selectedType,
            onTypeSelected: _handleTypeSelected,
          ),
          const SizedBox(height: AppDimensions.paddingXl),
          if (hasTooShortQuery)
            const _SearchMessageCard(
              message: 'Type at least 2 characters to search.',
            )
          else if (hasSearchQuery && searchAsync != null)
            _SearchResultsSection(
              asyncResults: searchAsync,
              selectedType: _selectedType,
            )
          else
            _BrowseSection(
              selectedGenre: routeGenre,
              genreStationAsync: genreStationAsync,
              onGenreSelected: _handleGenreSelected,
            ),
        ],
      ),
    );
  }

  void _syncFromRoute() {
    final uri = GoRouterState.of(context).uri;
    final routeQuery = uri.queryParameters['q']?.trim() ?? '';
    final routeType = uri.queryParameters['type'];
    final routeGenre = uri.queryParameters['genre']?.trim();

    if (_lastSyncedQuery == routeQuery &&
        _lastSyncedType == routeType &&
        _lastSyncedGenre == routeGenre) {
      return;
    }

    _lastSyncedQuery = routeQuery;
    _lastSyncedType = routeType;
    _lastSyncedGenre = routeGenre;

    _selectedType = DiscoverySearchType.fromQueryValue(routeType);
    _selectedGenre = routeGenre?.isNotEmpty == true
        ? routeGenre!
        : discoveryGenreOptions.first.label;

    if (_queryController.text != routeQuery) {
      _queryController.value = TextEditingValue(
        text: routeQuery,
        selection: TextSelection.collapsed(offset: routeQuery.length),
      );
    }
  }

  void _handleQueryChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _applyRouteState);
  }

  void _handleClear() {
    _debounce?.cancel();
    _queryController.clear();
    setState(() {});
    _applyRouteState();
  }

  void _handleTypeSelected(DiscoverySearchType type) {
    setState(() {
      _selectedType = type;
    });
    _applyRouteState();
  }

  void _handleGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
    });
    _applyRouteState();
  }

  void _applyRouteState() {
    if (!mounted) {
      return;
    }

    final query = _queryController.text.trim();
    final queryParameters = <String, String>{
      if (query.isNotEmpty) 'q': query,
      if (_selectedType != DiscoverySearchType.all)
        'type': _selectedType.queryValue,
      'genre': _selectedGenre,
    };

    context.go(
      Uri(path: RoutePaths.search, queryParameters: queryParameters).toString(),
    );
  }
}

class _SearchInputBar extends StatelessWidget {
  const _SearchInputBar({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.hasText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final bool hasText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(fontSize: 15, color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for artists, tracks, playlists...',
        hintStyle: const TextStyle(fontSize: 15, color: Colors.white38),
        prefixIcon: const Icon(Icons.search, color: Colors.white38),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SearchTypeBar extends StatelessWidget {
  const _SearchTypeBar({
    required this.selectedType,
    required this.onTypeSelected,
  });

  final DiscoverySearchType selectedType;
  final ValueChanged<DiscoverySearchType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.paddingSm,
      runSpacing: AppDimensions.paddingSm,
      children: DiscoverySearchType.values
          .map(
            (DiscoverySearchType type) => ChoiceChip(
              label: Text(type.label),
              selected: type == selectedType,
              onSelected: (_) => onTypeSelected(type),
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceVariant,
              side: BorderSide(
                color: type == selectedType
                    ? AppColors.primary
                    : AppColors.borderLight,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection({
    required this.asyncResults,
    required this.selectedType,
  });

  final AsyncValue<DiscoverySearchResponse> asyncResults;
  final DiscoverySearchType selectedType;

  @override
  Widget build(BuildContext context) {
    return asyncResults.when(
      data: (DiscoverySearchResponse results) {
        final hasAnyResults =
            results.users.isNotEmpty ||
            results.tracks.isNotEmpty ||
            results.playlists.isNotEmpty;

        if (!hasAnyResults) {
          return const _SearchMessageCard(
            message:
                'No results yet. Try another spelling, a username, or a different filter.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (selectedType == DiscoverySearchType.all ||
                selectedType == DiscoverySearchType.tracks)
              _TrackResultsList(tracks: results.tracks),
            if ((selectedType == DiscoverySearchType.all ||
                    selectedType == DiscoverySearchType.users) &&
                results.users.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppDimensions.paddingXl),
              _UserResultsList(users: results.users),
            ],
            if ((selectedType == DiscoverySearchType.all ||
                    selectedType == DiscoverySearchType.playlists) &&
                results.playlists.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppDimensions.paddingXl),
              _PlaylistResultsList(playlists: results.playlists),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLg),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (Object error, StackTrace stackTrace) {
        return _SearchMessageCard(
          message: error.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      },
    );
  }
}

class _TrackResultsList extends StatelessWidget {
  const _TrackResultsList({required this.tracks});

  final List<DiscoveryTrack> tracks;

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const _SearchMessageCard(
        message: 'No tracks matched this search yet.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SearchSectionTitle('Tracks'),
        const SizedBox(height: AppDimensions.paddingMd),
        ...tracks.map(
          (DiscoveryTrack track) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
            child: _SearchSurface(
              onTap: () => context.push(RoutePaths.trackPreview(track.id)),
              leading: _ArtworkSquare(
                imageUrl: track.coverUrl,
                icon: Icons.music_note,
                colors: _colorsForGenre(track.genre),
              ),
              title: track.title,
              subtitle:
                  '${track.artist.displayName ?? track.artist.username}${track.genre == null ? '' : ' • ${track.genre}'}',
              meta:
                  '${_formatCount(track.playCount)} plays · ${_formatCount(track.likeCount)} likes',
              trailingIcon: Icons.play_circle_fill_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _UserResultsList extends StatelessWidget {
  const _UserResultsList({required this.users});

  final List<DiscoveryUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SearchSectionTitle('People'),
        const SizedBox(height: AppDimensions.paddingMd),
        ...users.map(
          (DiscoveryUser user) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
            child: _SearchSurface(
              onTap: () => context.push(
                RoutePaths.publicProfile(
                  user.username.trim().isNotEmpty
                      ? user.username
                      : user.id.toString(),
                ),
              ),
              leading: _UserAvatar(user: user),
              title: user.displayName ?? user.username,
              subtitle: user.followerCount > 0
                  ? '@${user.username} · ${_formatCount(user.followerCount)} followers'
                  : '@${user.username}',
              meta: user.trackCount > 0
                  ? '${_formatCount(user.trackCount)} tracks'
                  : 'View profile',
              trailingIcon: Icons.arrow_forward_ios_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaylistResultsList extends StatelessWidget {
  const _PlaylistResultsList({required this.playlists});

  final List<DiscoveryPlaylist> playlists;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SearchSectionTitle('Playlists'),
        const SizedBox(height: AppDimensions.paddingMd),
        ...playlists.map(
          (DiscoveryPlaylist playlist) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
            child: _SearchSurface(
              onTap: () => context.push(
                RoutePaths.playlistTracks,
                extra: _toPlaylistEntity(playlist),
              ),
                        leading: _ArtworkSquare(
                          imageUrl: playlist.coverArtUrl,
                          icon: Icons.queue_music_rounded,
                          colors: _colorsForGenre(
                            playlist.genres.isEmpty ? null : playlist.genres.first,
                          ),
                        ),
              title: playlist.title,
              subtitle:
                  'By ${playlist.owner.displayName ?? playlist.owner.username}',
              meta:
                  '${playlist.trackCount} tracks${playlist.type.trim().isEmpty ? '' : ' · ${playlist.type}'}',
              trailingIcon: Icons.playlist_play_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _BrowseSection extends StatelessWidget {
  const _BrowseSection({
    required this.selectedGenre,
    required this.genreStationAsync,
    required this.onGenreSelected,
  });

  final String selectedGenre;
  final AsyncValue<PaginatedDiscoveryTracks> genreStationAsync;
  final ValueChanged<String> onGenreSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Browse categories', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.paddingMd),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 600
                ? 3
                : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppDimensions.paddingMd,
                crossAxisSpacing: AppDimensions.paddingMd,
                childAspectRatio: 2.0,
              ),
              itemCount: discoveryGenreOptions.length,
              itemBuilder: (BuildContext context, int index) {
                final genre = discoveryGenreOptions[index];
                return GenreTile(
                  label: genre.label,
                  gradientColors: genre.colors,
                  onTap: () => onGenreSelected(genre.label),
                );
              },
            );
          },
        ),
        const SizedBox(height: AppDimensions.paddingXl),
        _SearchSectionTitle('$selectedGenre station'),
        const SizedBox(height: AppDimensions.paddingSm),
        Text(
          'A genre-led stream inspired by the SoundCloud station flow.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        genreStationAsync.when(
          data: (PaginatedDiscoveryTracks tracks) {
            if (tracks.content.isEmpty) {
              return const _SearchMessageCard(
                message: 'This station is quiet right now. Try another genre.',
              );
            }

            return Column(
              children: tracks.content
                  .map(
                    (DiscoveryTrack track) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingSm,
                      ),
                      child: _SearchSurface(
                        onTap: () => context.push(
                          RoutePaths.trackPreview(track.id),
                        ),
                        leading: _ArtworkSquare(
                          imageUrl: track.coverUrl,
                          icon: Icons.music_note,
                          colors: _colorsForGenre(track.genre),
                        ),
                        title: track.title,
                        subtitle:
                            '${track.artist.displayName ?? track.artist.username} • ${track.genre ?? selectedGenre}',
                        meta:
                            '${_formatCount(track.playCount)} plays · ${_formatCount(track.likeCount)} likes',
                        trailingIcon: Icons.graphic_eq_rounded,
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLg),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (Object error, StackTrace stackTrace) {
            return _SearchMessageCard(
              message: error.toString().replaceFirst('Exception: ', ''),
              isError: true,
            );
          },
        ),
      ],
    );
  }
}

class _SearchSectionTitle extends StatelessWidget {
  const _SearchSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.sectionTitle);
  }
}

class _SearchSurface extends StatelessWidget {
  const _SearchSurface({
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.trailingIcon,
  });

  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final String meta;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: AppDimensions.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meta,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSm),
              Icon(trailingIcon, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtworkSquare extends StatelessWidget {
  const _ArtworkSquare({
    required this.imageUrl,
    required this.icon,
    required this.colors,
  });

  final String? imageUrl;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Center(
        child: Icon(icon, color: AppColors.textPrimary.withValues(alpha: 0.6)),
      ),
    );

    return SizedBox(
      width: 64,
      height: 64,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: imageUrl != null && imageUrl!.trim().isNotEmpty
            ? DecibelCachedImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: placeholder,
                errorWidget: placeholder,
              )
            : placeholder,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final DiscoveryUser user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: user.avatarUrl != null && user.avatarUrl!.trim().isNotEmpty
          ? DecibelCachedImage(
              imageUrl: user.avatarUrl!,
              shape: BoxShape.circle,
              placeholder: const CircleAvatar(
                backgroundColor: AppColors.surfaceVariant,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
              errorWidget: const CircleAvatar(
                backgroundColor: AppColors.surfaceVariant,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
            )
          : CircleAvatar(
              backgroundColor: AppColors.surfaceVariant,
              child: Text(
                _initialsForUser(user),
                style: AppTextStyles.cardTitle,
              ),
            ),
    );
  }
}

class _SearchMessageCard extends StatelessWidget {
  const _SearchMessageCard({
    required this.message,
    this.isError = false,
  });

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
          width: 0.7,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isError ? Icons.error_outline : Icons.search_off_rounded,
            color: isError ? AppColors.errors : AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.paddingMd),
          Expanded(
            child: Text(message, style: AppTextStyles.bodyMedium),
          ),
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
    final formattedValue =
        (value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1);
    return '${formattedValue}K';
  }
  return value.toString();
}

String _initialsForUser(DiscoveryUser user) {
  final value = user.displayName ?? user.username;
  if (value.trim().isEmpty) {
    return '?';
  }

  return value.trim().substring(0, 1).toUpperCase();
}

Playlist _toPlaylistEntity(DiscoveryPlaylist playlist) {
  return Playlist(
    id: playlist.id,
    title: playlist.title,
    description: playlist.description,
    type: playlist.type,
    isPrivate: playlist.isPrivate,
    isLiked: playlist.isLiked,
    coverArt: playlist.coverArtUrl,
    owner: PlaylistOwner(
      id: playlist.owner.id,
      username: playlist.owner.username,
      displayName: playlist.owner.displayName,
      avatarUrl: playlist.owner.avatarUrl,
    ),
    tracks: const <Track>[],
    totalDurationSeconds: playlist.totalDurationSeconds,
    trackCount: playlist.trackCount,
    playlistSlug: playlist.playlistSlug,
    createdAt: playlist.createdAt,
  );
}
