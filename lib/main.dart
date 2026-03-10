import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

import 'app/sfacedock_app.dart';
import 'utils/file_logger.dart';
import 'core/device/device_controller_proxy.dart';
import 'core/device/device_controller_proxy_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Initialize IPC connection early (for RGB navigation support)
  // This ensures pipe is ready when RGB wants to return to Flutter
  final deviceProxy = DeviceControllerProxy();
  debugPrint(
    '[Main] Attempting early IPC connection for RGB navigation support...',
  );
  final connected = await deviceProxy.connect();
  if (connected) {
    debugPrint('[Main] IPC connected successfully - RGB navigation ready');
  } else {
    debugPrint('[Main] IPC connection failed - RGB navigation may not work');
    debugPrint(
      '[Main] This is OK if kiorobo-controller service is not running',
    );
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
      titleBarStyle: TitleBarStyle.normal,
      title: 'SFace Kiosk',
      // skipTaskbar: true,
      // fullScreen: true,
      // alwaysOnTop: true, // 초기 시작 시에는 alwaysOnTop 활성화
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
