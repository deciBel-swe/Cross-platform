import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

/// A [ChangeNotifier] that triggers when the auth state changes.
/// Used to hook GoRouter's refreshListenable to Riverpod.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    _subscription = ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
