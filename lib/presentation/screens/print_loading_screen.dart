import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:sfacedock/app/sfacedock_app.dart';
import 'package:sfacedock/core/admin/controllers/admin_controller.dart';
import 'package:sfacedock/core/constants/layout_constants.dart';
import 'package:sfacedock/core/device/services/device_service_providers.dart';
import 'package:sfacedock/core/theme/kiosk_colors.dart';
import 'package:sfacedock/core/transitions/slide_animation_widget.dart';
import 'package:sfacedock/presentation/providers/cart_provider.dart';
import 'package:shimmer/shimmer.dart';

class PrintLoadingScreen extends ConsumerStatefulWidget {
  const PrintLoadingScreen({super.key});

  @override
  ConsumerState<PrintLoadingScreen> createState() => _PrintLoadingScreenState();
}

class _PrintLoadingScreenState extends ConsumerState<PrintLoadingScreen> {
  int _printed = 0;
  int _totalPrints = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printAllItems();
    });
  }

  /// Composite photo onto canvas with frame overlay, applying print margins.
  Future<String> _compositeWithFrame(
    File sourceFile,
    Uint8List frameBytes,
    String outputPath,
  ) async {
    // Admin 설정에서 마진 값 가져오기
    final admin = ref.read(adminControllerProvider);
    final marginV = admin.printerMarginV; // 상하 마진

    // 마진이 적용된 실제 캔버스 크기 계산
    final canvasW = LayoutConstants.canvasW;
    final canvasH = LayoutConstants.canvasH - (marginV * 2); // 상하 마진 적용

    // 마진이 적용된 슬롯 위치 계산
    final slotLeft = LayoutConstants.slotLeft;
    final slotTop = LayoutConstants.slotTop - marginV; // 상단 마진 조정
    final slotW = LayoutConstants.slotW;
    final slotH = LayoutConstants.slotH;
    final sourceBytes = await sourceFile.readAsBytes();
    final photo = img.decodeImage(sourceBytes);
    if (photo == null) throw Exception('Failed to decode image');

    // 1. Create black canvas with margin applied
    final canvas = img.Image(width: canvasW, height: canvasH);
    img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 255));

    // 2. Cover-fit photo into slot (crop to fill)
    final resized = _coverFit(photo, slotW, slotH);

    // 3. Place photo in slot with margin adjustment
    img.compositeImage(canvas, resized, dstX: slotLeft, dstY: slotTop);

    // 4. Overlay frame PNG (scale to canvas size with margins)
    final frame = img.decodeImage(frameBytes);
    if (frame != null) {
      final scaledFrame = (frame.width != canvasW || frame.height != canvasH)
          ? img.copyResize(frame, width: canvasW, height: canvasH)
          : frame;
      img.compositeImage(canvas, scaledFrame, dstX: 0, dstY: 0);
    }

    // 5. Encode and save as JPEG with maximum quality
    final jpegBytes = img.encodeJpg(canvas, quality: 100);
    await File(outputPath).writeAsBytes(jpegBytes);
    return outputPath;
  }

  /// Composite photo onto canvas without frame (fallback), applying print margins.
  Future<String> _compositeNoFrame(File sourceFile, String outputPath) async {
    // Admin 설정에서 마진 값 가져오기
    final admin = ref.read(adminControllerProvider);
    final marginV = admin.printerMarginV; // 상하 마진

    // 마진이 적용된 실제 캔버스 크기와 슬롯 위치 계산
    final canvasW = LayoutConstants.canvasW;
    final canvasH = LayoutConstants.canvasH - (marginV * 2);
    final slotLeft = LayoutConstants.slotLeft;
    final slotTop = LayoutConstants.slotTop - marginV;
    final slotW = LayoutConstants.slotW;
    final slotH = LayoutConstants.slotH;

    final sourceBytes = await sourceFile.readAsBytes();
    final photo = img.decodeImage(sourceBytes);
    if (photo == null) throw Exception('Failed to decode image');

    final canvas = img.Image(width: canvasW, height: canvasH);
    img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 255));

    final resized = _coverFit(photo, slotW, slotH);
    img.compositeImage(canvas, resized, dstX: slotLeft, dstY: slotTop);

    final jpegBytes = img.encodeJpg(canvas, quality: 100);
    await File(outputPath).writeAsBytes(jpegBytes);
    return outputPath;
  }

  /// Cover-fit: resize to cover entire target, crop center if needed.
  img.Image _coverFit(img.Image src, int targetW, int targetH) {
    final srcAspect = src.width / src.height;
    final tgtAspect = targetW / targetH;

    int newW, newH;
    if (srcAspect > tgtAspect) {
      // Source is wider - fit height and crop width
      newH = targetH;
      newW = (targetH * srcAspect).round();
    } else {
      // Source is taller - fit width and crop height
      newW = targetW;
      newH = (targetW / srcAspect).round();
    }

    // Resize image to cover the target area with high quality interpolation
    final resized = img.copyResize(src, width: newW, height: newH,
        interpolation: img.Interpolation.cubic);

    // Crop to target dimensions from center
    final offsetX = ((newW - targetW) / 2).round();
    final offsetY = ((newH - targetH) / 2).round();

    return img.copyCrop(resized,
      x: offsetX,
      y: offsetY,
      width: targetW,
      height: targetH,
    );
  }

  Future<void> _printAllItems() async {
    final items = ref.read(cartProvider).items;
    final printer = ref.read(printerServiceProvider);
    final waitSec = ref.read(adminControllerProvider).printWaitDurationSeconds;

    // Calculate total prints (each item x quantity)
    int totalPrints = 0;
    for (final item in items) {
      totalPrints += item.quantity;
    }

    setState(() {
      _totalPrints = totalPrints;
      _printed = 0;
    });

    if (totalPrints == 0) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(completionRouteName);
      }
      return;
    }

    final cacheManager = DefaultCacheManager();
    final tempDir = await getTemporaryDirectory();

    try {
      for (final item in items) {
        // Download original quality image for printing
        final imageUrl = item.photoData.originalImageUrl;
        final cachedFile = await cacheManager.getSingleFile(imageUrl);

        // Composite with frame (or without if no frame selected)
        final outputPath = '${tempDir.path}/print_${item.feedsIdx}_framed.jpg';
        final String printFilePath;
        if (item.selectedFrameBytes != null) {
          printFilePath = await _compositeWithFrame(
            cachedFile,
            item.selectedFrameBytes!,
            outputPath,
          );
        } else {
          printFilePath = await _compositeNoFrame(cachedFile, outputPath);
        }

        for (int q = 0; q < item.quantity; q++) {
          final jobId = 'print_${item.feedsIdx}_$q';

          try {
            await printer.print(jobId: jobId, filePath: printFilePath);
          } catch (e) {
            debugPrint('Print job $jobId failed: $e');
          }

          // Wait for printer to finish this page
          await Future.delayed(Duration(seconds: waitSec));

          if (!mounted) return;
          setState(() {
            _printed++;
          });
        }
      }

      // Clean up temp framed files
      for (final item in items) {
        try {
          final f = File('${tempDir.path}/print_${item.feedsIdx}_framed.jpg');
          if (await f.exists()) await f.delete();
        } catch (_) {}
      }

      // All done - navigate to completion screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(completionRouteName);
      }
    } catch (e) {
      debugPrint('Print process error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(64),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
              colors: [Color(0xFFFFBFE9), Color(0xFFDEBAF6), Color(0xFFA3F0E2)],
            ),
          ),
          child: Center(
            child: _errorMessage != null
                ? _buildErrorContent(textTheme)
                : SlideAnimationWidget(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Printer icon with progress
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.print_rounded,
                            size: 56,
                            color: KioskColors.primary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Shimmer.fromColors(
                          baseColor: KioskColors.tertiary,
                          highlightColor: KioskColors.primary.withValues(
                            alpha: 0.9,
                          ),
                          period: const Duration(milliseconds: 3000),
                          direction: ShimmerDirection.ltr,
                          child: Text(
                            '사진을 인쇄하고 있습니다...',
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Progress indicator
                        if (_totalPrints > 0) ...[
                          SizedBox(
                            width: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _totalPrints > 0
                                    ? _printed / _totalPrints
                                    : 0,
                                minHeight: 12,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.5,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  KioskColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$_printed / $_totalPrints 장 인쇄 완료',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          '잠시만 기다려 주세요. 인쇄가 끝나면 자동으로 이동합니다.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(TextTheme textTheme) {
    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: KioskColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: KioskColors.error,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '인쇄 중 오류가 발생했습니다',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? '',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(introRouteName, (_) => false);
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: KioskColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '처음으로 돌아가기',
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
