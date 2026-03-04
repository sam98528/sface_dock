// lib/core/device/ipc/ipc_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'named_pipe_client.dart';
import 'package:uuid/uuid.dart';

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() =>
      'TimeoutException: $message (timeout: ${timeout.inSeconds}s)';
}

/// IPC 클라이언트 - Device Controller Service와 통신 (Named Pipe 기반)
class IpcClient {
  static const String protocolVersion = '1.0';

  NamedPipeClient? _pipeClient;
  StreamSubscription<Map<String, dynamic>>? _eventSubscription;
  bool _connected = false;
  final Map<String, Completer<Map<String, dynamic>>> _pendingCommands = {};

  /// 동시에 여러 connect() 호출 시 한 번만 실제 연결 시도, 나머지는 같은 Future 대기.
  Future<bool>? _connectInProgress;

  /// 결제 완료 등 서버 푸시 이벤트용. 연결 전 구독해도 connect() 후 수신 이벤트를 받음.
  StreamController<Map<String, dynamic>>? _eventController;

  /// 전체 연결. 이미 연결 중이면 진행 중인 연결을 기다려 그 결과를 반환.
  Future<bool> connect() async {
    if (_connected) {
      return true;
    }
    if (_connectInProgress != null) {
      return _connectInProgress!;
    }

    _connectInProgress = _doConnect();
    try {
      final result = await _connectInProgress!;
      return result;
    } finally {
      _connectInProgress = null;
    }
  }

  Future<bool> _doConnect() async {
    try {
      debugPrint('Starting IPC connection via Named Pipe...');
      debugPrint('Pipe name: \\\\.\\pipe\\DeviceControllerService');
      debugPrint('Make sure Device Controller Service is running!');

      _pipeClient = NamedPipeClient();

      // Connect to pipe
      final connected = await _pipeClient!.connect();
      if (!connected) {
        debugPrint('Failed to connect to Named Pipe');
        debugPrint('Possible causes:');
        debugPrint('  1. Device Controller Service is not running');
        debugPrint('  2. Service failed to start IPC server');
        debugPrint(
          '  3. FFI functions not properly exported (rebuild Flutter app)',
        );
        return false;
      }

      _connected = true;
      _eventController ??= StreamController<Map<String, dynamic>>.broadcast();

      // 파이프 수신 → _handleMessage → event면 _eventController.add
      _eventSubscription = _pipeClient!.eventStream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint('Error in event stream: $error');
          _handleDisconnection();
        },
        onDone: () {
          debugPrint('Event stream closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      debugPrint('IPC connection established successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Failed to connect: $e');
      debugPrint('Stack trace: $stackTrace');
      _connected = false;
      return false;
    }
  }

  /// Handle incoming messages
  void _handleMessage(Map<String, dynamic> message) {
    final kind = message['kind'] as String?;

    if (kind == 'response') {
      final commandId = message['commandId'] as String?;
      if (commandId != null && _pendingCommands.containsKey(commandId)) {
        _pendingCommands[commandId]!.complete(message);
        _pendingCommands.remove(commandId);
      }
    } else if (kind == 'event') {
      final eventType = message['eventType'] as String?;
      debugPrint(
        '[IPC] Event received: eventType=$eventType, deviceType=${message['deviceType']}',
      );
      if (_eventController == null) {
        debugPrint(
          '[IPC] WARNING: _eventController is null, event not forwarded',
        );
      } else if (_eventController!.isClosed) {
        debugPrint(
          '[IPC] WARNING: _eventController is closed, event not forwarded',
        );
      } else {
        _eventController!.add(message);
        debugPrint(
          '[IPC] Event forwarded to ${_eventController!.stream.toString()} listeners',
        );
      }
    }
  }

  /// Handle disconnection
  void _handleDisconnection() {
    _connected = false;

    // Complete all pending commands with error
    for (var completer in _pendingCommands.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Connection lost'));
      }
    }
    _pendingCommands.clear();

    // Attempt to reconnect
    _reconnect();
  }

  /// Reconnect to pipe
  void _reconnect() {
    if (_connected) {
      return;
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!_connected) {
        debugPrint('Attempting to reconnect...');
        connect();
      }
    });
  }

  /// 연결 해제
  Future<void> disconnect() async {
    _connected = false;

    await _eventSubscription?.cancel();
    _eventSubscription = null;

    _pipeClient?.disconnect();
    _pipeClient = null;

    _eventController?.close();
    _eventController = null;

    // Complete all pending commands with error
    for (var completer in _pendingCommands.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Disconnected'));
      }
    }
    _pendingCommands.clear();

    debugPrint('IPC disconnected');
  }

  bool get isConnected => _connected && _pipeClient?.isConnected == true;

  /// 명령어 전송
  Future<Map<String, dynamic>> sendCommand({
    required String type,
    Map<String, String> payload = const {},
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!_connected || _pipeClient == null) {
      throw Exception('Not connected to IPC server');
    }

    final commandId = const Uuid().v4();
    final command = {
      'protocolVersion': protocolVersion,
      'kind': 'command',
      'commandId': commandId,
      'type': type,
      'timestampMs': DateTime.now().millisecondsSinceEpoch,
      'payload': payload,
    };

    try {
      debugPrint('Sending command: $type (ID: $commandId)');

      // Create completer for response
      final completer = Completer<Map<String, dynamic>>();
      _pendingCommands[commandId] = completer;

      // Send command
      final commandJson = jsonEncode(command);
      final sent = await _pipeClient!.sendMessage(commandJson);

      if (!sent) {
        _pendingCommands.remove(commandId);
        throw Exception('Failed to send command');
      }

      // Wait for response with timeout
      final response = await completer.future.timeout(
        timeout,
        onTimeout: () {
          _pendingCommands.remove(commandId);
          throw TimeoutException('Command timeout: $type', timeout);
        },
      );

      debugPrint('Command response received: $response');
      return response;
    } catch (e, stackTrace) {
      debugPrint('Error sending command: $e');
      debugPrint('Stack trace: $stackTrace');
      _pendingCommands.remove(commandId);
      rethrow;
    }
  }

  /// 이벤트 스트림. 연결 전에 구독해도 connect() 완료 후 서버에서 오는 이벤트를 받음.
  Stream<Map<String, dynamic>> get eventStream {
    _eventController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _eventController!.stream;
  }
}
