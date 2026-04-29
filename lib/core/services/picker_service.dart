import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

abstract class IPickerService {
  Future<File?> pickAudioFile();
  Future<File?> pickCoverImage();

  Future<Duration?> getAudioDuration(String filePath);
}

class PickerService implements IPickerService {
  bool _isAudioPickerActive = false;

  @override
  Future<File?> pickAudioFile() async {
    if (_isAudioPickerActive) return null;
    _isAudioPickerActive = true;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      // Print the error so you know exactly why it failed
      debugPrint('Error picking audio file: $e');
      return null;
    } finally {
      _isAudioPickerActive = false;
    }
  }

  @override
  Future<File?> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  @override
  Future<Duration?> getAudioDuration(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.openRead().fold<BytesBuilder>(
        BytesBuilder(copy: false),
        (builder, chunk) => builder..add(chunk),
      );
      return _AudioDurationParser(bytes.takeBytes()).parse();
    } catch (e) {
      debugPrint('Error getting audio duration: $e');
      return null;
    }
  }
}

// Provide it to Riverpod
final pickerServiceProvider = Provider<IPickerService>(
  (ref) => PickerService(),
);

class _AudioDurationParser {
  const _AudioDurationParser(this.bytes);

  final Uint8List bytes;

  Duration? parse() {
    if (bytes.length < 12) {
      return null;
    }

    if (_matches(0, 'RIFF') && _matches(8, 'WAVE')) {
      return _parseWave();
    }

    return _parseMp3();
  }

  Duration? _parseWave() {
    var offset = 12;
    int? byteRate;
    int? dataSize;

    while (offset + 8 <= bytes.length) {
      final chunkId = _readAscii(offset, 4);
      final chunkSize = _readUint32LE(offset + 4);
      final chunkDataOffset = offset + 8;

      if (chunkDataOffset + chunkSize > bytes.length) {
        return null;
      }

      if (chunkId == 'fmt ' && chunkSize >= 16) {
        byteRate = _readUint32LE(chunkDataOffset + 8);
      } else if (chunkId == 'data') {
        dataSize = chunkSize;
      }

      if (byteRate != null && dataSize != null) {
        if (byteRate <= 0) {
          return null;
        }
        return _secondsToDuration(dataSize / byteRate);
      }

      offset = chunkDataOffset + chunkSize + chunkSize.remainder(2);
    }

    return null;
  }

  Duration? _parseMp3() {
    var searchOffset = _id3v2TagLength();

    while (searchOffset + 4 <= bytes.length) {
      final header = _readUint32BE(searchOffset);
      final frame = _Mp3FrameHeader.tryParse(header);

      if (frame == null) {
        searchOffset += 1;
        continue;
      }

      final vbrDuration = _parseVbrDuration(searchOffset, frame);
      if (vbrDuration != null) {
        return vbrDuration;
      }

      final audioBytes = bytes.length - searchOffset - _id3v1TagLength();
      if (audioBytes <= 0 || frame.bitrate <= 0) {
        return null;
      }

      return _secondsToDuration((audioBytes * 8) / frame.bitrate);
    }

    return null;
  }

  Duration? _parseVbrDuration(int frameOffset, _Mp3FrameHeader frame) {
    final xingOffset = frameOffset + 4 + frame.xingSideInfoLength;
    if (xingOffset + 16 <= bytes.length &&
        (_matches(xingOffset, 'Xing') || _matches(xingOffset, 'Info'))) {
      final flags = _readUint32BE(xingOffset + 4);
      final hasFrameCount = (flags & 0x0001) != 0;
      if (hasFrameCount) {
        final frameCount = _readUint32BE(xingOffset + 8);
        if (frameCount > 0) {
          return _secondsToDuration(
            frameCount * frame.samplesPerFrame / frame.sampleRate,
          );
        }
      }
    }

    final vbriOffset = frameOffset + 4 + 32;
    if (vbriOffset + 18 <= bytes.length && _matches(vbriOffset, 'VBRI')) {
      final frameCount = _readUint32BE(vbriOffset + 14);
      if (frameCount > 0) {
        return _secondsToDuration(
          frameCount * frame.samplesPerFrame / frame.sampleRate,
        );
      }
    }

    return null;
  }

  int _id3v2TagLength() {
    if (bytes.length < 10 || !_matches(0, 'ID3')) {
      return 0;
    }

    final size =
        ((bytes[6] & 0x7F) << 21) |
        ((bytes[7] & 0x7F) << 14) |
        ((bytes[8] & 0x7F) << 7) |
        (bytes[9] & 0x7F);
    final hasFooter = (bytes[5] & 0x10) != 0;
    return 10 + size + (hasFooter ? 10 : 0);
  }

  int _id3v1TagLength() {
    if (bytes.length < 128) {
      return 0;
    }

    return _matches(bytes.length - 128, 'TAG') ? 128 : 0;
  }

  bool _matches(int offset, String value) {
    if (offset < 0 || offset + value.length > bytes.length) {
      return false;
    }

    for (var i = 0; i < value.length; i++) {
      if (bytes[offset + i] != value.codeUnitAt(i)) {
        return false;
      }
    }

    return true;
  }

  String _readAscii(int offset, int length) {
    return String.fromCharCodes(bytes.sublist(offset, offset + length));
  }

  int _readUint32LE(int offset) {
    return ByteData.sublistView(
      bytes,
      offset,
      offset + 4,
    ).getUint32(0, Endian.little);
  }

  int _readUint32BE(int offset) {
    return ByteData.sublistView(
      bytes,
      offset,
      offset + 4,
    ).getUint32(0, Endian.big);
  }

  Duration _secondsToDuration(double seconds) {
    return Duration(milliseconds: (seconds * 1000).round());
  }
}

class _Mp3FrameHeader {
  const _Mp3FrameHeader({
    required this.version,
    required this.layer,
    required this.bitrate,
    required this.sampleRate,
    required this.channelMode,
  });

  final int version;
  final int layer;
  final int bitrate;
  final int sampleRate;
  final int channelMode;

  int get samplesPerFrame {
    if (layer == 3) {
      return 384;
    }
    if (layer == 2) {
      return 1152;
    }
    return version == 3 ? 1152 : 576;
  }

  int get xingSideInfoLength {
    final isMono = channelMode == 3;
    if (layer != 1) {
      return 0;
    }
    if (version == 3) {
      return isMono ? 17 : 32;
    }
    return isMono ? 9 : 17;
  }

  static _Mp3FrameHeader? tryParse(int header) {
    if ((header & 0xFFE00000) != 0xFFE00000) {
      return null;
    }

    final version = (header >> 19) & 0x03;
    final layer = (header >> 17) & 0x03;
    final bitrateIndex = (header >> 12) & 0x0F;
    final sampleRateIndex = (header >> 10) & 0x03;
    final channelMode = (header >> 6) & 0x03;

    if (version == 1 ||
        layer == 0 ||
        bitrateIndex == 0 ||
        bitrateIndex == 15 ||
        sampleRateIndex == 3) {
      return null;
    }

    final bitrate = _bitrate(version, layer, bitrateIndex);
    final sampleRate = _sampleRate(version, sampleRateIndex);

    if (bitrate == null || sampleRate == null) {
      return null;
    }

    return _Mp3FrameHeader(
      version: version,
      layer: layer,
      bitrate: bitrate,
      sampleRate: sampleRate,
      channelMode: channelMode,
    );
  }

  static int? _bitrate(int version, int layer, int index) {
    const mpeg1Layer1 = [
      0,
      32,
      64,
      96,
      128,
      160,
      192,
      224,
      256,
      288,
      320,
      352,
      384,
      416,
      448,
    ];
    const mpeg1Layer2 = [
      0,
      32,
      48,
      56,
      64,
      80,
      96,
      112,
      128,
      160,
      192,
      224,
      256,
      320,
      384,
    ];
    const mpeg1Layer3 = [
      0,
      32,
      40,
      48,
      56,
      64,
      80,
      96,
      112,
      128,
      160,
      192,
      224,
      256,
      320,
    ];
    const mpeg2Layer1 = [
      0,
      32,
      48,
      56,
      64,
      80,
      96,
      112,
      128,
      144,
      160,
      176,
      192,
      224,
      256,
    ];
    const mpeg2Layer2And3 = [
      0,
      8,
      16,
      24,
      32,
      40,
      48,
      56,
      64,
      80,
      96,
      112,
      128,
      144,
      160,
    ];

    final table = switch ((version, layer)) {
      (3, 3) => mpeg1Layer1,
      (3, 2) => mpeg1Layer2,
      (3, 1) => mpeg1Layer3,
      (_, 3) => mpeg2Layer1,
      (_, 2) || (_, 1) => mpeg2Layer2And3,
      _ => null,
    };

    final kilobits = table?[index];
    return kilobits == null ? null : kilobits * 1000;
  }

  static int? _sampleRate(int version, int index) {
    const mpeg1 = [44100, 48000, 32000];
    const mpeg2 = [22050, 24000, 16000];
    const mpeg25 = [11025, 12000, 8000];

    final table = switch (version) {
      3 => mpeg1,
      2 => mpeg2,
      0 => mpeg25,
      _ => null,
    };

    return table?[index];
  }
}
