import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../../app/sfacedock_app.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../core/theme/kiosk_typography.dart';
import 'kiosk_keyboard_overlay.dart';

class SearchActionBar extends ConsumerStatefulWidget {
  const SearchActionBar({super.key});

  @override
  ConsumerState<SearchActionBar> createState() => _SearchActionBarState();
}

class _SearchActionBarState extends ConsumerState<SearchActionBar> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
      setState(() {}); // rebuild for clear button visibility
    });
  }

  @override
  void dispose() {
    KioskKeyboardOverlay.dismiss();
    _searchController.dispose();
    super.dispose();
  }

  static const _sortLabels = <PhotoSortOption, String>{
    PhotoSortOption.newest: '최신순',
    PhotoSortOption.oldest: '오래된순',
    PhotoSortOption.mostLiked: '좋아요 많은순',
  };

  List<Widget> _buildSortChips() {
    final current = ref.watch(photoSortOptionProvider);
    return PhotoSortOption.values.map((option) {
      final isSelected = current == option;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: GestureDetector(
          onTap: () {
            context.playTapSound();
            ref.read(photoSortOptionProvider.notifier).state = option;
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? KioskColors.primary : KioskColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? KioskColors.primary
                    : KioskColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                _sortLabels[option]!,
                style: TextStyle(
                  fontFamily: KioskTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : KioskColors.primary,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _toggleKeyboard() {
    if (KioskKeyboardOverlay.isVisible) {
      KioskKeyboardOverlay.dismiss();
    } else {
      KioskKeyboardOverlay.show(
        context,
        controller: _searchController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            KioskColors.grey400.withValues(alpha: 0.7),
            KioskColors.grey400.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
            decoration: BoxDecoration(
              color: KioskColors.surface,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                context.playTapSound();
                KioskKeyboardOverlay.dismiss();
                Navigator.of(context).pushNamed(homeRouteName);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chevron_left,
                    color: KioskColors.primary,
                    size: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '처음으로',
                      style: textTheme.titleMedium?.copyWith(
                        color: KioskColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Search Bar
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: _toggleKeyboard,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: KioskColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: KioskColors.primary.withValues(alpha: 0.7),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: TextField(
                      controller: _searchController,
                      readOnly: true,
                      showCursor: true,
                      onTap: _toggleKeyboard,
                      textAlignVertical: TextAlignVertical.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: KioskColors.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: '검색어를 입력해 주세요...',
                        hintStyle: textTheme.titleMedium?.copyWith(
                          color: KioskColors.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: KioskColors.primary.withValues(alpha: 0.7),
                          size: 32,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: KioskColors.primary.withValues(alpha: 0.7),
                                  size: 24,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(right: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Sort Chips
          ..._buildSortChips(),

          const Spacer(flex: 1),

          // Refresh Button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: KioskColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: KioskColors.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: KioskColors.primary,
                size: 32,
              ),
              onPressed: () {
                context.playTapSound();
                ref.read(imagePrefetchProvider.notifier).forceSync();
              },
            ),
          ),

          const SizedBox(width: 16),

          // QR Scanner Button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: KioskColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: KioskColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.white, size: 32),
              onPressed: () {
                context.playTapSound();
                KioskKeyboardOverlay.dismiss();
                Navigator.of(context).pushNamed(qrScannerRouteName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
