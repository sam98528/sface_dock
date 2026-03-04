// lib/widgets/design_system/kiosk_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// 키오스크 카드. Theme.of(context).colorScheme 기반으로 어드민 배경/표면 색이 반영됨.
class KioskCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isGlass;
  final Color? backgroundColor;
  final Border? border;

  const KioskCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.isGlass = false,
    this.backgroundColor,
    this.border,
  });

  static const double _radius = 24;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final surface = scheme.surface;
    final surfaceHighlight = scheme.surfaceContainerHighest;

    if (isGlass) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: _buildContainer(
            context,
            color: (backgroundColor ?? surfaceHighlight).withValues(alpha: 0.5),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            hasBorder: true,
          ),
        ),
      );
    }

    return _buildContainer(context, color: backgroundColor ?? surface);
  }

  Widget _buildContainer(
    BuildContext context, {
    Color? color,
    Gradient? gradient,
    bool hasBorder = false,
  }) {
    final borderValue =
        border ??
        (hasBorder
            ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1)
            : null);

    return Container(
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(_radius),
        border: borderValue,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
