import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design_system/kiosk_header.dart';

/// 단계 화면 공통 스캐폴드. 배경색·상단바(뒤로가기+타이틀)·본문 영역 통일.
class PhaseScreenLayout extends ConsumerWidget {
  const PhaseScreenLayout({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.title,
    this.titleString,
    this.onBack,
  });

  /// 본문. 상단바 아래 Expanded 영역.
  final Widget body;

  /// 뒤로가기 버튼 표시 여부. 결제 후(Printing/Finished) 등에서는 false.
  final bool showBackButton;

  /// 상단바 타이틀 위젯. titleString 과 동시에 주면 title 우선.
  final Widget? title;

  /// 상단바 타이틀 문자열. AppText.screenTitle 스타일로 표시.
  final String? titleString;

  /// 뒤로가기 버튼 콜백. 제공되지 않으면 Navigator.pop 사용.
  final VoidCallback? onBack;

  void _handleBack(BuildContext context) {
    if (!showBackButton) return;
    if (onBack != null) {
      onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            KioskHeader(
              title: titleString ?? '',
              onBack: showBackButton ? () => _handleBack(context) : null,
            ),
            // If specific 'title' widget was passed (rare), we can append it
            if (title != null && titleString == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: title!,
              ),

            Expanded(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
