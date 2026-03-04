// lib/screens/admin/widgets/admin_color_field.dart

import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';

/// 관리자 화면 컬러 필드 — 라벨 + 색상 미리보기 + HEX 입력.
class AdminColorField extends StatelessWidget {
  const AdminColorField({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SizedBox(
          width: AdminTheme.kAdminLabelWidth,
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => _showColorPicker(context),
          child: Container(
            width: AdminTheme.kAdminTouchMinHeight,
            height: AdminTheme.kAdminTouchMinHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 120,
          child: _HexInput(color: color, onColorChanged: onColorChanged),
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    Color current = color;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: SingleChildScrollView(
          child: ColorPicker(
            color: current,
            onColorChanged: (c) => current = c,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              onColorChanged(current);
              Navigator.of(ctx).pop();
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }
}

/// HEX 문자열 입력 — 컬러 변경 시 동기화.
class _HexInput extends StatefulWidget {
  const _HexInput({required this.color, required this.onColorChanged});

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  State<_HexInput> createState() => _HexInputState();
}

class _HexInputState extends State<_HexInput> {
  late TextEditingController _controller;
  static String _toHex(Color c) {
    return '#${c.red.toRadixString(16).padLeft(2, '0')}'
        '${c.green.toRadixString(16).padLeft(2, '0')}'
        '${c.blue.toRadixString(16).padLeft(2, '0')}';
  }

  static Color? _fromHex(String s) {
    s = s.trim().replaceFirst(RegExp(r'^#'), '');
    if (s.length != 6) return null;
    final r = int.tryParse(s.substring(0, 2), radix: 16);
    final g = int.tryParse(s.substring(2, 4), radix: 16);
    final b = int.tryParse(s.substring(4, 6), radix: 16);
    if (r == null || g == null || b == null) return null;
    return Color.fromARGB(255, r, g, b);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _toHex(widget.color));
  }

  @override
  void didUpdateWidget(covariant _HexInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _controller.text = _toHex(widget.color);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      height: AdminTheme.kAdminTouchMinHeight,
      child: TextField(
        controller: _controller,
        onSubmitted: (v) {
          final c = _fromHex(v);
          if (c != null) widget.onColorChanged(c);
        },
        decoration: InputDecoration(
          hintText: '#000000',
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// 간단한 색상 선택 위젯 (Material 기본 제공 없음 — 슬라이더로 RGB).
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late int _r;
  late int _g;
  late int _b;

  @override
  void initState() {
    super.initState();
    _r = widget.color.red;
    _g = widget.color.green;
    _b = widget.color.blue;
  }

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _r = widget.color.red;
      _g = widget.color.green;
      _b = widget.color.blue;
    }
  }

  void _emit() {
    widget.onColorChanged(Color.fromARGB(255, _r, _g, _b));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, _r, _g, _b),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'R',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Slider(
                value: _r / 255,
                onChanged: (v) => setState(() {
                  _r = (v * 255).round();
                  _emit();
                }),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'G',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Slider(
                value: _g / 255,
                onChanged: (v) => setState(() {
                  _g = (v * 255).round();
                  _emit();
                }),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'B',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Slider(
                value: _b / 255,
                onChanged: (v) => setState(() {
                  _b = (v * 255).round();
                  _emit();
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
