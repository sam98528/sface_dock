// lib/widgets/phase_back_button.dart
//
// 세션 플로우에서 이전 단계로 이동. Attract·촬영 화면에는 이 위젯을 넣지 않음.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 뒤로가기 버튼.
/// onPressed 콜백이 제공되지 않으면 Navigator.pop 사용.
class PhaseBackButton extends ConsumerWidget {
  const PhaseBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      icon: const Icon(Icons.arrow_back),
      iconSize: 28,
      tooltip: '뒤로',
    );
  }
}
