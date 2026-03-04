// lib/core/device/ipc/named_pipe_client.dart
import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

/// Named Pipe Client using FFI
class NamedPipeClient {
  static const String _defaultPipeName = r'\\.\pipe\DeviceControllerService';

  DynamicLibrary? _dylib;
  Pointer<Void>? _clientHandle;
  final String _pipeName;
  bool _connected = false;
  Timer? _receiveTimer;
  StreamController<Map<String, dynamic>>? _eventController;

  NamedPipeClient({String? pipeName})
    : _pipeName = pipeName ?? _defaultPipeName;

  /// Load FFI library
  void _loadLibrary() {
    if (_dylib != null) return;

    try {
      // On Windows, functions are exported from the executable itself
      _dylib = DynamicLibrary.process();
    } catch (e) {
      throw Exception('Failed to load FFI library: $e');
    }
  }

  /// Connect to named pipe server
  Future<bool> connect() async {
    if (_connected) {
      return true;
    }

    try {
      _loadLibrary();

      // Get FFI functions
      Pointer<Void> Function(Pointer<Utf8>)? createPipeClient;
      int Function(Pointer<Void>)? connectPipe;
      int Function(Pointer<Void>)? getLastError;

      try {
        createPipeClient = _dylib!
            .lookupFunction<
              Pointer<Void> Function(Pointer<Utf8>),
              Pointer<Void> Function(Pointer<Utf8>)
            >('createPipeClient');
        connectPipe = _dylib!
            .lookupFunction<
              Int32 Function(Pointer<Void>),
              int Function(Pointer<Void>)
            >('connectPipe');
        getLastError = _dylib!
            .lookupFunction<
              Uint32 Function(Pointer<Void>),
              int Function(Pointer<Void>)
            >('getLastError');
        debugPrint('FFI functions loaded successfully');
      } catch (e) {
        debugPrint('Error loading FFI functions: $e');
        debugPrint('Make sure the app was rebuilt after adding FFI functions');
        return false;
      }

      // Create client
      final pipeNamePtr = _pipeName.toNativeUtf8();
      debugPrint('Attempting to connect to pipe: $_pipeName');

      _clientHandle = createPipeClient(pipeNamePtr);
      malloc.free(pipeNamePtr);

      if (_clientHandle == nullptr) {
        debugPrint('Failed to create pipe client handle');
        return false;
      }

      // Connect
      debugPrint('Calling connectPipe...');
      final result = connectPipe(_clientHandle!);

      if (result == 0) {
        final errorCode = getLastError(_clientHandle!);
        debugPrint('Failed to connect to named pipe. Error code: $errorCode');
        debugPrint('Common error codes:');
        debugPrint(
          '  2 (ERROR_FILE_NOT_FOUND): Pipe does not exist - service not running',
        );
        debugPrint(
          '  231 (ERROR_PIPE_BUSY): Pipe is busy - another client connected',
        );
        debugPrint('  109 (ERROR_BROKEN_PIPE): Pipe was closed');
        debugPrint('');
        debugPrint('Please check:');
        debugPrint('  1. Device Controller Service is running');
        debugPrint(
          '  2. Service console shows "IPC Server started successfully"',
        );
        debugPrint(
          '  3. Service console shows "Named pipe created, waiting for client connection..."',
        );
        _closeHandle();
        return false;
      }

      debugPrint('Successfully connected to named pipe');

      _connected = true;
      debugPrint('Successfully connected to named pipe');

      // Start receiving messages
      _startReceiving();

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error connecting to named pipe: $e');
      debugPrint('Stack trace: $stackTrace');
      _closeHandle();
      return false;
    }
  }

  /// Send message to server
  Future<bool> sendMessage(String message) async {
    if (!_connected || _clientHandle == nullptr) {
      return false;
    }

    try {
      _loadLibrary();

      final sendMessageFunc = _dylib!
          .lookupFunction<
            Int32 Function(Pointer<Void>, Pointer<Utf8>),
            int Function(Pointer<Void>, Pointer<Utf8>)
          >('sendMessage');

      final messagePtr = message.toNativeUtf8();
      final result = sendMessageFunc(_clientHandle!, messagePtr);
      malloc.free(messagePtr);

      if (result == 0) {
        _connected = false;
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Start receiving messages in background
  void _startReceiving() {
    _eventController = StreamController<Map<String, dynamic>>.broadcast();

    _receiveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_connected) {
        timer.cancel();
        return;
      }

      try {
        _loadLibrary();

        final receiveMessageFunc = _dylib!
            .lookupFunction<
              Int32 Function(
                Pointer<Void>,
                Pointer<Utf8>,
                Int32,
                Pointer<Int32>,
              ),
              int Function(Pointer<Void>, Pointer<Utf8>, int, Pointer<Int32>)
            >('receiveMessage');

        const bufferSize = 65536;
        final buffer = calloc<Uint8>(bufferSize);
        final messageLength = calloc<Int32>(1);

        final bufferUtf8 = buffer.cast<Utf8>();
        final result = receiveMessageFunc(
          _clientHandle!,
          bufferUtf8,
          bufferSize,
          messageLength,
        );

        if (result != 0 && messageLength.value > 0) {
          // C++ 쪽 acquirer/issuer 등이 UTF-8이 아닌 바이트를 보낼 수 있음 → 허용 디코딩
          String? decoded;
          try {
            final bytes = buffer.asTypedList(messageLength.value);
            decoded = utf8.decode(bytes, allowMalformed: true);
          } on FormatException catch (e) {
            debugPrint('[NamedPipe] UTF-8 decode error (message skipped): $e');
          }
          if (decoded != null) {
            try {
              // JSON 문자열 내 제어문자(0x00-0x1F) 제거 — C++ 쪽 CP949 등 비UTF-8 바이트가 제어문자로 해석되면 jsonDecode 실패
              final sanitized = decoded.replaceAll(RegExp(r'[\x00-\x1f]'), ' ');
              final json = jsonDecode(sanitized) as Map<String, dynamic>;
              final kind = json['kind'] as String?;
              if (kind == 'event') {
                debugPrint('[NamedPipe] received event: ${json['eventType']}');
              }
              if (_eventController != null && !_eventController!.isClosed) {
                _eventController!.add(json);
              }
            } catch (e) {
              debugPrint(
                '[NamedPipe] parse error: $e (length=${messageLength.value}, head=${decoded.length > 80 ? decoded.substring(0, 80) : decoded}...)',
              );
            }
          }
        }

        calloc.free(buffer);
        calloc.free(messageLength);

        // Check connection status
        final isConnectedFunc = _dylib!
            .lookupFunction<
              Int32 Function(Pointer<Void>),
              int Function(Pointer<Void>)
            >('isConnected');

        if (isConnectedFunc(_clientHandle!) == 0) {
          _connected = false;
          timer.cancel();
        }
      } catch (e) {
        debugPrint('Error receiving message: $e');
        _connected = false;
        timer.cancel();
      }
    });
  }

  /// Get event stream
  Stream<Map<String, dynamic>> get eventStream {
    _eventController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _eventController!.stream;
  }

  /// Disconnect from named pipe
  void disconnect() {
    _connected = false;
    _receiveTimer?.cancel();
    _receiveTimer = null;

    if (_clientHandle != nullptr) {
      try {
        _loadLibrary();

        final closePipeFunc = _dylib!
            .lookupFunction<
              Void Function(Pointer<Void>),
              void Function(Pointer<Void>)
            >('closePipe');

        closePipeFunc(_clientHandle!);
      } catch (e) {
        debugPrint('Error closing pipe: $e');
      }

      _clientHandle = nullptr;
    }

    _eventController?.close();
    _eventController = null;
  }

  void _closeHandle() {
    if (_clientHandle != nullptr) {
      try {
        _loadLibrary();
        final closePipeFunc = _dylib!
            .lookupFunction<
              Void Function(Pointer<Void>),
              void Function(Pointer<Void>)
            >('closePipe');
        closePipeFunc(_clientHandle!);
      } catch (e) {
        // Ignore errors during cleanup
      }
      _clientHandle = nullptr;
    }
  }

  bool get isConnected => _connected && _clientHandle != nullptr;

  void dispose() {
    disconnect();
  }
}
