class CommentFormatters {
  const CommentFormatters._();

  /// Formats seconds as an m:ss timestamp.
  static String formatTimestampFromSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Formats large counts into compact display text.
  static String formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }

    if (number >= 1000) {
      final decimals = number % 1000 == 0 ? 0 : 1;
      return '${(number / 1000).toStringAsFixed(decimals)}K';
    }

    return number.toString();
  }
}
