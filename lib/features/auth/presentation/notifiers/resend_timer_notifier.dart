import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResendTimerNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void startTimer({int? seconds}) {
    if (state > 0) return;
    state = seconds ?? 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state <= 0) {
        state = 0;
        t.cancel();
      } else {
        state = state - 1;
      }
    });
  }
}
