/// Utility for formatting numbers with K/M suffixes to prevent UI overflow.
class NumberFormatter {
  NumberFormatter._();

  /// Formats a number with K/M suffix for compact display.
  ///
  /// Examples:
  /// - 0 -> '0'
  /// - 999 -> '999'
  /// - 1000 -> '1K'
  /// - 1500 -> '1.5K'
  /// - 1000000 -> '1M'
  /// - 1500000 -> '1.5M'
  static String formatCompact(int number) {
    if (number >= 1000000) {
      final millions = number / 1000000;
      return millions % 1 == 0
          ? '${millions.toInt()}M'
          : '${millions.toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      final thousands = number / 1000;
      return thousands % 1 == 0
          ? '${thousands.toInt()}K'
          : '${thousands.toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
