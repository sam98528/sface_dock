#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <tlhelp32.h>
#include <string>

#include "flutter_window.h"
#include "utils.h"

// Check if the service is already running
bool IsServiceRunning(const wchar_t* processName) {
    bool exists = false;
    PROCESSENTRY32W entry;
    entry.dwSize = sizeof(PROCESSENTRY32W);

    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, NULL);
    if (Process32FirstW(snapshot, &entry)) {
        while (Process32NextW(snapshot, &entry)) {
            if (_wcsicmp(entry.szExeFile, processName) == 0) {
                exists = true;
                break;
            }
        }
    }
    CloseHandle(snapshot);
    return exists;
}

// Automatically start background service
void StartDeviceControllerService() {
    if (IsServiceRunning(L"FutureFrame Service.exe")) return;

    wchar_t exe_path[MAX_PATH];
    GetModuleFileNameW(nullptr, exe_path, MAX_PATH);
    std::wstring path(exe_path);
    size_t last_slash = path.find_last_of(L"\\/");
    if (last_slash != std::wstring::npos) {
        std::wstring dir = path.substr(0, last_slash);
        // Production path: ..\DeviceControllerService\FutureFrame Service.exe
        std::wstring service_path = dir + L"\\..\\DeviceControllerService\\FutureFrame Service.exe";
        
        if (GetFileAttributesW(service_path.c_str()) != INVALID_FILE_ATTRIBUTES) {
            STARTUPINFOW si = { sizeof(STARTUPINFOW) };
            PROCESS_INFORMATION pi;
            if (CreateProcessW(service_path.c_str(), nullptr, nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, nullptr, &si, &pi)) {
                CloseHandle(pi.hProcess);
                CloseHandle(pi.hThread);
            }
        } else {
            // Development path (from sfacedock)
            std::wstring dev_service_path = dir + L"\\..\\..\\..\\..\\..\\device-controller-service-kiosk\\out\\build\\x86-Release-Static\\bin\\FutureFrame Service.exe";
            if (GetFileAttributesW(dev_service_path.c_str()) != INVALID_FILE_ATTRIBUTES) {
                STARTUPINFOW si = { sizeof(STARTUPINFOW) };
                PROCESS_INFORMATION pi;
                if (CreateProcessW(dev_service_path.c_str(), nullptr, nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, nullptr, &si, &pi)) {
                    CloseHandle(pi.hProcess);
                    CloseHandle(pi.hThread);
                }
            }
        }
    }
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Start the background service automatically if not running
  StartDeviceControllerService();

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"sfacedock", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
