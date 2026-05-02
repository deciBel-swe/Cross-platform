import 'dart:io';
import 'dart:typed_data';

import 'package:decibel/core/services/picker_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;
  late PickerService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('picker_service_test_');
    service = PickerService();
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'getAudioDuration reads WAV duration without creating an audio player',
    () async {
      final file = File('${tempDir.path}/sample.wav');
      await file.writeAsBytes(
        _createWaveBytes(duration: const Duration(seconds: 2)),
      );

      final duration = await service.getAudioDuration(file.path);

      expect(duration, const Duration(seconds: 2));
    },
  );

  test(
    'getAudioDuration reads MP3 duration without creating an audio player',
    () async {
      final file = File('${tempDir.path}/sample.mp3');
      await file.writeAsBytes(
        _createMp3Bytes(duration: const Duration(seconds: 2)),
      );

      final duration = await service.getAudioDuration(file.path);

      expect(duration, const Duration(seconds: 2));
    },
  );
}

Uint8List _createWaveBytes({required Duration duration}) {
  const sampleRate = 44100;
  const channels = 1;
  const bitsPerSample = 16;
  const byteRate = sampleRate * channels * bitsPerSample ~/ 8;
  final dataSize = duration.inSeconds * byteRate;
  final bytes = Uint8List(44 + dataSize);
  final data = ByteData.sublistView(bytes);

  _writeAscii(bytes, 0, 'RIFF');
  data.setUint32(4, 36 + dataSize, Endian.little);
  _writeAscii(bytes, 8, 'WAVE');
  _writeAscii(bytes, 12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, channels, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, byteRate, Endian.little);
  data.setUint16(32, channels * bitsPerSample ~/ 8, Endian.little);
  data.setUint16(34, bitsPerSample, Endian.little);
  _writeAscii(bytes, 36, 'data');
  data.setUint32(40, dataSize, Endian.little);

  return bytes;
}

Uint8List _createMp3Bytes({required Duration duration}) {
  const bitrate = 128000;
  final byteLength = duration.inSeconds * bitrate ~/ 8;
  final bytes = Uint8List(byteLength);

  bytes[0] = 0xFF;
  bytes[1] = 0xFB;
  bytes[2] = 0x90;
  bytes[3] = 0x00;

  return bytes;
}

void _writeAscii(Uint8List bytes, int offset, String value) {
  for (var i = 0; i < value.length; i++) {
    bytes[offset + i] = value.codeUnitAt(i);
  }
}
