/// General formatting utilities for the track.
class Formatters {
  Formatters._();

  /// Formats numbers to display as K or M (e.g., 1500 as 1.5K, 123000 as 123K).
  static String formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  /// Formats a [Duration] to a displayable string like 4:02 or 1:04:02.
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${duration.inMinutes.remainder(60)}:$twoDigitSeconds";
    }
  }
}
