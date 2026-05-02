/// Builds a one-character avatar fallback from a display name or username.
///
/// Returns `?` when the source value is empty after trimming.
String buildInboxAvatarText(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.substring(0, 1).toUpperCase();
}
