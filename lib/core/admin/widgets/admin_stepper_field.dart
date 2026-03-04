// lib/screens/admin/widgets/admin_stepper_field.dart

import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';

/// 수량/숫자 입력용 스테퍼 — 감소/값/증가 버튼, min/max 적용.
class AdminStepperField extends StatelessWidget {
  const AdminStepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canDecrease = value > min;
    final canIncrease = value < max;

    const double touchSize = AdminTheme.kAdminTouchMinHeight;

    Widget buildButton(
      IconData? icon,
      String? text,
      bool enabled,
      VoidCallback onTap,
    ) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: text != null ? touchSize + 8 : touchSize,
            height: touchSize,
            child: Container(
              decoration: BoxDecoration(
                color: enabled
                    ? colorScheme.primary.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: enabled
                      ? colorScheme.primary.withValues(alpha: 0.6)
                      : colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(
                      icon,
                      size: 24,
                      color: enabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                    )
                  : Text(
                      text!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: enabled
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    final bool showTenStep = (max - min) >= 20;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (showTenStep) ...[
          buildButton(null, '-10', value - (step * 10) >= min, () {
            final nv = value - (step * 10);
            onChanged(nv < min ? min : nv);
          }),
          const SizedBox(width: 8),
        ],
        buildButton(
          Icons.remove,
          null,
          canDecrease,
          () => onChanged(value - step),
        ),
        const SizedBox(width: 12),
        Container(
          constraints: const BoxConstraints(minWidth: 56),
          height: touchSize,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        buildButton(
          Icons.add,
          null,
          canIncrease,
          () => onChanged(value + step),
        ),
        if (showTenStep) ...[
          const SizedBox(width: 8),
          buildButton(null, '+10', value + (step * 10) <= max, () {
            final nv = value + (step * 10);
            onChanged(nv > max ? max : nv);
          }),
        ],
      ],
    );
  }
}
