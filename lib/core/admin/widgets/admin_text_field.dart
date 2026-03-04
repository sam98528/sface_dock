// lib/screens/admin/widgets/admin_text_field.dart

import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';

/// 관리자 화면 텍스트 필드 — 라벨 + TextField (한 줄).
class AdminTextField extends StatefulWidget {
  const AdminTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.readOnly = false,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final bool readOnly;

  @override
  State<AdminTextField> createState() => _AdminTextFieldState();
}

class _AdminTextFieldState extends State<AdminTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant AdminTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 값이 외부에서 변경되었을 때 (예: 자동 탐지) 컨트롤러 업데이트
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AdminTheme.kAdminLabelWidth,
          child: Text(
            widget.label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AdminTheme.kAdminTouchMinHeight,
            ),
            child: TextField(
              readOnly: widget.readOnly,
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hint,
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
