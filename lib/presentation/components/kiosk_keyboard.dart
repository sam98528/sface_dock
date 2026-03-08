import 'package:flutter/material.dart';
import '../../core/input/hangul_composer.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../core/theme/kiosk_typography.dart';

/// Keyboard input mode.
enum KeyboardMode { korean, english, number }

/// Full-screen virtual keyboard for kiosk (Korean 2-beolsik, English QWERTY, Numbers).
class KioskKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final VoidCallback? onClose;
  final VoidCallback? onKeySound;
  final KeyboardMode initialMode;
  final int? maxLength;
  final bool forceUppercase;

  const KioskKeyboard({
    super.key,
    required this.controller,
    this.onSubmit,
    this.onClose,
    this.onKeySound,
    this.initialMode = KeyboardMode.korean,
    this.maxLength,
    this.forceUppercase = false,
  });

  @override
  State<KioskKeyboard> createState() => _KioskKeyboardState();
}

class _KioskKeyboardState extends State<KioskKeyboard> {
  late KeyboardMode _mode;
  bool _shift = false;
  final _hangul = HangulComposer();

  // Sync hangul composer with controller text
  bool _syncingText = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _hangul.setText(widget.controller.text);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (_syncingText) return;
    // External change to controller — sync hangul composer
    if (_mode == KeyboardMode.korean && widget.controller.text != _hangul.text) {
      _hangul.setText(widget.controller.text);
    }
  }

  void _updateController() {
    _syncingText = true;
    if (_mode == KeyboardMode.korean) {
      widget.controller.text = _hangul.text;
      widget.controller.selection = TextSelection.collapsed(
        offset: _hangul.text.length,
      );
    }
    _syncingText = false;
  }

  void _onKeyTap(String key) {
    // Max length check
    if (widget.maxLength != null &&
        widget.controller.text.length >= widget.maxLength!) {
      return;
    }

    widget.onKeySound?.call();

    setState(() {
      if (_mode == KeyboardMode.korean) {
        _hangul.addJamo(key);
        _updateController();
        if (_shift) _shift = false;
      } else {
        // English or number mode
        final text = widget.controller.text;
        final sel = widget.controller.selection;
        String insert;
        if (_mode == KeyboardMode.english) {
          insert = (_shift || widget.forceUppercase)
              ? key.toUpperCase()
              : key;
        } else {
          insert = key;
        }
        final newText = text.substring(0, sel.baseOffset) +
            insert +
            text.substring(sel.extentOffset);
        widget.controller.text = newText;
        widget.controller.selection = TextSelection.collapsed(
          offset: sel.baseOffset + insert.length,
        );
        if (_shift) _shift = false;
      }
    });
  }

  void _onBackspace() {
    widget.onKeySound?.call();
    setState(() {
      if (_mode == KeyboardMode.korean) {
        _hangul.backspace();
        _updateController();
      } else {
        final text = widget.controller.text;
        if (text.isNotEmpty) {
          widget.controller.text = text.substring(0, text.length - 1);
          widget.controller.selection = TextSelection.collapsed(
            offset: widget.controller.text.length,
          );
        }
      }
    });
  }

  void _onSpace() {
    widget.onKeySound?.call();
    setState(() {
      if (_mode == KeyboardMode.korean) {
        _hangul.commit();
        _hangul.setText('${_hangul.text} ');
        _updateController();
      } else {
        final text = widget.controller.text;
        widget.controller.text = '$text ';
        widget.controller.selection = TextSelection.collapsed(
          offset: widget.controller.text.length,
        );
      }
    });
  }

  void _onModeSwitch() {
    setState(() {
      if (_mode == KeyboardMode.korean) {
        _hangul.commit();
        _updateController();
        _mode = KeyboardMode.english;
      } else if (_mode == KeyboardMode.english) {
        _mode = KeyboardMode.korean;
        _hangul.setText(widget.controller.text);
      } else {
        _mode = KeyboardMode.korean;
        _hangul.setText(widget.controller.text);
      }
      _shift = false;
    });
  }

  void _onNumberSwitch() {
    setState(() {
      if (_mode == KeyboardMode.korean) {
        _hangul.commit();
        _updateController();
      }
      _mode = _mode == KeyboardMode.number
          ? KeyboardMode.korean
          : KeyboardMode.number;
      if (_mode == KeyboardMode.korean) {
        _hangul.setText(widget.controller.text);
      }
      _shift = false;
    });
  }

  void _onShift() {
    setState(() => _shift = !_shift);
  }

  void _onEnter() {
    if (_mode == KeyboardMode.korean) {
      _hangul.commit();
      _updateController();
    }
    widget.onSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: KioskColors.grey50,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: KioskColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: _buildLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayout() {
    switch (_mode) {
      case KeyboardMode.korean:
        return _buildKoreanLayout();
      case KeyboardMode.english:
        return _buildEnglishLayout();
      case KeyboardMode.number:
        return _buildNumberLayout();
    }
  }

  Widget _buildKoreanLayout() {
    final rows = _shift
        ? [
            ['ㅃ', 'ㅉ', 'ㄸ', 'ㄲ', 'ㅆ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅒ', 'ㅖ'],
            ['ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ'],
            ['ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ'],
          ]
        : [
            ['ㅂ', 'ㅈ', 'ㄷ', 'ㄱ', 'ㅅ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅐ', 'ㅔ'],
            ['ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ'],
            ['ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ'],
          ];

    return Column(
      children: [
        _buildKeyRow(rows[0]),
        const SizedBox(height: 10),
        _buildKeyRow(rows[1]),
        const SizedBox(height: 10),
        _buildKeyRowWithSides(
          left: _buildSpecialKey(
            label: _shift ? '⇧' : '⇪',
            onTap: _onShift,
            isActive: _shift,
            width: 80,
          ),
          keys: rows[2],
          right: _buildSpecialKey(
            icon: Icons.backspace_outlined,
            onTap: _onBackspace,
            width: 80,
          ),
        ),
        const SizedBox(height: 10),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildEnglishLayout() {
    final rows = _shift
        ? [
            ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
            ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
            ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
          ]
        : [
            ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
            ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
            ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
          ];

    return Column(
      children: [
        _buildKeyRow(rows[0]),
        const SizedBox(height: 10),
        _buildKeyRow(rows[1]),
        const SizedBox(height: 10),
        _buildKeyRowWithSides(
          left: _buildSpecialKey(
            label: _shift ? '⇧' : '⇪',
            onTap: _onShift,
            isActive: _shift,
            width: 80,
          ),
          keys: rows[2],
          right: _buildSpecialKey(
            icon: Icons.backspace_outlined,
            onTap: _onBackspace,
            width: 80,
          ),
        ),
        const SizedBox(height: 10),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildNumberLayout() {
    final rows = [
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
      ['-', '/', ':', ';', '(', ')', '\$', '&', '@', '"'],
      ['.', ',', '?', '!', "'", '#', '%', '+', '='],
    ];

    return Column(
      children: [
        _buildKeyRow(rows[0]),
        const SizedBox(height: 10),
        _buildKeyRow(rows[1]),
        const SizedBox(height: 10),
        _buildKeyRowWithSides(
          left: const SizedBox(width: 80),
          keys: rows[2],
          right: _buildSpecialKey(
            icon: Icons.backspace_outlined,
            onTap: _onBackspace,
            width: 80,
          ),
        ),
        const SizedBox(height: 10),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        _buildSpecialKey(
          label: _mode == KeyboardMode.number ? '가/A' : '123',
          onTap: _onNumberSwitch,
          width: 100,
        ),
        const SizedBox(width: 8),
        _buildSpecialKey(
          label: _mode == KeyboardMode.korean ? 'EN' : '한',
          onTap: _onModeSwitch,
          width: 80,
          isActive: true,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSpecialKey(
            label: '스페이스',
            onTap: _onSpace,
          ),
        ),
        const SizedBox(width: 8),
        _buildSpecialKey(
          label: '완료',
          onTap: _onEnter,
          width: 120,
          isActive: true,
        ),
        if (widget.onClose != null) ...[
          const SizedBox(width: 8),
          _buildSpecialKey(
            icon: Icons.keyboard_hide,
            onTap: widget.onClose!,
            width: 64,
          ),
        ],
      ],
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys
          .map((k) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _buildKey(k),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildKeyRowWithSides({
    required Widget left,
    required List<String> keys,
    required Widget right,
  }) {
    return Row(
      children: [
        left,
        const SizedBox(width: 8),
        ...keys.map((k) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _buildKey(k),
              ),
            )),
        const SizedBox(width: 8),
        right,
      ],
    );
  }

  Widget _buildKey(String label) {
    return GestureDetector(
      onTap: () => _onKeyTap(label),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: KioskColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KioskColors.grey100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: KioskTypography.fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: KioskColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey({
    String? label,
    IconData? icon,
    required VoidCallback onTap,
    double? width,
    bool isActive = false,
  }) {
    final bgColor = isActive ? KioskColors.primary : KioskColors.grey200;
    final fgColor = isActive ? Colors.white : KioskColors.textPrimary;

    final child = GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: fgColor, size: 26)
              : Text(
                  label ?? '',
                  style: TextStyle(
                    fontFamily: KioskTypography.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                  ),
                ),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return child;
  }
}
