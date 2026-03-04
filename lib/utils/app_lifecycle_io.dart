// lib/utils/app_lifecycle_io.dart

import 'dart:io';

void exitApp() {
  exit(0);
}

void restartApp() {
  Process.start(Platform.executable, Platform.executableArguments);
  exit(0);
}
