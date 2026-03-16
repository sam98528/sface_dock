// lib/presentation/components/mjpeg_viewer.dart
// MJPEG 스트림을 별도 Isolate에서 수신/파싱 → 메인 스레드는 디코딩+렌더만.
//
// 핵심 최적화:
// - 별도 Isolate: HttpClient 접속 + Content-Length 기반 파싱 (SOI/EOI 폴백).
// - 메인 Isolate: ReceivePort → ui.decodeImageFromList (엔진 워커 스레드) → RawImage 렌더.
// - 30fps 캡 + pendingJpeg 드롭 → 최신 프레임만 유지.
// - 메인스레드는 JPEG 파싱/네트워크 I/O를 전혀 하지 않음.
//
// 참고: ai-kiosk-client/lib/widgets/liveview_mjpeg_isolate.dart

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io' show HttpClient;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  Isolate 진입점 + MJPEG 파싱 (메인스레드 밖에서 실행)
// ═══════════════════════════════════════════════════════════════════════════

class _IsolateStartMessage {
  final SendPort sendPort;
  final String url;
  _IsolateStartMessage(this.sendPort, this.url);
}

/// 백그라운드 Isolate 진입점.
/// MJPEG HTTP 스트림 수신 → Content-Length 기반 파싱 → JPEG Uint8List를 SendPort로 전달.
Future<void> _mjpegIsolateEntry(_IsolateStartMessage msg) async {
  final sendPort = msg.sendPort;
  HttpClient? client;
  try {
    client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    final request = await client.getUrl(Uri.parse(msg.url));
    final response = await request.close();

    if (response.statusCode != 200) {
      sendPort.send('HTTP 응답 ${response.statusCode}');
      client.close();
      return;
    }

    final builder = BytesBuilder(copy: false);

    await for (final chunk in response) {
      builder.add(chunk);
      var data = builder.takeBytes();

      while (true) {
        final result = _extractJpegFrame(data);
        if (result == null) break;
        sendPort.send(result.jpeg);
        data = result.remaining;
      }

      if (data.isNotEmpty) {
        builder.add(data);
      }

      // 안전장치: 2MB 이상 누적 시 버퍼 초기화.
      if (builder.length > 2 * 1024 * 1024) {
        builder.clear();
      }
    }

    sendPort.send(null);
  } catch (e) {
    sendPort.send(e.toString());
  } finally {
    client?.close(force: true);
  }
}

// ── MJPEG 파싱 헬퍼 ──

class _FrameResult {
  final Uint8List jpeg;
  final Uint8List remaining;
  _FrameResult(this.jpeg, this.remaining);
}

/// MJPEG 멀티파트에서 JPEG 한 프레임 추출.
/// 1차: "--frame" 바운더리 + Content-Length 헤더 기반.
/// 2차: SOI/EOI 마커 기반 폴백.
_FrameResult? _extractJpegFrame(Uint8List data) {
  final bIdx = _indexOf(data, _kBoundary, 0);
  if (bIdx < 0) return _extractBySoiEoi(data);

  final hStart = bIdx + _kBoundary.length;
  final hEnd = _indexOf(data, _kHeaderEnd, hStart);
  if (hEnd < 0) return null;

  final bodyStart = hEnd + _kHeaderEnd.length;

  final contentLen = _parseContentLength(data, hStart, hEnd);
  if (contentLen != null && contentLen > 0) {
    final bodyEnd = bodyStart + contentLen;
    if (bodyEnd > data.length) return null;
    return _FrameResult(
      data.sublist(bodyStart, bodyEnd),
      data.sublist(bodyEnd),
    );
  }

  if (bodyStart >= data.length) return null;
  return _extractBySoiEoi(data.sublist(bodyStart));
}

_FrameResult? _extractBySoiEoi(Uint8List data) {
  final len = data.length;
  if (len < 4) return null;

  int start = -1;
  for (int i = 0; i < len - 1; i++) {
    if (data[i] == 0xFF && data[i + 1] == 0xD8) {
      start = i;
      break;
    }
  }
  if (start < 0) return null;

  for (int j = start + 2; j < len - 1; j++) {
    if (data[j] == 0xFF && data[j + 1] == 0xD9) {
      final end = j + 2;
      return _FrameResult(data.sublist(start, end), data.sublist(end));
    }
  }
  return null;
}

final Uint8List _kBoundary = Uint8List.fromList('--frame\r\n'.codeUnits);
final Uint8List _kHeaderEnd = Uint8List.fromList('\r\n\r\n'.codeUnits);

int _indexOf(Uint8List data, Uint8List needle, int from) {
  final limit = data.length - needle.length;
  final first = needle[0];
  final nLen = needle.length;
  for (int i = from; i <= limit; i++) {
    if (data[i] != first) continue;
    bool match = true;
    for (int j = 1; j < nLen; j++) {
      if (data[i + j] != needle[j]) {
        match = false;
        break;
      }
    }
    if (match) return i;
  }
  return -1;
}

int? _parseContentLength(Uint8List data, int from, int to) {
  const cl = 'content-length:';
  final clLen = cl.length;
  outer:
  for (int i = from; i <= to - clLen; i++) {
    for (int j = 0; j < clLen; j++) {
      final c = data[i + j];
      final lower = (c >= 0x41 && c <= 0x5A) ? c + 0x20 : c;
      if (lower != cl.codeUnitAt(j)) continue outer;
    }
    int k = i + clLen;
    while (k < to && data[k] == 0x20) {
      k++;
    }
    int val = 0;
    bool found = false;
    for (; k < to; k++) {
      final d = data[k];
      if (d >= 0x30 && d <= 0x39) {
        val = val * 10 + (d - 0x30);
        found = true;
      } else {
        break;
      }
    }
    return found ? val : null;
  }
  return null;
}

// ═══════════════════════════════════════════════════════════════════════════
//  Widget (메인 Isolate에서 실행)
// ═══════════════════════════════════════════════════════════════════════════

/// 30fps 표시 간격.
const Duration _kDisplayInterval = Duration(milliseconds: 33);

class MjpegViewer extends StatefulWidget {
  final String streamUrl;
  final BoxFit fit;
  final Widget? loading;
  final Widget? error;

  const MjpegViewer({
    super.key,
    required this.streamUrl,
    this.fit = BoxFit.contain,
    this.loading,
    this.error,
  });

  @override
  State<MjpegViewer> createState() => _MjpegViewerState();
}

class _MjpegViewerState extends State<MjpegViewer> {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  ui.Image? _displayImage;
  Uint8List? _pendingJpeg;
  Timer? _displayTimer;
  bool _decoding = false;
  bool _hasError = false;

  Timer? _noFrameTimer;
  static const Duration _noFrameTimeout = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _startIsolate(widget.streamUrl);
  }

  @override
  void didUpdateWidget(MjpegViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streamUrl != widget.streamUrl) {
      _stopIsolate();
      _startIsolate(widget.streamUrl);
    }
  }

  // ── Isolate 관리 ──

  Future<void> _startIsolate(String url) async {
    _hasError = false;
    _pendingJpeg = null;
    _displayImage?.dispose();
    _displayImage = null;

    _noFrameTimer?.cancel();
    _noFrameTimer = Timer(_noFrameTimeout, () {
      if (mounted && _displayImage == null && !_hasError) {
        setState(() => _hasError = true);
      }
    });

    final port = ReceivePort();
    _receivePort = port;

    try {
      _isolate = await Isolate.spawn(
        _mjpegIsolateEntry,
        _IsolateStartMessage(port.sendPort, url),
        debugName: 'mjpeg-stream',
      );
    } catch (e) {
      debugPrint('[MjpegViewer] Isolate 생성 실패: $e');
      _noFrameTimer?.cancel();
      if (mounted) setState(() => _hasError = true);
      return;
    }

    port.listen(_onIsolateMessage);
  }

  void _onIsolateMessage(dynamic message) {
    if (!mounted) return;

    if (message is Uint8List) {
      _onJpegReceived(message);
    } else if (message is String) {
      debugPrint('[MjpegViewer] 스트림 에러: $message');
      _noFrameTimer?.cancel();
      setState(() => _hasError = true);
    } else if (message == null) {
      // 스트림 정상 종료
    }
  }

  // ── 프레임 수신 + 디코딩 + 표시 ──

  void _onJpegReceived(Uint8List jpeg) {
    _noFrameTimer?.cancel();
    _pendingJpeg = jpeg;

    // 첫 프레임: 즉시 디코딩. 이후: 30fps 캡.
    if (_displayImage == null && !_decoding) {
      _decodeAndDisplay();
      return;
    }
    _displayTimer ??= Timer(_kDisplayInterval, _flushPending);
  }

  void _flushPending() {
    _displayTimer = null;
    if (!mounted || _pendingJpeg == null) return;
    _decodeAndDisplay();
  }

  void _decodeAndDisplay() {
    final jpeg = _pendingJpeg;
    if (jpeg == null || _decoding) return;
    _pendingJpeg = null;
    _decoding = true;

    ui.decodeImageFromList(jpeg, (ui.Image decoded) {
      _decoding = false;
      if (!mounted) {
        decoded.dispose();
        return;
      }
      final old = _displayImage;
      _displayImage = decoded;
      old?.dispose();
      setState(() {});

      if (_pendingJpeg != null && _displayTimer == null) {
        _displayTimer = Timer(_kDisplayInterval, _flushPending);
      }
    });
  }

  // ── 정리 ──

  void _stopIsolate() {
    _noFrameTimer?.cancel();
    _noFrameTimer = null;
    _displayTimer?.cancel();
    _displayTimer = null;
    _receivePort?.close();
    _receivePort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _pendingJpeg = null;
    _decoding = false;
  }

  @override
  void dispose() {
    _stopIsolate();
    _displayImage?.dispose();
    _displayImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.error ??
          const Center(child: Icon(Icons.error_outline, size: 48));
    }

    if (_displayImage == null) {
      return widget.loading ??
          const Center(child: CircularProgressIndicator(strokeWidth: 3));
    }

    return RepaintBoundary(
      child: RawImage(
        image: _displayImage,
        fit: widget.fit,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
