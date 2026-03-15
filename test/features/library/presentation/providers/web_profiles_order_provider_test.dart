import 'package:flutter_test/flutter_test.dart';
import 'package:decibel/features/library/presentation/providers/web_profiles_order_provider.dart';

void main() {
  group('WebProfilesOrderNotifier', () {
    late WebProfilesOrderNotifier notifier;

    setUp(() {
      notifier = WebProfilesOrderNotifier();
    });

    test('initial state is empty', () {
      expect(notifier.state, isEmpty);
    });

    test('addPlatformIfMissing adds platform', () {
      notifier.addPlatformIfMissing('instagram');

      expect(notifier.state, ['instagram']);
    });

    test('addPlatformIfMissing does not duplicate platform', () {
      notifier.addPlatformIfMissing('instagram');
      notifier.addPlatformIfMissing('instagram');

      expect(notifier.state, ['instagram']);
    });

    test('removePlatform removes only that platform', () {
      notifier.addPlatformIfMissing('instagram');
      notifier.addPlatformIfMissing('youtube');
      notifier.addPlatformIfMissing('website');

      notifier.removePlatform('youtube');

      expect(notifier.state, ['instagram', 'website']);
    });

    test('reorder changes order correctly', () {
      notifier.addPlatformIfMissing('instagram');
      notifier.addPlatformIfMissing('youtube');
      notifier.addPlatformIfMissing('website');

      notifier.reorder(0, 2);

      expect(notifier.state, ['youtube', 'instagram', 'website']);
    });

    test('reorder later item to earlier position works', () {
      notifier.addPlatformIfMissing('instagram');
      notifier.addPlatformIfMissing('youtube');
      notifier.addPlatformIfMissing('website');

      notifier.reorder(2, 0);

      expect(notifier.state, ['website', 'instagram', 'youtube']);
    });
  });
}