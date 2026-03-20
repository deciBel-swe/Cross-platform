import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final waveformExtractionServiceProvider = Provider<WaveformExtractionService>((
  ref,
) {
  return WaveformExtractionService();
});

class WaveformExtractionService {
  Future<List<double>> extractWaveform(
    String path, {
    int noOfSamples = 100,
  }) async {
    if (path.trim().isEmpty) {
      return const <double>[];
    }

    final extractor = WaveformExtractionController();
    try {
      final peaks = await extractor.extractWaveformData(
        path: path,
        noOfSamples: noOfSamples,
      );
      return peaks;
    } catch (error, stackTrace) {
      debugPrint('Waveform extraction failed for "$path": $error');
      debugPrintStack(stackTrace: stackTrace);
      return const <double>[];
    }
  }
}
