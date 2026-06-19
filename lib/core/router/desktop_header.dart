/// Desktop top header bar with search, upload, notifications, and avatar.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'route_paths.dart';

/// Top header bar rendered above the content area on desktop.
class DesktopHeader extends StatelessWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // ---- Search field ----
          const Expanded(child: _SearchField()),

          const SizedBox(width: AppDimensions.paddingMd),

          // ---- Upload button ----
          _HeaderIconButton(
            icon: Icons.upload_outlined,
            tooltip: 'Upload',
            onPressed: () => context.push(RoutePaths.upload),
          ),

          const SizedBox(width: AppDimensions.paddingXs),

          // ---- Notifications ----
          _HeaderIconButton(
            icon: Icons.notifications_none,
            tooltip: 'Notifications',
            onPressed: () {},
          ),

          const SizedBox(width: AppDimensions.paddingXs),

          // ---- Messages ----
          _HeaderIconButton(
            icon: Icons.mail_outline,
            tooltip: 'Messages',
            onPressed: () => context.go(RoutePaths.messages),
          ),

          const SizedBox(width: AppDimensions.paddingSm),

          // ---- User avatar ----
          const _UserAvatar(),
        ],
      ),
    );
  }
}

/// Styled search input field.
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return const _DesktopSearchField();
  }
}

class _DesktopSearchField extends StatefulWidget {
  const _DesktopSearchField();

  @override
  State<_DesktopSearchField> createState() => _DesktopSearchFieldState();
}

class _DesktopSearchFieldState extends State<_DesktopSearchField> {
  late final TextEditingController _controller;
  String? _lastSyncedQuery;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final routeQuery = GoRouterState.of(
      context,
    ).uri.queryParameters['q']?.trim();
    if (_lastSyncedQuery == routeQuery) {
      return;
    }

    _lastSyncedQuery = routeQuery;
    final text = routeQuery ?? '';
    if (_controller.text != text) {
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _controller,
          onSubmitted: _submitSearch,
          onTap: () {
            if (GoRouterState.of(context).uri.path != RoutePaths.search) {
              _submitSearch(_controller.text);
            }
          },
          style: const TextStyle(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for artists, tracks, playlists...',
            hintStyle: const TextStyle(fontSize: 13, color: Colors.white38),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: Colors.white38,
            ),
            suffixIcon: _controller.text.trim().isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      _submitSearch('');
                      setState(() {});
                    },
                    icon: const Icon(Icons.close, size: 18),
                    color: Colors.white38,
                  )
                : null,
            filled: true,
            fillColor: AppColors.surfaceLight,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  void _submitSearch(String value) {
    final query = value.trim();
    final route = Uri(
      path: RoutePaths.search,
      queryParameters: query.isEmpty ? null : <String, String>{'q': query},
    ).toString();

    context.go(route);
  }
}

/// Icon button used in the header bar.
class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Tooltip(
          message: widget.tooltip,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.surfaceLight : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(
                widget.icon,
                size: 22,
                color: _isHovered ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder circular user avatar.
class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'Account',
      offset: const Offset(0, 40),
      color: AppColors.surfaceVariant,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: const BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
      onSelected: (value) {
        switch (value) {
          case _UserMenuAction.profile:
            context.push(RoutePaths.profile);
          case _UserMenuAction.settings:
            context.push(RoutePaths.settings);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.profile,
          child: _UserMenuItemLabel(
            icon: Icons.person_outline,
            text: 'Profile',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.settings,
          child: _UserMenuItemLabel(
            icon: Icons.settings_outlined,
            text: 'Settings',
          ),
        ),
      ],
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.surfaceLight,
        child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}

class _UserMenuItemLabel extends StatelessWidget {
  const _UserMenuItemLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: AppDimensions.paddingSm),
        Text(text, style: const TextStyle(color: AppColors.textPrimary)),
      ],
    );
  }
}

enum _UserMenuAction { profile, settings }
