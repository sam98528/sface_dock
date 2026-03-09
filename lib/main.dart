import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

import 'app/sfacedock_app.dart';
import 'utils/file_logger.dart';

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
      fullScreen: true,
      alwaysOnTop: true,  // 초기 시작 시에는 alwaysOnTop 활성화
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const ProviderScope(child: SFaceDockApp()));
}
