import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile_social_links.dart';
import 'package:decibel/features/library_profile/domain/entities/user_profile.dart';
import 'package:decibel/features/library_profile/domain/repositories/profile_repository.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:decibel/features/settings/domain/entities/app_icon_option.dart';
import 'package:decibel/features/settings/domain/entities/blocked_user.dart';
import 'package:decibel/features/settings/domain/entities/conversation.dart';
import 'package:decibel/features/settings/domain/entities/message.dart';
import 'package:decibel/features/settings/domain/entities/notification_settings.dart';
import 'package:decibel/features/settings/domain/entities/paginated_blocked_users.dart';
import 'package:decibel/features/settings/domain/entities/paginated_data.dart';
import 'package:decibel/features/settings/domain/entities/resource_type.dart';
import 'package:decibel/features/settings/domain/entities/social_settings.dart';
import 'package:decibel/features/settings/domain/repositories/app_icon_repository.dart';
import 'package:decibel/features/settings/domain/repositories/blocked_users_repository.dart';
import 'package:decibel/features/settings/domain/repositories/change_email_repository.dart';
import 'package:decibel/features/settings/domain/repositories/i_messaging_repository.dart';
import 'package:decibel/features/settings/domain/repositories/notification_settings_repository.dart';
import 'package:decibel/features/settings/domain/repositories/social_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget settingsTestApp(
  Widget child, {
  List<Override> overrides = const [],
  Size size = const Size(390, 844),
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: child,
      ),
    ),
  );
}

NotificationSettings notificationSettings({
  bool notifyOnFollow = true,
  bool notifyOnLike = true,
  bool notifyOnRepost = true,
  bool notifyOnComment = true,
  bool notifyOnDM = true,
}) {
  return NotificationSettings(
    notifyOnFollow: notifyOnFollow,
    notifyOnLike: notifyOnLike,
    notifyOnRepost: notifyOnRepost,
    notifyOnComment: notifyOnComment,
    notifyOnDM: notifyOnDM,
  );
}

BlockedUser blockedUser({
  int id = 2,
  String username = 'blocked_user',
  String? avatarUrl,
}) {
  return BlockedUser(
    id: id,
    username: username,
    avatarUrl: avatarUrl,
    tier: 'FREE',
    isFollowing: false,
  );
}

Conversation conversation({
  String id = '1_2',
  List<int> participants = const [1, 2],
  String lastMessage = 'hello',
  DateTime? lastTimestamp,
  int unreadCount = 0,
}) {
  return Conversation(
    id: id,
    participants: participants,
    lastMessage: lastMessage,
    lastTimestamp: lastTimestamp ?? DateTime(2026, 1, 1, 12),
    unreadCount: unreadCount,
  );
}

Message message({
  String id = 'm1',
  String? conversationId = '1_2',
  int senderId = 1,
  String content = 'hello',
  DateTime? createdAt,
  bool isRead = false,
}) {
  return Message(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    content: content,
    createdAt: createdAt ?? DateTime(2026, 1, 1, 12),
    isRead: isRead,
  );
}

Track track({
  int id = 10,
  String title = 'Track title',
  String artistName = 'artist',
}) {
  return Track(
    id: id,
    title: title,
    artist: Artist(id: 1, username: artistName, displayName: artistName),
    trackUrl: 'https://example.com/audio.mp3',
    genre: 'Pop',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2026, 1, 1),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2026, 1, 1),
    trackDurationSeconds: 0,
  );
}

Playlist playlist({
  int id = 20,
  String title = 'Playlist title',
  int trackCount = 2,
}) {
  return Playlist(
    id: id,
    title: title,
    type: 'PLAYLIST',
    isPrivate: false,
    isLiked: false,
    owner: const PlaylistOwner(id: 1, username: 'owner'),
    tracks: List<Track>.generate(trackCount, (index) => track(id: index + 1)),
    totalDurationSeconds: 0,
    trackCount: trackCount,
  );
}

UserProfile userProfile({
  int id = 2,
  String email = 'user@example.com',
  String username = 'listener',
  String? displayName = 'Listener',
}) {
  return UserProfile(
    id: id,
    role: 'USER',
    email: email,
    username: username,
    displayName: displayName,
    emailVerified: true,
    tier: UserTier.free,
    profileDetails: const UserProfileDetails(favoriteGenres: []),
    privacySettings: const PrivacySettings(isPrivate: false, showHistory: true),
    stats: const UserStats(followers: 0, following: 0, tracksCount: 0),
  );
}

PaginatedData<T> paginated<T>(
  List<T> content, {
  int pageNumber = 0,
  bool isLast = true,
}) {
  return PaginatedData<T>(
    content: content,
    pageNumber: pageNumber,
    pageSize: 20,
    totalElements: content.length,
    totalPages: isLast ? pageNumber + 1 : pageNumber + 2,
    isLast: isLast,
  );
}

PaginatedBlockedUsers blockedUsersPage(
  List<BlockedUser> users, {
  int pageNumber = 0,
  bool isLast = true,
}) {
  return PaginatedBlockedUsers(
    content: users,
    pageNumber: pageNumber,
    pageSize: 20,
    totalElements: users.length,
    totalPages: isLast ? pageNumber + 1 : pageNumber + 2,
    isLast: isLast,
  );
}

class FakeAppIconRepository implements AppIconRepository {
  FakeAppIconRepository({this.selected = AppIconOption.classic});

  AppIconOption selected;
  final appliedIcons = <AppIconOption>[];
  final savedIcons = <AppIconOption>[];
  Object? setError;

  @override
  Future<void> applyIcon(AppIconOption option) async {
    appliedIcons.add(option);
  }

  @override
  Future<AppIconOption> getSelectedIcon() async => selected;

  @override
  Future<void> setSelectedIcon(AppIconOption option) async {
    if (setError != null) throw setError!;
    savedIcons.add(option);
    selected = option;
  }
}

class FakeBlockedUsersRepository implements BlockedUsersRepository {
  FakeBlockedUsersRepository({Map<int, PaginatedBlockedUsers>? pages})
    : pages =
          pages ??
          {
            0: blockedUsersPage([blockedUser()]),
          };

  final Map<int, PaginatedBlockedUsers> pages;
  final unblockedIds = <int>[];
  Object? loadError;
  Object? unblockError;

  @override
  Future<PaginatedBlockedUsers> getBlockedUsers({
    int page = 0,
    int size = 20,
  }) async {
    if (loadError != null) throw loadError!;
    return pages[page] ?? blockedUsersPage(const [], pageNumber: page);
  }

  @override
  Future<void> unblockUser({required int userId}) async {
    if (unblockError != null) throw unblockError!;
    unblockedIds.add(userId);
  }
}

class FakeChangeEmailRepository implements ChangeEmailRepository {
  String response = 'Email updated';
  Object? error;
  final requestedEmails = <String>[];

  @override
  Future<String> changeEmail({required String newEmail}) async {
    requestedEmails.add(newEmail);
    if (error != null) throw error!;
    return response;
  }
}

class FakeNotificationSettingsRepository
    implements NotificationSettingsRepository {
  FakeNotificationSettingsRepository({
    NotificationSettings? initial,
    this.updateError,
  }) : settings = initial ?? notificationSettings();

  NotificationSettings settings;
  Object? updateError;
  final updates = <NotificationSettings>[];

  @override
  Future<NotificationSettings> getNotificationSettings() async => settings;

  @override
  Future<NotificationSettings> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    updates.add(settings);
    if (updateError != null) throw updateError!;
    this.settings = settings;
    return settings;
  }
}

class FakeSocialSettingsRepository implements SocialSettingsRepository {
  FakeSocialSettingsRepository({
    this.settings = const SocialSettings(isPrivate: false, showHistory: true),
  });

  SocialSettings settings;
  Object? updateError;
  final updates = <SocialSettings>[];

  @override
  Future<SocialSettings> getSocialSettings() async => settings;

  @override
  Future<void> updateSocialSettings(SocialSettings settings) async {
    updates.add(settings);
    if (updateError != null) throw updateError!;
    this.settings = settings;
  }
}

class FakeMessagingRepository implements IMessagingRepository {
  PaginatedData<Conversation> conversationsPage = paginated([conversation()]);
  final messagePages = <int, PaginatedData<Message>>{
    0: paginated([message(senderId: 2)], isLast: true),
  };
  Message sentMessage = message(id: 'sent', content: 'sent');
  String startedConversationId = '1_3';
  Object? conversationsError;
  Object? messagesError;
  Object? sendError;

  final sentContents = <String>[];
  final requestedConversationPages = <int>[];
  final requestedMessagePages = <int>[];

  @override
  Future<PaginatedData<Conversation>> getConversations({
    int page = 0,
    int size = 20,
  }) async {
    requestedConversationPages.add(page);
    if (conversationsError != null) throw conversationsError!;
    return conversationsPage;
  }

  @override
  Future<PaginatedData<Message>> getMessages({
    required String conversationId,
    int page = 0,
    int size = 20,
  }) async {
    requestedMessagePages.add(page);
    if (messagesError != null) throw messagesError!;
    return messagePages[page] ?? paginated<Message>(const [], pageNumber: page);
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    ResourceType? resourceType,
    int? resourceId,
    int? recipientId,
  }) async {
    if (sendError != null) throw sendError!;
    sentContents.add(content);
    return sentMessage;
  }

  @override
  Future<String> startConversation(int targetUserId) async {
    return startedConversationId;
  }
}

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({UserProfile? profile})
    : profile = profile ?? userProfile();

  UserProfile profile;
  Object? publicProfileFailure;

  @override
  Future<Either<Failure, UserProfile>> getPublicProfile(int userId) async {
    if (publicProfileFailure != null) {
      return Left(ServerFailure(publicProfileFailure.toString()));
    }

    return Right(profile);
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async => Right(profile);

  @override
  Future<Either<Failure, bool>> updateImages({
    File? profilePic,
    File? coverPic,
  }) async => const Right(true);

  @override
  Future<Either<Failure, bool>> updateProfile({
    String? displayName,
    String? bio,
    String? city,
    String? country,
    List<String>? favoriteGenres,
    PublicProfileSocialLinks? socialLinks,
  }) async => const Right(true);

  @override
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  ) async => Right(links);
}
