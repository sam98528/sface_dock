import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../../app/sfacedock_app.dart';
import '../../core/services/image_prefetch_service.dart';
import '../../core/theme/kiosk_colors.dart';

class SearchActionBar extends ConsumerWidget {
  const SearchActionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Navigator.of(context).pushNamed(homeRouteName);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
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
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },

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
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.only(right: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),

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
                ref.read(imagePrefetchProvider.notifier).resume();
              },
            ),
          ),

          const SizedBox(width: 16),

          // Settings Button
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
                Navigator.of(context).pushNamed(qrScannerRouteName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
