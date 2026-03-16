import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

import 'app/sfacedock_app.dart';
import 'utils/file_logger.dart';
import 'core/device/device_controller_proxy.dart';
import 'core/device/device_controller_proxy_provider.dart';

// Win32 constants
const int _errorAlreadyExists = 183;

/// Windows Named Mutex를 사용한 단일 인스턴스 보장.
/// 이미 실행 중이면 현재 프로세스를 즉시 종료합니다.
/// 창 복원은
/// 
/// 
///  하지 않음 — RGB → Flutter 복귀는 kiorobo-controller의
/// external_navigate 이벤트 흐름이 담당합니다.
bool _ensureSingleInstance() {
  if (!Platform.isWindows) return true;

  final kernel32 = DynamicLibrary.open('kernel32.dll');

  final createMutex = kernel32.lookupFunction<
    IntPtr Function(Pointer, Int32, Pointer<Utf16>),
    int Function(Pointer, int, Pointer<Utf16>)
  >('CreateMutexW');

  final getLastError = kernel32.lookupFunction<
    Uint32 Function(),
    int Function()
  >('GetLastError');

  final mutexName = 'Global\\SFaceDock_SingleInstance'.toNativeUtf16();
  createMutex(nullptr, 0, mutexName);
  final error = getLastError();
  malloc.free(mutexName);

  if (error == _errorAlreadyExists) {
    debugPrint('[Main] SFaceDock is already running — exiting duplicate instance');
    return false;
  }

  return true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Single instance check — if already running, restore and exit
  if (!_ensureSingleInstance()) {
    exit(0);
  }

  // ImageCache: memCacheWidth=360 -> ~0.5MB/image, 500장 = ~250MB
  PaintingBinding.instance.imageCache.maximumSize = 500;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 250 * 1024 * 1024;

  // Load .env file
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Failed to load .env file: $e');
  }

  // Initialize file logger
  await FileLogger.instance.initialize();

  // Initialize IPC pipe only (no device initialization side effects)
  // Pipe stays open for app lifetime; hardware init is explicit via resumeHardware()
  final deviceProxy = DeviceControllerProxy();
  debugPrint('[Main] Attempting IPC pipe connection...');
  final connected = await deviceProxy.connect();
  if (connected) {
    debugPrint('[Main] IPC pipe connected successfully');
  } else {
    debugPrint('[Main] IPC pipe connection failed - will retry in intro_loading');
    debugPrint('[Main] This is OK if kiorobo-controller service is not running');
  }

  // Initialize window manager (Windows only)
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1920, 1080),
      minimumSize: Size(1920, 1080),
      maximumSize: Size(1920, 1080),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'SFace Kiosk',
      fullScreen: true,
      alwaysOnTop: true,

    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ProviderScope(
      overrides: [
        // Override the deviceControllerProxyProvider with the pre-connected instance
        deviceControllerProxyProvider.overrideWithValue(deviceProxy),
      ],
      child: const SFaceDockApp(),
    ),
  );
}
