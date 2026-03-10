import 'dart:typed_data';

class LayoutFrame {
  final String displayName;
  final String imagePath;
  final Uint8List imageBytes;

  const LayoutFrame({
    required this.displayName,
    required this.imagePath,
    required this.imageBytes,
  });
}
