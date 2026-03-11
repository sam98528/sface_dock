import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/models/frame/layout_frame.dart';
import '../../data/models/kiosk/kiosk_photo.dart';
import '../providers/frame_provider.dart';

/// Result wrapper to distinguish cancel from confirmed selection.
class FrameSelectionResult {
  final LayoutFrame frame;
  const FrameSelectionResult(this.frame);
}

class FrameSelectionDialog extends ConsumerStatefulWidget {
  final KioskPhoto photo;

  const FrameSelectionDialog({super.key, required this.photo});

  @override
  ConsumerState<FrameSelectionDialog> createState() =>
      _FrameSelectionDialogState();
}

class _FrameSelectionDialogState extends ConsumerState<FrameSelectionDialog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final framesAsync = ref.watch(availableFramesProvider);
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        width: 1100,
        constraints: const BoxConstraints(maxHeight: 900),
        decoration: BoxDecoration(
          color: KioskColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
              child: Row(
                children: [
                  Text(
                    '프레임 선택',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: KioskColors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.playTapSound();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: KioskColors.grey50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: KioskColors.grey300,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '인쇄할 프레임을 선택해주세요',
                style: textTheme.bodyMedium?.copyWith(
                  color: KioskColors.grey300,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Frame grid
            Flexible(
              child: framesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: KioskColors.primary),
                ),
                error: (e, _) => Center(
                  child: Text(
                    '프레임을 불러오는 중 오류가 발생했습니다',
                    style: textTheme.bodyMedium?.copyWith(
                      color: KioskColors.error,
                    ),
                  ),
                ),
                data: (frames) {
                  if (frames.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_frames,
                              size: 64,
                              color: KioskColors.grey200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '사용 가능한 프레임이 없습니다',
                              style: textTheme.titleMedium?.copyWith(
                                color: KioskColors.grey300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Documents/custom/layout/ 폴더에\n프레임 이미지를 추가해주세요',
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                color: KioskColors.grey200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: LayoutConstants.canvasAspect,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: frames.length,
                      itemBuilder: (context, index) {
                        return _buildFrameCard(frames[index], index);
                      },
                    ),
                  );
                },
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 28),
              child: framesAsync.maybeWhen(
                data: (frames) => frames.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          context.playTapSound();
                          final selected = frames[_selectedIndex];
                          Navigator.of(
                            context,
                          ).pop(FrameSelectionResult(selected));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: KioskColors.primaryGradient,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: KioskColors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '선택 완료',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameCard(LayoutFrame frame, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        context.playTapSound();
        setState(() => _selectedIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? KioskColors.primary : KioskColors.grey100,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: KioskColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 13 : 15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Black canvas background
              Container(color: Colors.black),

              // Photo + Frame via LayoutBuilder
              LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;

                  return Stack(
                    children: [
                      // Photo placed in slot
                      Positioned(
                        left: LayoutConstants.slotLeftFrac * w,
                        top: LayoutConstants.slotTopFrac * h,
                        width: LayoutConstants.slotWFrac * w,
                        height: LayoutConstants.slotHFrac * h,
                        child: CachedNetworkImage(
                          cacheManager: KioskPhotoCacheManager.instance,
                          imageUrl: widget.photo.attachedMediaDisplayUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: KioskColors.grey50,
                            child: const Icon(
                              Icons.image,
                              color: KioskColors.grey200,
                            ),
                          ),
                        ),
                      ),

                      // Frame overlay
                      Positioned.fill(
                        child: Image.memory(
                          frame.imageBytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Selected check indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      gradient: KioskColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
