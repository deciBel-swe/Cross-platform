import 'package:flutter_test/flutter_test.dart';

import 'package:decibel/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter', () {
    group('formatCompact', () {
      test('formats numbers under 1000 as-is', () {
        expect(NumberFormatter.formatCompact(0), '0');
        expect(NumberFormatter.formatCompact(1), '1');
        expect(NumberFormatter.formatCompact(99), '99');
        expect(NumberFormatter.formatCompact(999), '999');
      });

      test('formats thousands with K suffix', () {
        expect(NumberFormatter.formatCompact(1000), '1K');
        expect(NumberFormatter.formatCompact(1500), '1.5K');
        expect(NumberFormatter.formatCompact(2000), '2K');
        expect(NumberFormatter.formatCompact(2500), '2.5K');
        expect(NumberFormatter.formatCompact(10000), '10K');
        expect(NumberFormatter.formatCompact(15500), '15.5K');
        expect(NumberFormatter.formatCompact(999999), '999.9K');
      });

      test('formats millions with M suffix', () {
        expect(NumberFormatter.formatCompact(1000000), '1M');
        expect(NumberFormatter.formatCompact(1500000), '1.5M');
        expect(NumberFormatter.formatCompact(2000000), '2M');
        expect(NumberFormatter.formatCompact(2500000), '2.5M');
        expect(NumberFormatter.formatCompact(10000000), '10M');
        expect(NumberFormatter.formatCompact(15500000), '15.5M');
        expect(NumberFormatter.formatCompact(999999999), '999.9M');
      });

      test('handles edge cases', () {
        expect(NumberFormatter.formatCompact(1001), '1K');
        expect(NumberFormatter.formatCompact(1100), '1.1K');
        expect(NumberFormatter.formatCompact(1000001), '1M');
        expect(NumberFormatter.formatCompact(1100000), '1.1M');
      });

      test('rounds decimals to one place', () {
        expect(NumberFormatter.formatCompact(1234), '1.2K');
        expect(NumberFormatter.formatCompact(1567), '1.5K');
        expect(NumberFormatter.formatCompact(1234567), '1.2M');
        expect(NumberFormatter.formatCompact(1567890), '1.5M');
      });

      test('removes decimal when whole number', () {
        expect(NumberFormatter.formatCompact(1000), '1K');
        expect(NumberFormatter.formatCompact(5000), '5K');
        expect(NumberFormatter.formatCompact(1000000), '1M');
        expect(NumberFormatter.formatCompact(5000000), '5M');
      });
    });
  });
}
