import 'package:sfacedock/core/native/window_manager_ffi.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class WindowManagerService {
  static WindowManagerService? _instance;
  static WindowManagerService get instance =>
      _instance ??= WindowManagerService._internal();

  WindowManagerService._internal();

  final WindowManagerFFI _windowManagerFFI = WindowManagerFFI.instance;
  final Logger _logger = Logger();

  /// Bring a process to the foreground by process name
  /// Example: "RGB.exe", "notepad.exe"
  /// Returns true if successful, false otherwise
  Future<bool> bringProcessToFront(String processName) async {
    try {
      _logger.i('[WindowManager] Bringing process to front: $processName');

      // Find window by process name
      final hwnd = _windowManagerFFI.findWindowByProcessName(processName);
      if (hwnd == null) {
        _logger.e(
          '[WindowManager] Process not found or has no visible window: $processName',
        );
        return false;
      }

      _logger.d('[WindowManager] Found window handle: $hwnd');

      // Bring to front
      final success = _windowManagerFFI.bringWindowToFront(hwnd);
      if (success) {
        _logger.i('[WindowManager] Successfully brought process to front');
      } else {
        _logger.e('[WindowManager] Failed to bring process to front');
      }

      return success;
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in bringProcessToFront',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Bring current application (SFACE DOCK) to foreground
  /// Returns true if successful, false otherwise
  Future<bool> bringCurrentAppToFront() async {
    try {
      _logger.i('[WindowManager] Bringing current app to front');

      final success = _windowManagerFFI.bringCurrentAppToFront();
      if (success) {
        _logger.i('[WindowManager] Successfully brought current app to front');
      } else {
        _logger.e('[WindowManager] Failed to bring current app to front');
      }

      return success;
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in bringCurrentAppToFront',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Check if a process is currently in the foreground
  /// Returns true if the process is in foreground, false otherwise
  Future<bool> isProcessInForeground(String processName) async {
    try {
      final hwnd = _windowManagerFFI.findWindowByProcessName(processName);
      if (hwnd == null) {
        return false;
      }

      return _windowManagerFFI.isWindowForeground(hwnd);
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in isProcessInForeground',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Find window handle by process name
  /// Returns window handle (HWND) if found, null otherwise
  int? findWindowByProcessName(String processName) {
    try {
      return _windowManagerFFI.findWindowByProcessName(processName);
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in findWindowByProcessName',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Minimize a process window by process name using PowerShell
  /// This can work even if the window has "Always On Top" setting
  /// Returns true if successful, false otherwise
  Future<bool> minimizeProcess(String processName) async {
    try {
      _logger.i(
        '[WindowManager] Minimizing process using PowerShell: $processName',
      );

      // PowerShell 명령어로 프로세스 최소화
      final result = await Process.run('powershell', [
        '-Command',
        '''
        \$process = Get-Process -Name "$processName" -ErrorAction SilentlyContinue
        if (\$process) {
          \$process.MainWindowHandle | ForEach-Object {
            if (\$_ -ne 0) {
              Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class Win32 {
                  [DllImport("user32.dll")]
                  public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
                }
"@
              [Win32]::ShowWindow(\$_, 6)  # SW_MINIMIZE = 6
            }
          }
        }
        ''',
      ]);

      if (result.exitCode == 0) {
        _logger.i(
          '[WindowManager] Successfully minimized process using PowerShell',
        );
        return true;
      } else {
        _logger.e(
          '[WindowManager] Failed to minimize process: ${result.stderr}',
        );
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in minimizeProcess',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Hide a process window by process name using PowerShell (more aggressive than minimize)
  /// This completely hides the window from taskbar and screen
  /// Returns true if successful, false otherwise
  Future<bool> hideProcess(String processName) async {
    try {
      _logger.i(
        '[WindowManager] Hiding process using PowerShell: $processName',
      );

      // PowerShell 명령어로 프로세스 숨기기
      final result = await Process.run('powershell', [
        '-Command',
        '''
        \$process = Get-Process -Name "$processName" -ErrorAction SilentlyContinue
        if (\$process) {
          \$process.MainWindowHandle | ForEach-Object {
            if (\$_ -ne 0) {
              Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class Win32 {
                  [DllImport("user32.dll")]
                  public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
                }
"@
              [Win32]::ShowWindow(\$_, 0)  # SW_HIDE = 0
            }
          }
        }
        ''',
      ]);

      if (result.exitCode == 0) {
        _logger.i('[WindowManager] Successfully hid process using PowerShell');
        return true;
      } else {
        _logger.e('[WindowManager] Failed to hide process: ${result.stderr}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in hideProcess',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Alt+Space+N으로 RGB 프로세스 최소화 (가장 효과적)
  /// Returns true if successful, false otherwise
  Future<bool> minimizeProcessWithAltSpace(String processName) async {
    try {
      _logger.i('[WindowManager] Alt+Space+N으로 프로세스 최소화 시도: $processName');

      // PowerShell 명령어로 Alt+Space+N 시뮬레이션
      final result = await Process.run('powershell', [
        '-Command',
        '''
        Add-Type -TypeDefinition @"
          using System;
          using System.Runtime.InteropServices;
          public class Win32 {
            [DllImport("user32.dll")]
            public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            [DllImport("user32.dll")]
            public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
          }
"@
        # RGB 프로세스를 최전방으로 가져오기
        \$process = Get-Process -Name "$processName" -ErrorAction SilentlyContinue
        if (\$process -and \$process.MainWindowHandle -ne 0) {
          [Win32]::SetForegroundWindow(\$process.MainWindowHandle)
          Start-Sleep -Milliseconds 200
          
          # Alt+Space 키 조합 시뮬레이션
          [Win32]::keybd_event(0x12, 0, 0, 0)  # Alt 키 누름
          Start-Sleep -Milliseconds 50
          [Win32]::keybd_event(0x20, 0, 0, 0)  # Space 키 누름
          Start-Sleep -Milliseconds 50
          [Win32]::keybd_event(0x20, 0, 2, 0)  # Space 키 뗌
          [Win32]::keybd_event(0x12, 0, 2, 0)  # Alt 키 뗌
          Start-Sleep -Milliseconds 300
          
          # N 키 누르기 (최소화)
          [Win32]::keybd_event(0x4E, 0, 0, 0)  # N 키 누름
          Start-Sleep -Milliseconds 50
          [Win32]::keybd_event(0x4E, 0, 2, 0)  # N 키 뗌
          
          Write-Output "SUCCESS"
        } else {
          Write-Output "PROCESS_NOT_FOUND"
        }
        ''',
      ]);

      if (result.exitCode == 0 &&
          result.stdout.toString().contains('SUCCESS')) {
        _logger.i('[WindowManager] Alt+Space+N 최소화 성공');
        return true;
      } else {
        _logger.e('[WindowManager] Alt+Space+N 최소화 실패: ${result.stderr}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in minimizeProcessWithAltSpace',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// 강제로 SFACE DOCK을 최전방으로 가져오기 (여러 방법 시도)
  /// Returns true if successful, false otherwise
  Future<bool> forceBringKioskToFront() async {
    try {
      _logger.i('[WindowManager] 강제로 SFACE DOCK을 최전방으로 가져오기 시도...');

      // 방법 1: kiosk.exe 직접 찾아서 포커스
      _logger.i('[WindowManager] 방법 1: kiosk.exe 직접 포커스 시도...');
      final focusResult = await Process.run('powershell', [
        '-Command',
        '''
        Add-Type -TypeDefinition @"
          using System;
          using System.Runtime.InteropServices;
          public class Win32 {
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            [DllImport("user32.dll")]
            public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
          }
"@
        \$kioskWindow = [Win32]::FindWindow([IntPtr]::Zero, "SFace Kiosk")
        if (\$kioskWindow -ne [IntPtr]::Zero) {
          [Win32]::ShowWindow(\$kioskWindow, 9)  # SW_RESTORE = 9
          [Win32]::SetForegroundWindow(\$kioskWindow)
          Write-Output "SUCCESS"
        } else {
          Write-Output "NOT_FOUND"
        }
        ''',
      ]);

      if (focusResult.exitCode == 0 &&
          focusResult.stdout.toString().contains('SUCCESS')) {
        _logger.i('[WindowManager] kiosk.exe 직접 포커스 성공');
        return true;
      }

      // 방법 2: 작업 표시줄 클릭으로 강제 전환
      _logger.i('[WindowManager] 방법 2: 작업 표시줄 클릭 시도...');
      final taskbarResult = await Process.run('powershell', [
        '-Command',
        '''
        Add-Type -TypeDefinition @"
          using System;
          using System.Runtime.InteropServices;
          public class Win32 {
            [DllImport("user32.dll")]
            public static extern bool SetCursorPos(int x, int y);
            [DllImport("user32.dll")]
            public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);
          }
"@
        # 화면 하단 중앙에 마우스 이동 후 클릭
        [Win32]::SetCursorPos(960, 1070)  # 화면 하단 중앙
        Start-Sleep -Milliseconds 100
        [Win32]::mouse_event(0x0002, 0, 0, 0, 0)  # 왼쪽 버튼 누름
        Start-Sleep -Milliseconds 50
        [Win32]::mouse_event(0x0004, 0, 0, 0, 0)  # 왼쪽 버튼 뗌
        ''',
      ]);

      if (taskbarResult.exitCode == 0) {
        _logger.i('[WindowManager] 작업 표시줄 클릭 성공');
        await Future.delayed(const Duration(milliseconds: 500));
        return true;
      }

      _logger.w('[WindowManager] 모든 강제 전환 방법 실패');
      return false;
    } catch (e, stackTrace) {
      _logger.e(
        '[WindowManager] Exception in forceBringKioskToFront',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
