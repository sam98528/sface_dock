// lib/core/session/services/session_photo_storage_service.dart
//
// Session photo storage utilities

import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Get the path to the product.jpg file for a session.
///
/// Returns the full path to the product image file, or null if not found.
Future<String?> getProductFilePath(String sessionId) async {
  try {
    final documentsDir = await getApplicationDocumentsDirectory();
    final sessionDir = Directory('${documentsDir.path}/sessions/$sessionId');

    if (!sessionDir.existsSync()) {
      return null;
    }

    final productFile = File('${sessionDir.path}/product.jpg');
    if (productFile.existsSync()) {
      return productFile.path;
    }

    return null;
  } catch (e) {
    return null;
  }
}

/// Clean up session folder, keeping only product.jpg
Future<void> cleanupSessionFolder(String sessionId) async {
  try {
    final documentsDir = await getApplicationDocumentsDirectory();
    final sessionDir = Directory('${documentsDir.path}/sessions/$sessionId');

    if (!sessionDir.existsSync()) {
      return;
    }

    final productFile = File('${sessionDir.path}/product.jpg');
    final productExists = productFile.existsSync();

    // Delete all files except product.jpg
    await for (final entity in sessionDir.list()) {
      if (entity is File && entity.path != productFile.path) {
        try {
          await entity.delete();
        } catch (_) {}
      }
    }

    // If no product.jpg exists, delete the entire folder
    if (!productExists) {
      try {
        await sessionDir.delete(recursive: true);
      } catch (_) {}
    }
  } catch (_) {}
}
