import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/frame/layout_frame.dart';

class LayoutFrameService {
  static const _customFolder = 'custom';
  static const _layoutFolder = 'layout';
  static const _imageExtensions = ['png', 'jpg', 'jpeg', 'webp'];

  /// Ensures Documents/custom/layout/ exists.
  Future<void> ensureCustomDirectory() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final layoutDir = Directory(
        p.join(docsDir.path, _customFolder, _layoutFolder),
      );
      if (!await layoutDir.exists()) {
        await layoutDir.create(recursive: true);
      }
    } catch (e) {
      debugPrint('[LayoutFrameService] ensureCustomDirectory error: $e');
    }
  }

  /// Scans Documents/custom/layout/ for frame PNG files.
  Future<List<LayoutFrame>> scanFrames() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final layoutDir = Directory(
        p.join(docsDir.path, _customFolder, _layoutFolder),
      );
      if (!await layoutDir.exists()) return [];

      final files = await layoutDir
          .list(recursive: false)
          .where((e) => e is File)
          .cast<File>()
          .toList();

      final frames = <LayoutFrame>[];
      for (final file in files) {
        final ext =
            p.extension(file.path).toLowerCase().replaceFirst('.', '');
        if (!_imageExtensions.contains(ext)) continue;

        final basename = p.basenameWithoutExtension(file.path);
        final displayName = _extractDisplayName(basename);

        Uint8List? bytes;
        try {
          bytes = await file.readAsBytes();
        } catch (e) {
          debugPrint(
              '[LayoutFrameService] Failed to read ${file.path}: $e');
          continue;
        }

        frames.add(LayoutFrame(
          displayName: displayName,
          imagePath: file.path,
          imageBytes: bytes,
        ));
      }
      frames.sort((a, b) => a.imagePath.compareTo(b.imagePath));
      return frames;
    } catch (e) {
      debugPrint('[LayoutFrameService] scanFrames error: $e');
      return [];
    }
  }

  /// Extract display name from filename.
  /// Strips "1cut_vertical" prefix if present, otherwise uses full basename.
  String _extractDisplayName(String basename) {
    var name = basename;
    // Remove known layout prefix if present
    if (name.startsWith('1cut_vertical')) {
      name = name.replaceFirst('1cut_vertical', '').trim();
    }
    if (name.startsWith('_')) name = name.substring(1).trim();
    if (name.startsWith('-')) name = name.substring(1).trim();
    return name.isEmpty ? basename : name;
  }
}
