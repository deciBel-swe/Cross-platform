import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../library_profile/presentation/screens/public_profile_screen.dart';
import '../providers/messaging_providers.dart';

class MessageBubbleSenderAvatar extends ConsumerStatefulWidget {
  const MessageBubbleSenderAvatar({super.key, required this.otherUserId});

  final int? otherUserId;

  @override
  ConsumerState<MessageBubbleSenderAvatar> createState() =>
      _MessageBubbleSenderAvatarState();
}

class _MessageBubbleSenderAvatarState
    extends ConsumerState<MessageBubbleSenderAvatar> {
  bool _isOpening = false;

  @override
  Widget build(BuildContext context) {
    final userId = widget.otherUserId;

    if (userId == null) {
      return const _FallbackUserAvatar();
    }

    final profileAsync = ref.watch(messageUserProfileProvider(userId));

    return profileAsync.when(
      data: (profile) {
        final username = profile.username.trim();
        final displayName = profile.displayName?.trim();

        final profileIdentifier = username.isNotEmpty
            ? username
            : userId.toString();

        final labelName = displayName != null && displayName.isNotEmpty
            ? displayName
            : username.isNotEmpty
            ? username
            : 'User $userId';

        return Semantics(
          button: true,
          label: 'Open profile of $labelName',
          child: GestureDetector(
            onTap: () => _openProfile(context, profileIdentifier),
            child: const _FallbackUserAvatar(),
          ),
        );
      },
      loading: () => const _FallbackUserAvatar(),
      error: (_, _) {
        return Semantics(
          button: true,
          label: 'Open user profile',
          child: GestureDetector(
            onTap: () => _openProfile(context, userId.toString()),
            child: const _FallbackUserAvatar(),
          ),
        );
      },
    );
  }

  Future<void> _openProfile(BuildContext context, String identifier) async {
    if (_isOpening) return;

    setState(() => _isOpening = true);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => PublicProfileScreen(userIdentifier: identifier),
      ),
    );

    if (mounted) {
      setState(() => _isOpening = false);
    }
  }
}

class _FallbackUserAvatar extends StatelessWidget {
  const _FallbackUserAvatar();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.surface,
        child: Icon(Icons.person, color: Colors.white54, size: 18),
      ),
    );
  }
}
