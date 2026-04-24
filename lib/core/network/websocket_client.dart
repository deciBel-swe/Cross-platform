import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

@lazySingleton
class WebSocketClient {
  WebSocketClient(this._secureStorage);

  final SecureStorageService _secureStorage;

  StompClient? _stompClient;
  bool _isConnected = false;
  bool _isConnecting = false;

  // Keep track of streams using the topic endpoint as the key
  final Map<String, StreamController<Map<String, dynamic>>> _controllers = {};

  // Stores the unsubscribe callbacks provided by the STOMP client
  final Map<String, Function> _unsubscribeFunctions = {};

  /// Returns a stream for a specific STOMP topic, connecting to the hub if needed.
  Stream<Map<String, dynamic>> watch(String topicEndpoint) {
    if (!_controllers.containsKey(topicEndpoint)) {
      // 1. Create a stream controller for this specific track's UI to listen to
      _controllers[topicEndpoint] =
          StreamController<Map<String, dynamic>>.broadcast();
    }

    // 2. If already connected to the STOMP hub, subscribe instantly.
    if (_isConnected && _stompClient?.connected == true) {
      if (!_unsubscribeFunctions.containsKey(topicEndpoint)) {
        _subscribeToTopic(topicEndpoint);
      }
    } else {
      // 3. Otherwise, boot up or restore the main connection first.
      _connect();
    }

    return _controllers[topicEndpoint]!.stream;
  }

  Future<void> _connect() async {
    if (_isConnecting) return;
    if (_stompClient?.connected == true && _isConnected) return;

    if (_stompClient != null && _stompClient!.connected == false) {
      _stompClient!.deactivate();
      _stompClient = null;
      _unsubscribeFunctions.clear();
    }

    _isConnecting = true;

    try {
      final token = await _secureStorage.getAccessToken();

      // I am assuming '/ws' here, which is the Spring Boot default.
      final String stompHubUrl = '${ApiConstants.wsBaseUrl}/ws?token=$token';

      _stompClient = StompClient(
        config: StompConfig(
          url: stompHubUrl,
          onConnect: _onConnect,
          beforeConnect: () async {
            if (kDebugMode) {
              debugPrint(
                'STOMP: Booting up main connection to $stompHubUrl...',
              );
            }
          },
          onWebSocketError: (error) {
            _isConnecting = false;
            debugPrint('STOMP WebSocket Error: $error');
            _broadcastError(error as Object);
          },
          onStompError: (StompFrame frame) {
            debugPrint('STOMP Protocol Error: ${frame.body}');
            _broadcastError(frame.body ?? 'STOMP Protocol Error');
          },
          onDisconnect: (StompFrame frame) {
            debugPrint('STOMP: Main Hub Disconnected');
            _isConnected = false;
            _isConnecting = false;
            _unsubscribeFunctions.clear();
          },
          // Spring Boot often expects the token in the CONNECT frame headers as well
          stompConnectHeaders: {'Authorization': 'Bearer $token'},
          webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
          reconnectDelay: const Duration(seconds: 5),
        ),
      );

      _stompClient!.activate();
    } catch (e) {
      _isConnecting = false;
      debugPrint('STOMP setup failed: $e');
    }
  }

  void _onConnect(StompFrame frame) {
    debugPrint('STOMP: Connected to Main Hub Successfully!');
    _isConnected = true;
    _isConnecting = false;

    // Use a tiny delay to let the socket settle, but verify it's still alive afterward!
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_stompClient != null && _stompClient!.connected) {
        for (final topic in _controllers.keys) {
          if (!_unsubscribeFunctions.containsKey(topic)) {
            _subscribeToTopic(topic);
          }
        }
      } else {
        debugPrint('STOMP: Connection dropped before we could subscribe!');
      }
    });
  }

  void _subscribeToTopic(String topicEndpoint) {
    // strict !_stompClient!.connected safety check!
    if (_stompClient == null || !_isConnected || !_stompClient!.connected) {
      debugPrint(
        'STOMP: Aborting subscription to $topicEndpoint. Socket is dead.',
      );
      return;
    }

    debugPrint('STOMP: Subscribing to $topicEndpoint');

    _unsubscribeFunctions[topicEndpoint] = _stompClient!.subscribe(
      destination: topicEndpoint,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          try {
            final decoded = jsonDecode(frame.body!) as Map<String, dynamic>;
            _controllers[topicEndpoint]?.add(decoded);
          } catch (e) {
            debugPrint('STOMP JSON decode error on $topicEndpoint: $e');
          }
        }
      },
    );
  }

  void _broadcastError(Object error) {
    for (final controller in _controllers.values) {
      controller.addError(error);
    }
  }

  /// Unsubscribes from a specific topic without closing the main Hub connection
  void disconnect(String topicEndpoint) {
    // 1. Send the STOMP 'UNSUBSCRIBE' frame to the server
    if (_unsubscribeFunctions.containsKey(topicEndpoint)) {
      final unsubscribeFn = _unsubscribeFunctions[topicEndpoint]!;
      unsubscribeFn(); // Execute the un-sub callback
      _unsubscribeFunctions.remove(topicEndpoint);
      debugPrint('STOMP: Unsubscribed from $topicEndpoint');
    }

    // 2. Close the Riverpod stream for this track
    _controllers[topicEndpoint]?.close();
    _controllers.remove(topicEndpoint);

    if (_controllers.isEmpty) {
      _stompClient?.deactivate();
      _stompClient = null;
      _isConnected = false;
      _isConnecting = false;
      _unsubscribeFunctions.clear();
    }
  }

  void dispose() {
    _stompClient?.deactivate();
    _stompClient = null;
    _isConnected = false;
    _isConnecting = false;

    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
    _unsubscribeFunctions.clear();
  }
}
