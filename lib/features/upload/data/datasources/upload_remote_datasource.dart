import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../library/data/models/track_model.dart';
import '../models/track_metadata_model.dart';

@injectable
class UploadRemoteDatasource {
  const UploadRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  Future<TrackModel> uploadTrack(
    File audioFile,
    File? coverImage,
    TrackMetadataModel model,
  ) async {
    try {
      // Build multipart payload from metadata and normalize keys to backend contract.
      final Map<String, dynamic> dataMap = model.toJson();

      final waveformRaw = dataMap.remove('waveFormData');
      final tagsRaw = dataMap['tags'];

      if (waveformRaw is List) {
        // Backend expects `waveformData` as a stringified numeric array.
        final waveformValues = waveformRaw
            .map((value) => (value as num).toDouble().toStringAsFixed(4))
            .join(',');
        dataMap['waveformData'] = '[$waveformValues]';
        debugPrint(
          'WaveformDebug upload payload (count=${waveformRaw.length}): ${dataMap['waveformData']}',
        );
      }

      if (tagsRaw is List) {
        // Backend expects tags in JSON-array string form in multipart fields.
        final tagsValues = tagsRaw
            .map((value) => '"${value.toString()}"')
            .join(',');
        dataMap['tags'] = '[$tagsValues]';
      }

      if (dataMap['isPrivate'] is bool) {
        // Keep privacy value parser-friendly for multipart processing on backend.
        dataMap['isPrivate'] = (dataMap['isPrivate'] as bool).toString();
      }

      dataMap.removeWhere((key, value) => value == null);
      final formData = FormData.fromMap(dataMap);

      // 2. Attach the Audio file
      final audioName = audioFile.path.split('/').last;
      formData.files.add(
        MapEntry(
          'audioFile',
          await MultipartFile.fromFile(audioFile.path, filename: audioName),
        ),
      );

      // 3. Attach the track image if added
      if (coverImage != null) {
        final imageName = coverImage.path.split('/').last;
        formData.files.add(
          MapEntry(
            'coverImage',
            await MultipartFile.fromFile(coverImage.path, filename: imageName),
          ),
        );
      }

      // Single upload call; waveform processing continues on backend after this.
      final response = await _dioClient.post<dynamic>(
        '/tracks/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final responseData = response.data as Map<String, dynamic>;
      return _mapUploadResponseToTrackModel(responseData, model);
    } on DioException catch (error) {
      final responseData = error.response?.data;
      String? backendMessage;
      if (responseData is Map<String, dynamic>) {
        backendMessage = responseData['message'] as String?;
        final errors = responseData['errors'];
        if (errors is List && errors.isNotEmpty) {
          final details = errors.map((e) => e.toString()).join(', ');
          backendMessage = backendMessage == null
              ? details
              : '$backendMessage: $details';
        }
      }
      throw ServerException(
        backendMessage ?? error.message ?? 'Failed to upload track',
      );
    } catch (error) {
      throw ServerException('Failed to parse upload response: $error');
    }
  }

  TrackModel _mapUploadResponseToTrackModel(
    Map<String, dynamic> responseData,
    TrackMetadataModel metadata,
  ) {
    // Normalize minimal upload response into full track shape used by app models.
    final nowIso = DateTime.now().toIso8601String();
    final releaseDateIso =
        DateTime.tryParse(metadata.releaseDate)?.toIso8601String() ?? nowIso;

    final normalized = <String, dynamic>{
      ...responseData,
      'artist': responseData['artist'] ?? {'id': 0, 'username': 'You'},
      'genre': responseData['genre'] ?? metadata.genre,
      'tags': responseData['tags'] ?? metadata.tags,
      'state': responseData['state'] ?? 'PROCESSING',
      'releaseDate': responseData['releaseDate'] ?? releaseDateIso,
      'createdAt': responseData['createdAt'] ?? nowIso,
      'playCount': responseData['playCount'] ?? 0,
      'likeCount': responseData['likeCount'] ?? 0,
      'repostCount': responseData['repostCount'] ?? 0,
    };

    return TrackModel.fromJson(normalized);
  }
}
