// lib/widgets/design_system/kiosk_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/kiosk_typography.dart';

/// 메인 CTA 표준 규격 (어드민 테마 반영, 위치/크기 통일용).
const double kKioskButtonHeight = 56;
const double kKioskButtonMinWidth = 280;
const double kKioskButtonRadius = 14;

enum KioskButtonStyle { primary, secondary, outline }

/// 키오스크 공통 버튼. Theme.of(context).colorScheme 기반으로 어드민 색상이 반영됨.
/// 메인 액션은 height 56, minWidth 280 규격으로 통일.
class KioskButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final KioskButtonStyle style;
  final IconData? icon;
  final double? iconSize;
  final bool isLoading;
  final double? width;
  final double height;

  const KioskButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = KioskButtonStyle.primary,
    this.icon,
    this.iconSize,
    this.isLoading = false,
    this.width,
    this.height = kKioskButtonHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final surfaceHighlight = scheme.surfaceContainerHighest;
    final outlineColor = scheme.outline;

    LinearGradient? gradient;
    List<BoxShadow>? boxShadow;
    Color? bgColor;
    Border? border;

    switch (style) {
      case KioskButtonStyle.primary:
        gradient = LinearGradient(
          colors: [primary, primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        boxShadow = [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
        break;
      case KioskButtonStyle.secondary:
        bgColor = surfaceHighlight;
        break;
      case KioskButtonStyle.outline:
        border = Border.all(color: outlineColor);
        break;
    }

    final textColor = _getTextColor(context);

    final constraints = BoxConstraints(
      minWidth: width ?? kKioskButtonMinWidth,
      minHeight: height,
      maxWidth: width != null ? width! : double.infinity,
      maxHeight: height,
    );

    return ConstrainedBox(
      constraints: constraints,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kKioskButtonRadius),
          gradient: gradient,
          boxShadow: boxShadow,
          color: bgColor,
          border: border,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || onPressed == null) ? null : onPressed,
            borderRadius: BorderRadius.circular(kKioskButtonRadius),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: textColor, size: iconSize ?? 26),
                          const SizedBox(width: 8),
                        ],
                        if (text.isNotEmpty)
                          Text(
                            text,
                            style: KioskTypography.textTheme.titleMedium
                                ?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
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

  /// 메인 CTA용 고정 높이 (규격 통일).
  static double get mainButtonHeight => kKioskButtonHeight;

  /// 메인 CTA용 최소 너비 (규격 통일).
  static double get mainButtonMinWidth => kKioskButtonMinWidth;

  Color _getTextColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (style) {
      case KioskButtonStyle.primary:
        return scheme.onPrimary;
      case KioskButtonStyle.secondary:
        return scheme.onSurface;
      case KioskButtonStyle.outline:
        return scheme.onSurfaceVariant;
    }
  }
}
