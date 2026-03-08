import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import 'kiosk_keyboard.dart';

/// Manages showing/hiding a KioskKeyboard as an overlay at the bottom of the screen.
class KioskKeyboardOverlay {
  static OverlayEntry? _entry;
  static AnimationController? _animController;

  /// Whether the keyboard overlay is currently visible.
  static bool get isVisible => _entry != null;

  /// Show the keyboard overlay.
  static void show(
    BuildContext context, {
    required TextEditingController controller,
    VoidCallback? onSubmit,
    KeyboardMode initialMode = KeyboardMode.korean,
    int? maxLength,
    bool forceUppercase = false,
  }) {
    if (_entry != null) return;

    final overlay = Overlay.of(context);
    final vsync = Navigator.of(context);

    _animController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: vsync,
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController!,
      curve: Curves.easeOutCubic,
    ));

    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent barrier — tap to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: dismiss,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          // Keyboard
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: slideAnimation,
              child: Builder(
                builder: (ctx) => KioskKeyboard(
                  controller: controller,
                  initialMode: initialMode,
                  maxLength: maxLength,
                  forceUppercase: forceUppercase,
                  onKeySound: () => ctx.playKeyboardSound(),
                  onSubmit: () {
                    onSubmit?.call();
                    dismiss();
                  },
                  onClose: dismiss,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_entry!);
    _animController!.forward();
  }

  /// Dismiss the keyboard overlay with animation.
  static void dismiss() {
    if (_entry == null || _animController == null) return;

    _animController!.reverse().then((_) {
      _entry?.remove();
      _entry = null;
      _animController?.dispose();
      _animController = null;
    });
  }
}
