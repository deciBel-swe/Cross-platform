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
    required this.tier,
  });

  /// The unique identifier of the user.
  final int id;

  /// The user's display name.
  final String username;

  /// The user's membership tier.
  final UserTier tier;
}
