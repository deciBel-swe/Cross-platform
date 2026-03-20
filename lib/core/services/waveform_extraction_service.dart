import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final waveformExtractionServiceProvider = Provider<WaveformExtractionService>((
  ref,
) {
  return WaveformExtractionService();
});

class WaveformExtractionService {
  Future<void> _serial = Future.value();

  Future<List<double>> extractWaveform(
    String path, {
    int noOfSamples = 100,
  }) async {
    if (path.trim().isEmpty) {
      return const <double>[];
    }

    // Chain this request to the end of the previous one
    final completer = Completer<List<double>>();

    _serial = _serial.whenComplete(() async {
      try {
        final file = File(path);
        if (!await file.exists()) {
          if (!completer.isCompleted) completer.complete(const <double>[]);
          return;
        }

        List<double> result = [];
        try {
          final extractor = WaveformExtractionController();
          result = await extractor.extractWaveformData(
            path: path,
            noOfSamples: 150,
          );
        } catch (e) {
          debugPrint('WaveformService extractor error: $e');
        }

        bool isFlat = result.isNotEmpty && result.every((e) => e == 0.0);

        if (result.isNotEmpty && !isFlat) {
          if (!completer.isCompleted) completer.complete(result);
          return;
        }

        if (!completer.isCompleted) completer.complete(const <double>[]);
      } catch (e, stack) {
        debugPrint('WaveformService Failure for "$path": $e');
        debugPrintStack(stackTrace: stack);
        if (!completer.isCompleted) completer.complete(const <double>[]);
      }
    });

    return completer.future;
  }
}
