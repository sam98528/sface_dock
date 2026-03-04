// lib/screens/admin/widgets/admin_switch_field.dart

import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';

/// 관리자 화면 스위치 필드 — 라벨 + Switch (터치 최소 높이 48dp).
class AdminSwitchField extends StatelessWidget {
  const AdminSwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AdminTheme.kAdminTouchMinHeight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
            activeThumbColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
