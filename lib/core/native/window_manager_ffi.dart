import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// C function signatures
typedef WindowFindByProcessNameNative = Int32 Function(
  Pointer<Utf8> processName,
  Pointer<Uint64> outHwnd,
);
typedef WindowFindByProcessNameDart = int Function(
  Pointer<Utf8> processName,
  Pointer<Uint64> outHwnd,
);

typedef WindowBringToFrontNative = Int32 Function(Uint64 hwnd);
typedef WindowBringToFrontDart = int Function(int hwnd);

typedef WindowBringCurrentAppToFrontNative = Int32 Function();
typedef WindowBringCurrentAppToFrontDart = int Function();

typedef WindowIsForegroundNative = Int32 Function(Uint64 hwnd);
typedef WindowIsForegroundDart = int Function(int hwnd);

class WindowManagerFFI {
  late final DynamicLibrary _lib;
  late final WindowFindByProcessNameDart _findByProcessName;
  late final WindowBringToFrontDart _bringToFront;
  late final WindowBringCurrentAppToFrontDart _bringCurrentAppToFront;
  late final WindowIsForegroundDart _isForeground;

  static WindowManagerFFI? _instance;

  WindowManagerFFI._internal() {
    // Load the native library
    if (Platform.isWindows) {
      _lib = DynamicLibrary.open('window_manager_ffi.dll');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Bind functions
    _findByProcessName = _lib
        .lookup<NativeFunction<WindowFindByProcessNameNative>>(
          'window_find_by_process_name',
        )
        .asFunction();

    _bringToFront = _lib
        .lookup<NativeFunction<WindowBringToFrontNative>>(
          'window_bring_to_front',
        )
        .asFunction();

    _bringCurrentAppToFront = _lib
        .lookup<NativeFunction<WindowBringCurrentAppToFrontNative>>(
          'window_bring_current_app_to_front',
        )
        .asFunction();

    _isForeground = _lib
        .lookup<NativeFunction<WindowIsForegroundNative>>(
          'window_is_foreground',
        )
        .asFunction();
  }

  static WindowManagerFFI get instance {
    _instance ??= WindowManagerFFI._internal();
    return _instance!;
  }

  /// Find window by process name (e.g., "RGB.exe", "notepad.exe")
  /// Returns window handle (HWND) on success, null on error
  int? findWindowByProcessName(String processName) {
    try {
      final processNamePtr = processName.toNativeUtf8();
      final hwndPtr = calloc<Uint64>();

      final result = _findByProcessName(processNamePtr, hwndPtr);

      final hwnd = hwndPtr.value;

      calloc.free(processNamePtr);
      calloc.free(hwndPtr);

      if (result != 0) {
        print('[ERROR] Find window by process name failed with code: $result');
        return null;
      }

      if (hwnd == 0) {
        print('[ERROR] Window handle is null');
        return null;
      }

      return hwnd;
    } catch (e) {
      print('[ERROR] Find window by process name exception: $e');
      return null;
    }
  }

  /// Bring a window to the front
  /// Returns true on success, false on error
  bool bringWindowToFront(int hwnd) {
    try {
      final result = _bringToFront(hwnd);
      return result == 0;
    } catch (e) {
      print('[ERROR] Bring window to front exception: $e');
      return false;
    }
  }

  /// Bring current application to front
  /// Returns true on success, false on error
  bool bringCurrentAppToFront() {
    try {
      final result = _bringCurrentAppToFront();
      return result == 0;
    } catch (e) {
      print('[ERROR] Bring current app to front exception: $e');
      return false;
    }
  }

  /// Check if a window is in the foreground
  /// Returns true if foreground, false otherwise
  bool isWindowForeground(int hwnd) {
    try {
      final result = _isForeground(hwnd);
      return result == 1;
    } catch (e) {
      print('[ERROR] Is window foreground exception: $e');
      return false;
    }
  }
}
