import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../core/constants/api_constants.dart';
import '../../core/storage/secure_storage_service.dart';

@lazySingleton
class StompWebSocketClient {
  StompWebSocketClient(this._secureStorage);
  final SecureStorageService _secureStorage;

  StompClient? _stompClient;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_stompClient != null && _isConnected) return;

    final token = await _secureStorage.getAccessToken();

    // Transform https://decibel.foo/api to wss://decibel.foo/api/ws
    var baseUrl = ApiConstants.baseUrl;
    baseUrl = baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');

    // Keep the /api suffix, because the backend likely exposes /ws under the api boundary
    final wsUrl = '$baseUrl/ws';

    final completer = Completer<void>();

    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (frame) {
          _isConnected = true;
          debugPrint('STOMP connected');
          if (!completer.isCompleted) completer.complete();
        },
        beforeConnect: () async {
          debugPrint('Connecting to STOMP WebSocket at $wsUrl...');
        },
        onWebSocketError: (error) {
          debugPrint('STOMP Error: $error');
        },
        stompConnectHeaders: token != null
            ? {'Authorization': 'Bearer $token'}
            : null,
        webSocketConnectHeaders: token != null
            ? {'Authorization': 'Bearer $token'}
            : null,
      ),
    );

    _stompClient?.activate();
    
    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Warning: STOMP Connection timeout or error: $e');
    }
  }

  /// Subscribe to track processing progress
  StompUnsubscribe? subscribeToUploadProgress(
    String uploadId,
    void Function(double progress, String status) onUpdate,
  ) {
    if (_stompClient == null || !_isConnected) {
      debugPrint(
        'Warning: STOMP client not connected, Cannot subscribe to $uploadId',
      );
      return null;
    }

    final destination = '/topic/track-status/$uploadId';
    return _stompClient!.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = jsonDecode(frame.body!) as Map<String, dynamic>;
            final progress = (data['progressPercent'] as num?) ?? 0.0;
            final status = data['status'] as String? ?? 'PROCESSING';
            onUpdate(progress.toDouble(), status);
          } catch (e) {
            debugPrint('Error parsing STOMP progress message: $e');
          }
        }
      },
    );
  }

  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
    _isConnected = false;
  }
}
