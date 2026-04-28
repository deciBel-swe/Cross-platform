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

  // One stream controller per topic.
  final Map<String, StreamController<Map<String, dynamic>>> _controllers =
      <String, StreamController<Map<String, dynamic>>>{};

  // One unsubscribe callback per subscribed topic.
  final Map<String, StompUnsubscribe> _unsubscribeFunctions =
      <String, StompUnsubscribe>{};

  // Topics waiting for the socket to connect.
  final Set<String> _pendingTopics = <String>{};

  /// Returns a stream for a specific STOMP topic.
  ///
  /// Important:
  /// - If STOMP is already connected, it subscribes immediately.
  /// - If STOMP is not connected yet, it queues the topic and connects.
  /// - When onConnect fires, all pending/current topics are subscribed.
  Stream<Map<String, dynamic>> watch(String topicEndpoint) {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] watch() called');
    debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
    debugPrint('[WebSocketClient] isConnected: $_isConnected');
    debugPrint('[WebSocketClient] isConnecting: $_isConnecting');
    debugPrint('[WebSocketClient] stomp connected: ${_stompClient?.connected}');

    final existingController = _controllers[topicEndpoint];

    if (existingController == null || existingController.isClosed) {
      debugPrint('[WebSocketClient] creating new controller for topic');

      _controllers[topicEndpoint] =
          StreamController<Map<String, dynamic>>.broadcast(
            onListen: () {
              debugPrint('[WebSocketClient] stream listener attached');
              debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
            },
            onCancel: () {
              debugPrint('[WebSocketClient] stream listener cancelled');
              debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
            },
          );
    } else {
      debugPrint('[WebSocketClient] reusing existing controller for topic');
    }

    _pendingTopics.add(topicEndpoint);

    if (_isSocketReady) {
      debugPrint('[WebSocketClient] socket ready, subscribing now');
      _subscribeToTopic(topicEndpoint);
    } else {
      debugPrint('[WebSocketClient] socket not ready, connecting first');
      unawaited(_connect());
    }

    return _controllers[topicEndpoint]!.stream;
  }

  bool get _isSocketReady {
    return _isConnected && _stompClient != null && _stompClient!.connected;
  }

  Future<void> _connect() async {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] _connect() called');
    debugPrint('[WebSocketClient] isConnected: $_isConnected');
    debugPrint('[WebSocketClient] isConnecting: $_isConnecting');
    debugPrint('[WebSocketClient] stomp connected: ${_stompClient?.connected}');

    if (_isConnecting) {
      debugPrint('[WebSocketClient] already connecting, skipping');
      return;
    }

    if (_isSocketReady) {
      debugPrint('[WebSocketClient] socket already ready');

      _subscribeToAllPendingTopics();
      return;
    }

    if (_stompClient != null && _stompClient!.connected == false) {
      debugPrint('[WebSocketClient] old disconnected client found');
      debugPrint('[WebSocketClient] deactivating old client');

      try {
        _stompClient!.deactivate();
      } catch (error, stackTrace) {
        debugPrint('[WebSocketClient] old deactivate failed: $error');
        debugPrint('[WebSocketClient] stackTrace: $stackTrace');
      }

      _stompClient = null;
      _isConnected = false;
      _unsubscribeFunctions.clear();
    }

    _isConnecting = true;

    try {
      final token = await _secureStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('[WebSocketClient] access token is null/empty');
        _isConnecting = false;
        _broadcastError('Missing access token for WebSocket connection');
        return;
      }

      final String stompHubUrl = '${ApiConstants.wsBaseUrl}/ws?token=$token';

      debugPrint('[WebSocketClient] creating STOMP client');
      debugPrint('[WebSocketClient] url: $stompHubUrl');

      _stompClient = StompClient(
        config: StompConfig(
          url: stompHubUrl,
          beforeConnect: () async {
            debugPrint('STOMP: Booting up main connection to $stompHubUrl...');
          },
          onConnect: _onConnect,
          onWebSocketError: (error) {
            debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            debugPrint('[WebSocketClient] onWebSocketError');
            debugPrint('[WebSocketClient] error: $error');

            _isConnected = false;
            _isConnecting = false;

            _broadcastError(error is Object ? error : error.toString());
          },
          onStompError: (StompFrame frame) {
            debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            debugPrint('[WebSocketClient] onStompError');
            debugPrint('[WebSocketClient] command: ${frame.command}');
            debugPrint('[WebSocketClient] headers: ${frame.headers}');
            debugPrint('[WebSocketClient] body: ${frame.body}');

            _broadcastError(frame.body ?? 'STOMP Protocol Error');
          },
          onDisconnect: (StompFrame frame) {
            debugPrint('------------------------------');
            debugPrint('[WebSocketClient] onDisconnect');
            debugPrint('[WebSocketClient] command: ${frame.command}');
            debugPrint('[WebSocketClient] headers: ${frame.headers}');
            debugPrint('[WebSocketClient] body: ${frame.body}');

            _isConnected = false;
            _isConnecting = false;
            _unsubscribeFunctions.clear();

            // Keep controllers alive.
            // If reconnect happens, existing topics can be subscribed again.
            _pendingTopics.addAll(_controllers.keys);
          },
          stompConnectHeaders: <String, String>{
            'Authorization': 'Bearer $token',
          },
          webSocketConnectHeaders: <String, String>{
            'Authorization': 'Bearer $token',
          },
          reconnectDelay: const Duration(seconds: 5),
        ),
      );

      debugPrint('[WebSocketClient] activating STOMP client');
      _stompClient!.activate();
    } catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('[WebSocketClient] STOMP setup failed');
      debugPrint('[WebSocketClient] error: $error');
      debugPrint('[WebSocketClient] stackTrace: $stackTrace');

      _isConnected = false;
      _isConnecting = false;

      _broadcastError(error);
    }
  }

  void _onConnect(StompFrame frame) {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] onConnect');
    debugPrint('[WebSocketClient] command: ${frame.command}');
    debugPrint('[WebSocketClient] headers: ${frame.headers}');
    debugPrint('[WebSocketClient] body: ${frame.body}');
    debugPrint('STOMP: Connected to Main Hub Successfully!');

    _isConnected = true;
    _isConnecting = false;

    // Give the socket a tiny moment, then subscribe all queued topics.
    Future<void>.delayed(const Duration(milliseconds: 150), () {
      if (!_isSocketReady) {
        debugPrint('[WebSocketClient] connection dropped before subscribe');
        return;
      }

      _subscribeToAllPendingTopics();
    });
  }

  void _subscribeToAllPendingTopics() {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] _subscribeToAllPendingTopics() called');
    debugPrint('[WebSocketClient] controllers: ${_controllers.keys.toList()}');
    debugPrint('[WebSocketClient] pendingTopics: ${_pendingTopics.toList()}');

    final topicsToSubscribe = <String>{..._controllers.keys, ..._pendingTopics};

    for (final topic in topicsToSubscribe) {
      _subscribeToTopic(topic);
    }
  }

  void _subscribeToTopic(String topicEndpoint) {
    debugPrint('------------------------------');
    debugPrint('[WebSocketClient] _subscribeToTopic() called');
    debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
    debugPrint('[WebSocketClient] isSocketReady: $_isSocketReady');

    if (!_controllers.containsKey(topicEndpoint)) {
      debugPrint('[WebSocketClient] no controller found for topic');
      return;
    }

    if (_unsubscribeFunctions.containsKey(topicEndpoint)) {
      debugPrint('[WebSocketClient] already subscribed to topic');
      _pendingTopics.remove(topicEndpoint);
      return;
    }

    if (!_isSocketReady) {
      debugPrint('[WebSocketClient] socket not ready, keeping topic pending');
      _pendingTopics.add(topicEndpoint);
      unawaited(_connect());
      return;
    }

    try {
      debugPrint('STOMP: Subscribing to $topicEndpoint');

      final unsubscribe = _stompClient!.subscribe(
        destination: topicEndpoint,
        callback: (StompFrame frame) {
          debugPrint('==============================');
          debugPrint('[WebSocketClient] STOMP message received');
          debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
          debugPrint('[WebSocketClient] command: ${frame.command}');
          debugPrint('[WebSocketClient] headers: ${frame.headers}');
          debugPrint('[WebSocketClient] body: ${frame.body}');

          final body = frame.body;

          if (body == null || body.isEmpty) {
            debugPrint('[WebSocketClient] ignored empty STOMP body');
            return;
          }

          try {
            final decoded = jsonDecode(body);

            if (decoded is! Map<String, dynamic>) {
              debugPrint('[WebSocketClient] decoded body is not a map');
              debugPrint('[WebSocketClient] decoded: $decoded');
              return;
            }

            final controller = _controllers[topicEndpoint];

            if (controller == null || controller.isClosed) {
              debugPrint('[WebSocketClient] controller missing/closed');
              return;
            }

            debugPrint('[WebSocketClient] adding decoded message to stream');
            controller.add(decoded);
          } catch (error, stackTrace) {
            debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            debugPrint('[WebSocketClient] STOMP JSON decode error');
            debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
            debugPrint('[WebSocketClient] body: $body');
            debugPrint('[WebSocketClient] error: $error');
            debugPrint('[WebSocketClient] stackTrace: $stackTrace');

            _controllers[topicEndpoint]?.addError(error, stackTrace);
          }
        },
      );

      _unsubscribeFunctions[topicEndpoint] = unsubscribe;
      _pendingTopics.remove(topicEndpoint);

      debugPrint('[WebSocketClient] subscription saved successfully');
    } catch (error, stackTrace) {
      debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      debugPrint('[WebSocketClient] subscribe failed');
      debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');
      debugPrint('[WebSocketClient] error: $error');
      debugPrint('[WebSocketClient] stackTrace: $stackTrace');

      _pendingTopics.add(topicEndpoint);
      _controllers[topicEndpoint]?.addError(error, stackTrace);
    }
  }

  void _broadcastError(Object error) {
    debugPrint('[WebSocketClient] _broadcastError() called');
    debugPrint('[WebSocketClient] error: $error');

    for (final entry in _controllers.entries) {
      final topic = entry.key;
      final controller = entry.value;

      if (!controller.isClosed) {
        debugPrint('[WebSocketClient] broadcasting error to $topic');
        controller.addError(error);
      }
    }
  }

  /// Unsubscribes from a specific topic without closing the main Hub connection.
  void disconnect(String topicEndpoint) {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] disconnect() called');
    debugPrint('[WebSocketClient] topicEndpoint: $topicEndpoint');

    _pendingTopics.remove(topicEndpoint);

    final unsubscribe = _unsubscribeFunctions.remove(topicEndpoint);

    if (unsubscribe != null) {
      try {
        debugPrint('[WebSocketClient] executing STOMP unsubscribe');
        unsubscribe();
        debugPrint('STOMP: Unsubscribed from $topicEndpoint');
      } catch (error, stackTrace) {
        debugPrint('[WebSocketClient] unsubscribe failed: $error');
        debugPrint('[WebSocketClient] stackTrace: $stackTrace');
      }
    } else {
      debugPrint('[WebSocketClient] no unsubscribe function found');
    }

    final controller = _controllers.remove(topicEndpoint);

    if (controller != null && !controller.isClosed) {
      debugPrint('[WebSocketClient] closing stream controller');
      unawaited(controller.close());
    } else {
      debugPrint('[WebSocketClient] no open controller found');
    }

    if (_controllers.isEmpty) {
      debugPrint('[WebSocketClient] no active controllers left');

      // Keep this behavior if you want to close socket when no topic is watched.
      // If you want a persistent socket for the whole app, remove this block.
      try {
        debugPrint('[WebSocketClient] deactivating STOMP client');
        _stompClient?.deactivate();
      } catch (error, stackTrace) {
        debugPrint('[WebSocketClient] deactivate failed: $error');
        debugPrint('[WebSocketClient] stackTrace: $stackTrace');
      }

      _stompClient = null;
      _isConnected = false;
      _isConnecting = false;
      _unsubscribeFunctions.clear();
      _pendingTopics.clear();
    }
  }

  void dispose() {
    debugPrint('==============================');
    debugPrint('[WebSocketClient] dispose() called');

    try {
      _stompClient?.deactivate();
    } catch (error, stackTrace) {
      debugPrint('[WebSocketClient] dispose deactivate failed: $error');
      debugPrint('[WebSocketClient] stackTrace: $stackTrace');
    }

    _stompClient = null;
    _isConnected = false;
    _isConnecting = false;

    for (final entry in _controllers.entries) {
      final topic = entry.key;
      final controller = entry.value;

      if (!controller.isClosed) {
        debugPrint('[WebSocketClient] closing controller for $topic');
        unawaited(controller.close());
      }
    }

    _controllers.clear();
    _unsubscribeFunctions.clear();
    _pendingTopics.clear();

    debugPrint('[WebSocketClient] dispose finished');
  }
}
