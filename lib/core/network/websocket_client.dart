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
    final existingController = _controllers[topicEndpoint];

    if (existingController == null || existingController.isClosed) {
      _controllers[topicEndpoint] =
          StreamController<Map<String, dynamic>>.broadcast(
            onListen: () {
            },
            onCancel: () {
            },
          );
    } else {
    }

    _pendingTopics.add(topicEndpoint);

    if (_isSocketReady) {
      _subscribeToTopic(topicEndpoint);
    } else {
      unawaited(_connect());
    }

    return _controllers[topicEndpoint]!.stream;
  }

  bool get _isSocketReady {
    return _isConnected && _stompClient != null && _stompClient!.connected;
  }

  Future<void> _connect() async {
    if (_isConnecting) {
      return;
    }

    if (_isSocketReady) {
      _subscribeToAllPendingTopics();
      return;
    }

    if (_stompClient != null && _stompClient!.connected == false) {
      try {
        _stompClient!.deactivate();
      } catch (error, stackTrace) {
      }

      _stompClient = null;
      _isConnected = false;
      _unsubscribeFunctions.clear();
    }

    _isConnecting = true;

    try {
      final token = await _secureStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        _isConnecting = false;
        _broadcastError('Missing access token for WebSocket connection');
        return;
      }

      final String stompHubUrl = '${ApiConstants.wsBaseUrl}/ws?token=$token';

      _stompClient = StompClient(
        config: StompConfig(
          url: stompHubUrl,
          beforeConnect: () async {
          },
          onConnect: _onConnect,
          onWebSocketError: (error) {
            _isConnected = false;
            _isConnecting = false;

            _broadcastError(error is Object ? error : error.toString());
          },
          onStompError: (StompFrame frame) {
            _broadcastError(frame.body ?? 'STOMP Protocol Error');
          },
          onDisconnect: (StompFrame frame) {
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

      _stompClient!.activate();
    } catch (error, stackTrace) {
      _isConnected = false;
      _isConnecting = false;

      _broadcastError(error);
    }
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    _isConnecting = false;

    // Give the socket a tiny moment, then subscribe all queued topics.
    Future<void>.delayed(const Duration(milliseconds: 150), () {
      if (!_isSocketReady) {
        return;
      }

      _subscribeToAllPendingTopics();
    });
  }

  void _subscribeToAllPendingTopics() {
    final topicsToSubscribe = <String>{..._controllers.keys, ..._pendingTopics};

    for (final topic in topicsToSubscribe) {
      _subscribeToTopic(topic);
    }
  }

  void _subscribeToTopic(String topicEndpoint) {
    if (!_controllers.containsKey(topicEndpoint)) {
      return;
    }

    if (_unsubscribeFunctions.containsKey(topicEndpoint)) {
      _pendingTopics.remove(topicEndpoint);
      return;
    }

    if (!_isSocketReady) {
      _pendingTopics.add(topicEndpoint);
      unawaited(_connect());
      return;
    }

    try {
      final unsubscribe = _stompClient!.subscribe(
        destination: topicEndpoint,
        callback: (StompFrame frame) {
          final body = frame.body;

          if (body == null || body.isEmpty) {
            return;
          }

          try {
            final decoded = jsonDecode(body);

            if (decoded is! Map<String, dynamic>) {
              return;
            }

            final controller = _controllers[topicEndpoint];

            if (controller == null || controller.isClosed) {
              return;
            }

            controller.add(decoded);
          } catch (error, stackTrace) {
            _controllers[topicEndpoint]?.addError(error, stackTrace);
          }
        },
      );

      _unsubscribeFunctions[topicEndpoint] = unsubscribe;
      _pendingTopics.remove(topicEndpoint);

    } catch (error, stackTrace) {
      _pendingTopics.add(topicEndpoint);
      _controllers[topicEndpoint]?.addError(error, stackTrace);
    }
  }

  void _broadcastError(Object error) {
    for (final entry in _controllers.entries) {
      final topic = entry.key;
      final controller = entry.value;

      if (!controller.isClosed) {
        controller.addError(error);
      }
    }
  }

  /// Unsubscribes from a specific topic without closing the main Hub connection.
  void disconnect(String topicEndpoint) {
    _pendingTopics.remove(topicEndpoint);

    final unsubscribe = _unsubscribeFunctions.remove(topicEndpoint);

    if (unsubscribe != null) {
      try {
        unsubscribe();
      } catch (error, stackTrace) {
      }
    } else {
    }

    final controller = _controllers.remove(topicEndpoint);

    if (controller != null && !controller.isClosed) {
      unawaited(controller.close());
    } else {
    }

    if (_controllers.isEmpty) {
      // Keep this behavior if you want to close socket when no topic is watched.
      // If you want a persistent socket for the whole app, remove this block.
      try {
        _stompClient?.deactivate();
      } catch (error, stackTrace) {
      }

      _stompClient = null;
      _isConnected = false;
      _isConnecting = false;
      _unsubscribeFunctions.clear();
      _pendingTopics.clear();
    }
  }

  void dispose() {
    try {
      _stompClient?.deactivate();
    } catch (error, stackTrace) {
    }

    _stompClient = null;
    _isConnected = false;
    _isConnecting = false;

    for (final entry in _controllers.entries) {
      final topic = entry.key;
      final controller = entry.value;

      if (!controller.isClosed) {
        unawaited(controller.close());
      }
    }

    _controllers.clear();
    _unsubscribeFunctions.clear();
    _pendingTopics.clear();

  }
}
