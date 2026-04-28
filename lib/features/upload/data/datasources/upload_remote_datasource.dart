import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/websocket_client.dart';
import '../../../library/data/models/track_model.dart';
import '../../domain/entities/track_upload_status.dart';
import '../models/track_metadata_model.dart';
import '../models/track_upload_status_model.dart';

@injectable
class UploadRemoteDatasource {
  const UploadRemoteDatasource(this._dioClient, this._wsClient);

  final DioClient _dioClient;
  final WebSocketClient _wsClient;

  Future<TrackModel> uploadTrack(
    File audioFile,
    File? coverImage,
    TrackMetadataModel model,
  ) async {
    debugPrint('==============================');
    debugPrint('[UploadRemoteDatasource] uploadTrack() called');
    debugPrint('[UploadRemoteDatasource] uploadId: ${model.uploadId}');
    debugPrint('[UploadRemoteDatasource] title: ${model.title}');
    debugPrint('[UploadRemoteDatasource] genre: ${model.genre}');
    debugPrint('[UploadRemoteDatasource] audioFile path: ${audioFile.path}');
    debugPrint(
      '[UploadRemoteDatasource] has coverImage: ${coverImage != null}',
    );

    try {
      // Build multipart payload from metadata and normalize keys to backend contract.
      final Map<String, dynamic> dataMap = model.toJson();

      debugPrint('[UploadRemoteDatasource] initial dataMap: $dataMap');

      final waveformRaw = dataMap.remove('waveFormData');
      final tagsRaw = dataMap['tags'];

      if (waveformRaw is List) {
        debugPrint(
          '[UploadRemoteDatasource] waveformRaw count: ${waveformRaw.length}',
        );

        if (waveformRaw.isEmpty) {
          throw const ServerException(
            'Waveform data is empty. Please pick the audio file again.',
          );
        }

        // Backend expects `waveformData` as a stringified numeric array.
        final waveformValues = waveformRaw
            .map((value) => (value as num).toDouble().toStringAsFixed(4))
            .join(',');

        dataMap['waveformData'] = '[$waveformValues]';

        debugPrint(
          '[UploadRemoteDatasource] waveformData payload count=${waveformRaw.length}',
        );
      } else {
        debugPrint(
          '[UploadRemoteDatasource] waveformRaw is not List: $waveformRaw',
        );
      }

      if (tagsRaw is List) {
        debugPrint('[UploadRemoteDatasource] tagsRaw: $tagsRaw');

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

      dataMap['uploadId'] = model.uploadId;

      dataMap.removeWhere((key, value) => value == null);

      debugPrint(
        '[UploadRemoteDatasource] final dataMap keys: ${dataMap.keys}',
      );
      debugPrint(
        '[UploadRemoteDatasource] final uploadId: ${dataMap['uploadId']}',
      );

      final formData = FormData.fromMap(dataMap);

      // 2. Attach the audio file.
      final audioName = audioFile.path.split('/').last;

      debugPrint('[UploadRemoteDatasource] attaching audioFile: $audioName');

      formData.files.add(
        MapEntry(
          'audioFile',
          await MultipartFile.fromFile(audioFile.path, filename: audioName),
        ),
      );

      // 3. Attach the track image if added.
      if (coverImage != null) {
        final imageName = coverImage.path.split('/').last;

        debugPrint('[UploadRemoteDatasource] attaching coverImage: $imageName');

        formData.files.add(
          MapEntry(
            'coverImage',
            await MultipartFile.fromFile(coverImage.path, filename: imageName),
          ),
        );
      }

      debugPrint('[UploadRemoteDatasource] calling POST trackUploadV2');
      debugPrint(
        '[UploadRemoteDatasource] endpoint: ${ApiConstants.trackUploadV2}',
      );

      // Single upload call; waveform processing continues on backend after this.
      final response = await _dioClient.post<dynamic>(
        ApiConstants.trackUploadV2,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: ApiConstants.trackUploadRequestTimeout,
          receiveTimeout: ApiConstants.trackUploadRequestTimeout,
        ),
      );

      debugPrint('[UploadRemoteDatasource] upload response received');
      debugPrint('[UploadRemoteDatasource] statusCode: ${response.statusCode}');
      debugPrint('[UploadRemoteDatasource] response.data: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;

      debugPrint(
        '[UploadRemoteDatasource] response uploadId: ${responseData['uploadId']}',
      );
      debugPrint(
        '[UploadRemoteDatasource] metadata uploadId: ${model.uploadId}',
      );

      final trackModel = _mapUploadResponseToTrackModel(responseData, model);

      debugPrint('[UploadRemoteDatasource] mapped TrackModel');
      debugPrint('[UploadRemoteDatasource] track id: ${trackModel.id}');
      debugPrint('[UploadRemoteDatasource] track title: ${trackModel.title}');
      debugPrint('[UploadRemoteDatasource] track state: ${trackModel.state}');

      return trackModel;
    } on DioException catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('[UploadRemoteDatasource] DioException during upload');
      debugPrint('[UploadRemoteDatasource] message: ${error.message}');
      debugPrint(
        '[UploadRemoteDatasource] statusCode: ${error.response?.statusCode}',
      );
      debugPrint(
        '[UploadRemoteDatasource] response data: ${error.response?.data}',
      );
      debugPrint('[UploadRemoteDatasource] stackTrace: $stackTrace');

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
    } catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('[UploadRemoteDatasource] upload failed unexpectedly');
      debugPrint('[UploadRemoteDatasource] error: $error');
      debugPrint('[UploadRemoteDatasource] stackTrace: $stackTrace');

      throw ServerException('Failed to parse upload response: $error');
    }
  }

  TrackModel _mapUploadResponseToTrackModel(
    Map<String, dynamic> responseData,
    TrackMetadataModel metadata,
  ) {
    debugPrint(
      '[UploadRemoteDatasource] _mapUploadResponseToTrackModel() called',
    );

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

    debugPrint('[UploadRemoteDatasource] normalized response: $normalized');

    return TrackModel.fromJson(normalized);
  }

  Stream<TrackUploadStatus> watchUploadStatus(String uploadId) {
    debugPrint('==============================');
    debugPrint('[UploadRemoteDatasource] watchUploadStatus() called');
    debugPrint('[UploadRemoteDatasource] uploadId: $uploadId');

    final topicEndpoint = ApiConstants.trackUploadStatusTopic(uploadId);

    debugPrint('[UploadRemoteDatasource] topicEndpoint: $topicEndpoint');
    debugPrint('[UploadRemoteDatasource] calling _wsClient.watch()');

    return _wsClient
        .watch(topicEndpoint)
        .map((data) {
          debugPrint('------------------------------');
          debugPrint('[UploadRemoteDatasource] websocket emitted raw data');
          debugPrint('[UploadRemoteDatasource] topicEndpoint: $topicEndpoint');
          debugPrint('[UploadRemoteDatasource] raw data: $data');

          final status = TrackUploadStatusModel.fromJson(data).toEntity();

          debugPrint('[UploadRemoteDatasource] parsed TrackUploadStatus');
          debugPrint('[UploadRemoteDatasource] state: ${status.state}');
          debugPrint(
            '[UploadRemoteDatasource] progress: ${status.progressPercentage}',
          );
          debugPrint('[UploadRemoteDatasource] stepName: ${status.stepName}');
          debugPrint(
            '[UploadRemoteDatasource] errorMessage: ${status.errorMessage}',
          );
          debugPrint(
            '[UploadRemoteDatasource] trackResponse id: ${status.trackResponse?.id}',
          );

          return status;
        })
        .handleError((Object error, StackTrace stackTrace) {
          debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
          debugPrint('[UploadRemoteDatasource] websocket stream error');
          debugPrint('[UploadRemoteDatasource] uploadId: $uploadId');
          debugPrint('[UploadRemoteDatasource] topicEndpoint: $topicEndpoint');
          debugPrint('[UploadRemoteDatasource] error: $error');
          debugPrint('[UploadRemoteDatasource] stackTrace: $stackTrace');
        });
  }

  void cancelUploadStatusSubscription(String uploadId) {
    debugPrint('==============================');
    debugPrint(
      '[UploadRemoteDatasource] cancelUploadStatusSubscription() called',
    );
    debugPrint('[UploadRemoteDatasource] uploadId: $uploadId');

    final topicEndpoint = ApiConstants.trackUploadStatusTopic(uploadId);

    debugPrint('[UploadRemoteDatasource] topicEndpoint: $topicEndpoint');
    debugPrint('[UploadRemoteDatasource] calling _wsClient.disconnect()');

    _wsClient.disconnect(topicEndpoint);

    debugPrint('[UploadRemoteDatasource] disconnect called');
  }
}
