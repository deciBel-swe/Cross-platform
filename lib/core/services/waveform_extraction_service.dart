import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

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
    if (path.trim().isEmpty) return const <double>[];

    final completer = Completer<List<double>>();

    _serial = _serial.whenComplete(() async {
      try {
        final file = File(path);
        if (!await file.exists()) {
          if (!completer.isCompleted) completer.complete(const <double>[]);
          return;
        }

        List<double> result = [];

        if (Platform.isWindows) {
          result = await _extractForWindows(path, noOfSamples);
        } else {
          try {
            final extractor = WaveformExtractionController();
            result = await extractor.extractWaveformData(
              path: path,
              noOfSamples: noOfSamples,
            );
          } catch (e) {
            debugPrint('WaveformService mobile extractor error: $e');
          }
        }

        // Apply noise floor to avoid absolute silence
        const double noiseFloor = 0.02;
        result = result.map((sample) {
          if (sample.abs() < noiseFloor) {
            return noiseFloor;
          }
          return sample;
        }).toList();

        const epsilon = 1e-6;
        final isFlat =
            result.isNotEmpty && result.every((e) => e.abs() < epsilon);

        if (!completer.isCompleted) {
          completer.complete(
            (result.isNotEmpty && !isFlat) ? result : const [],
          );
        }
      } catch (e, stack) {
        debugPrint('WaveformService Failure: $e\n$stack');
        if (!completer.isCompleted) {
          completer.complete(const <double>[]);
        }
      }
    });

    return completer.future;
  }

  Future<List<double>> _extractForWindows(String path, int noOfSamples) async {
    try {
      final soloud = SoLoud.instance;

      if (!soloud.isInitialized) {
        await soloud.init();
      }
      // ignore: experimental_member_use
      final audioData = await soloud.readSamplesFromFile(
        path,
        noOfSamples,
        average: true,
      );

      return audioData.map((e) => e.abs().toDouble()).toList();
    } catch (e, stack) {
      debugPrint('Windows SoLoud Error: $e\n$stack');
      return const [];
    }
  }
}
