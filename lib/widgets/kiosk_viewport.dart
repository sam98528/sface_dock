// lib/widgets/kiosk_viewport.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 창 크기는 1920x1080 고정. 내용은 항상 해당 클라이언트 영역을 꽉 채움.
/// MediaQuery 크기를 1920x1080으로 고정해 레이아웃이 일정하게 나오도록 함.
class KioskViewport extends ConsumerWidget {
  const KioskViewport({super.key, required this.child});

  static const double width = 1920;
  static const double height = 1080;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(size: Size(width, height)),
        child: child,
      ),
    );
  }
}
