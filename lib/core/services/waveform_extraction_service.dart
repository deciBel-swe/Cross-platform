import 'package:audio_waveforms/audio_waveforms.dart';
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
    final extractor = WaveformExtractionController();
    try {
      final peaks = await extractor.extractWaveformData(
        path: path,
        noOfSamples: noOfSamples,
      );
      return peaks;
    } finally {}
  }
}
