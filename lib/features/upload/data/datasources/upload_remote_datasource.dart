import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/track_metadata_model.dart';

@injectable
class UploadRemoteDatasource {
  const UploadRemoteDatasource(this._dioClient);
  final DioClient _dioClient;

  Future<void> uploadTrack(
    File audioFile,
    File? coverImage,
    TrackMetadataModel model,
  ) async {
    try {
      // 1. prepare json text
      final Map<String, dynamic> dataMap = model.toJson();

      // Clean nulls so to prevent Dio typing "null" string
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

      // 4. Send the single creation request
      await _dioClient.post<dynamic>('/tracks', data: formData);
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Failed to upload track');
    }
  }
}
