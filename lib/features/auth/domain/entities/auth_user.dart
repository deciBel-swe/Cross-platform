/// Defines the membership tier of an authenticated user.
enum UserTier {
  free('Free'),
  artist('Artist'),
  artistPro('Artist Pro');

  const UserTier(this.label);

  /// A human-readable label for the tier.
  final String label;
}

/// Represents an authenticated user in the domain layer.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    this.displayName,
    required this.tier,
    this.profileUrl,
    this.avatarUrl,
  });

  /// The unique identifier of the user.
  final int id;

  /// The user's unique handle/username.
  final String username;

  /// The user's profile display name returned by backend.
  final String? displayName;

  /// The user's membership tier.
  final UserTier tier;

  /// The user's profile URL.
  final String? profileUrl;

  /// The user's avatar image URL.
  final String? avatarUrl;
}
