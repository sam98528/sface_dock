// lib/screens/admin/widgets/admin_hardware_section.dart

import 'package:flutter/material.dart';
import 'admin_section_card.dart';
import 'admin_stepper_field.dart';
import 'admin_dropdown_field.dart';
import 'admin_switch_field.dart';
import 'admin_text_field.dart';

/// 상태 문자열(READY 등)에 따른 표시 라벨
String _statusLabel(String? stateString) {
  if (stateString == null || stateString.isEmpty) return '장비 연결 확인 필요';
  switch (stateString.toUpperCase()) {
    case 'READY':
      return '정상 작동 중';
    case 'DISCONNECTED':
      return '연결 끊김';
    case 'ERROR':
    case 'HUNG':
      return '오류';
    case 'CONNECTING':
    case 'PROCESSING':
      return stateString;
    default:
      return stateString;
  }
}

/// 상태에 따른 색 (초록=정상, 빨강=오류/끊김, 회색=장비 미연결)
Color _statusColor(BuildContext context, String? stateString) {
  if (stateString == null || stateString.isEmpty) {
    return Theme.of(context).colorScheme.outline;
  }
  switch (stateString.toUpperCase()) {
    case 'READY':
      return Colors.green.shade600;
    case 'DISCONNECTED':
    case 'ERROR':
    case 'HUNG':
      return Colors.red.shade600;
    default:
      return Theme.of(context).colorScheme.outline;
  }
}

/// 카드 헤더용 상태 표시 (점 + 텍스트)
Widget _buildStatusTrailing(BuildContext context, String? status) {
  final theme = Theme.of(context);
  final color = _statusColor(context, status);
  final label = _statusLabel(status);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

bool _isReady(String? stateString) {
  return stateString != null && stateString.toUpperCase() == 'READY';
}

/// 결제 수단 카드용: 둘 다 정상 → "정상 작동 중", 하나라도 이상 → 어떤 게 안 되는지 표시, 둘 다 이상 → "둘 다 오류" + 상세
Widget _buildPaymentCashTrailing(
  BuildContext context, {
  required bool paymentEnabled,
  required bool cashEnabled,
  String? paymentStatus,
  String? cashStatus,
}) {
  final theme = Theme.of(context);

  // 둘 다 사용 안 함
  if (!paymentEnabled && !cashEnabled) {
    return Text(
      '미사용',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.outline,
      ),
    );
  }

  // 사용 중인 것들만 봤을 때 둘 다 정상
  final anyPayment = paymentEnabled;
  final anyCash = cashEnabled;
  if (anyPayment &&
      anyCash &&
      _isReady(paymentStatus) &&
      _isReady(cashStatus)) {
    return _buildStatusTrailing(context, 'READY');
  }

  // 하나만 사용 켜져 있고 그게 정상
  if (anyPayment && !anyCash && _isReady(paymentStatus)) {
    return _buildStatusTrailing(context, 'READY');
  }
  if (!anyPayment && anyCash && _isReady(cashStatus)) {
    return _buildStatusTrailing(context, 'READY');
  }

  // 둘 다 사용 켜져 있는데 둘 다 이상
  if (anyPayment &&
      anyCash &&
      !_isReady(paymentStatus) &&
      !_isReady(cashStatus)) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '둘 다 오류 — 결제 단말기: ${_statusLabel(paymentStatus)}, 현금결제기: ${_statusLabel(cashStatus)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 하나만 이상한 경우: 어떤 게 안 되는지만 표시
  final failing = <Widget>[];
  if (anyPayment && !_isReady(paymentStatus)) {
    failing.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '결제 단말기: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          _buildStatusTrailing(context, paymentStatus),
        ],
      ),
    );
  }
  if (anyCash && !_isReady(cashStatus)) {
    if (failing.isNotEmpty) failing.add(const SizedBox(width: 12));
    failing.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '현금결제기: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          _buildStatusTrailing(context, cashStatus),
        ],
      ),
    );
  }

  return Row(mainAxisSize: MainAxisSize.min, children: failing);
}

/// 하드웨어 설정 — 카메라, 프린터, 결제 수단.
class AdminHardwareSection extends StatelessWidget {
  const AdminHardwareSection({
    super.key,
    required this.cameraModel,
    required this.cameraComIndex,
    required this.onCameraModelChanged,
    required this.onCameraComChanged,
    required this.comPorts,
    this.cameraStatus,
    // 프린터
    required this.printerModel,
    required this.availablePrinters,
    required this.onPrinterModelChanged,
    required this.printerPaperSize,
    required this.onPrinterPaperSizeChanged,
    required this.printerPaperRemaining,
    required this.onPrinterPaperRemainingChanged,
    required this.onPrinterPaperReset,
    required this.printerMarginH,
    required this.printerMarginV,
    required this.onPrinterMarginHChanged,
    required this.onPrinterMarginVChanged,
    required this.onTestPrint,
    this.onPrintSessionProduct,
    this.printerStatus,
    // 결제 (COM 포트는 백엔드 자동 인식, 사용 여부 + 작동 상태만 표시)
    required this.paymentTerminalEnabled,
    required this.onPaymentTerminalEnabledChanged,
    required this.cashDeviceEnabled,
    required this.onCashDeviceEnabledChanged,
    this.paymentStatus,
    this.cashStatus,
    required this.onAutoDetect,
    this.isAutoDetecting = false,
    this.isDebugMode = false,
    this.cashTestAmount = 0,
    this.onCashTestStart,
    this.onCashTestStop,
    this.cashPaymentRequested = 0,
    this.cashPaymentCurrent = 0,
    this.cashPaymentTargetReached = false,
    this.cashPaymentPresetIndex = 0,
    this.onCashPaymentPresetChanged,
    this.onCashPaymentRequest,
    // RGB 연동
    this.rgbEnabled = false,
    this.onRgbEnabledChanged,
    this.rgbProcessName = '',
    this.onRgbProcessNameChanged,
    this.socketServerEnabled = false,
    this.onSocketServerEnabledChanged,
    this.socketServerPort = 8080,
    this.onSocketServerPortChanged,
  });

  final String cameraModel;
  final int cameraComIndex;
  final ValueChanged<String> onCameraModelChanged;
  final ValueChanged<int?> onCameraComChanged;
  final List<String> comPorts;
  final String? cameraStatus;

  final String printerModel;
  final List<String> availablePrinters;
  final ValueChanged<String> onPrinterModelChanged;
  final String printerPaperSize;
  final ValueChanged<String> onPrinterPaperSizeChanged;
  final int printerPaperRemaining;
  final ValueChanged<int> onPrinterPaperRemainingChanged;
  final VoidCallback onPrinterPaperReset;
  final int printerMarginH;
  final int printerMarginV;
  final ValueChanged<int> onPrinterMarginHChanged;
  final ValueChanged<int> onPrinterMarginVChanged;
  final VoidCallback onTestPrint;
  final VoidCallback? onPrintSessionProduct;
  final String? printerStatus;

  final bool paymentTerminalEnabled;
  final ValueChanged<bool> onPaymentTerminalEnabledChanged;
  final bool cashDeviceEnabled;
  final ValueChanged<bool> onCashDeviceEnabledChanged;
  final String? paymentStatus;
  final String? cashStatus;
  final VoidCallback onAutoDetect;
  final bool isAutoDetecting;
  final bool isDebugMode;
  final int cashTestAmount;
  final VoidCallback? onCashTestStart;
  final VoidCallback? onCashTestStop;
  final int cashPaymentRequested;
  final int cashPaymentCurrent;
  final bool cashPaymentTargetReached;
  final int cashPaymentPresetIndex;
  final ValueChanged<int>? onCashPaymentPresetChanged;
  final void Function(int amount)? onCashPaymentRequest;

  final bool rgbEnabled;
  final ValueChanged<bool>? onRgbEnabledChanged;
  final String rgbProcessName;
  final ValueChanged<String>? onRgbProcessNameChanged;
  final bool socketServerEnabled;
  final ValueChanged<bool>? onSocketServerEnabledChanged;
  final int socketServerPort;
  final ValueChanged<int>? onSocketServerPortChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        // Define cards
        final cameraCard = AdminSectionCard(
          icon: Icons.camera_alt,
          title: '카메라',
          trailing: _buildStatusTrailing(context, cameraStatus),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminTextField(
                label: '카메라 모델명',
                value: cameraModel,
                onChanged: onCameraModelChanged,
                hint: '모델명 입력 또는 받아오기',
              ),
              const SizedBox(height: 12),
              Text(
                '연결: USB (자동)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );

        final printerCard = AdminSectionCard(
          icon: Icons.print,
          title: '프린터 설정',
          trailing: _buildStatusTrailing(context, printerStatus),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (availablePrinters.isNotEmpty) ...[
                Builder(
                  builder: (context) {
                    final printerList =
                        printerModel.isNotEmpty &&
                            !availablePrinters.contains(printerModel)
                        ? [printerModel, ...availablePrinters]
                        : availablePrinters;
                    final selectedIndex = printerList.indexOf(printerModel);
                    return AdminDropdownField<int>(
                      label: '프린터 선택',
                      value: selectedIndex >= 0 ? selectedIndex : null,
                      items: List<int>.generate(printerList.length, (i) => i),
                      itemLabel: (i) => i >= 0 && i < printerList.length
                          ? printerList[i]
                          : '',
                      onChanged: (idx) {
                        if (idx != null &&
                            idx >= 0 &&
                            idx < printerList.length) {
                          onPrinterModelChanged(printerList[idx]);
                        }
                      },
                    );
                  },
                ),
              ] else
                AdminTextField(
                  label: '모델명 (Windows 프린터 이름)',
                  value: printerModel,
                  onChanged: onPrinterModelChanged,
                  hint: '예: Samsung CLX-6240 Series PS',
                ),
              const SizedBox(height: 12),
              AdminDropdownField<String>(
                label: '용지 크기',
                value: '4x6',
                items: const ['4x6'],
                itemLabel: (v) => '4×6 inch (인화지)',
                onChanged: (_) {}, // 고정값이므로 onChanged에서 아무 동작 안함
              ),
              const SizedBox(height: 12),
              // AdminStepperField(
              //   label: '잔여 인화지',
              //   value: printerPaperRemaining,
              //   onChanged: onPrinterPaperRemainingChanged,
              //   min: 0,
              //   max: 9999,
              // ),
              // const SizedBox(height: 8),
              // TextButton.icon(
              //   onPressed: onPrinterPaperReset,
              //   icon: const Icon(Icons.refresh, size: 18),
              //   label: const Text('인화지 초기화 (980개)'),
              // ),
              // const SizedBox(height: 16),
              // Text(
              //   '인화지 여백 설정',
              //   style: theme.textTheme.titleSmall?.copyWith(
              //     fontWeight: FontWeight.w600,
              //     color: theme.colorScheme.onSurfaceVariant,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // AdminStepperField(
              //   label: '가로형 좌우 여백',
              //   value: printerMarginH,
              //   onChanged: onPrinterMarginHChanged,
              //   min: 0,
              //   max: 100,
              // ),
              // const SizedBox(height: 12),
              // AdminStepperField(
              //   label: '세로형 좌우 여백',
              //   value: printerMarginV,
              //   onChanged: onPrinterMarginVChanged,
              //   min: 0,
              //   max: 100,
              // ),
              // const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onTestPrint,
                      icon: const Icon(Icons.print, size: 22),
                      label: const Text('테스트 인화'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // if (onPrintSessionProduct != null) ...[
                  //   const SizedBox(width: 12),
                  //   Expanded(
                  //     child: OutlinedButton.icon(
                  //       onPressed: onPrintSessionProduct,
                  //       icon: const Icon(Icons.image, size: 22),
                  //       label: const Text('product.jpg 인쇄'),
                  //       style: OutlinedButton.styleFrom(
                  //         minimumSize: const Size(0, 56),
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 24,
                  //           vertical: 16,
                  //         ),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ],
          ),
        );

        final paymentCard = AdminSectionCard(
          icon: Icons.credit_card,
          title: '결제 수단',
          trailing: _buildPaymentCashTrailing(
            context,
            paymentEnabled: paymentTerminalEnabled,
            cashEnabled: cashDeviceEnabled,
            paymentStatus: paymentStatus,
            cashStatus: cashStatus,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '결제 단말기 (카드)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (paymentTerminalEnabled)
                    _buildStatusTrailing(context, paymentStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AdminSwitchField(
                      label: '사용 여부',
                      value: paymentTerminalEnabled,
                      onChanged: onPaymentTerminalEnabledChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현금 결제기',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (cashDeviceEnabled)
                    _buildStatusTrailing(context, cashStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AdminSwitchField(
                      label: '사용 여부',
                      value: cashDeviceEnabled,
                      onChanged: onCashDeviceEnabledChanged,
                    ),
                  ),
                ],
              ),
              if (isDebugMode &&
                  cashDeviceEnabled &&
                  onCashTestStart != null &&
                  onCashTestStop != null) ...[
                const SizedBox(height: 16),
                Text(
                  '현금 테스트 (디버그)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton.tonal(
                      onPressed: onCashTestStart,
                      child: const Text('현금 테스트 시작'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: onCashTestStop,
                      child: const Text('테스트 종료'),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '입금액: ${cashTestAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (isDebugMode &&
                    cashDeviceEnabled &&
                    onCashPaymentRequest != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    '현금 결제 테스트 (요청 금액)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      DropdownButton<int>(
                        value: cashPaymentPresetIndex.clamp(0, 5),
                        items: const [1000, 5000, 7000, 11000, 15000, 20000]
                            .asMap()
                            .entries
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.key,
                                child: Text('${(e.value / 1000).round()}천원'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            onCashPaymentPresetChanged?.call(v ?? 0),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => onCashPaymentRequest!(
                          const [
                            1000,
                            5000,
                            7000,
                            11000,
                            15000,
                            20000,
                          ][cashPaymentPresetIndex.clamp(0, 5)],
                        ),
                        child: const Text('현금 결제 요청'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '요청 금액: ${cashPaymentRequested.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '현재까지 넣은 금액: ${cashPaymentCurrent.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원${cashPaymentTargetReached ? ' · 결제 완료' : ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cashPaymentTargetReached
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        );

        final rgbCard = AdminSectionCard(
          icon: Icons.palette,
          title: 'RGB 연동',
          trailing: rgbEnabled
              ? _buildStatusTrailing(context, 'READY')
              : Text(
                  '미사용',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminSwitchField(
                label: 'RGB 연동 활성화',
                value: rgbEnabled,
                onChanged: (v) => onRgbEnabledChanged?.call(v),
              ),
              if (rgbEnabled) ...[
                const SizedBox(height: 12),
                AdminTextField(
                  label: 'RGB 프로세스명',
                  value: rgbProcessName,
                  onChanged: (v) => onRgbProcessNameChanged?.call(v),
                  hint: '예: RGB_Photo_Studio.exe',
                ),
                const SizedBox(height: 16),
                AdminSwitchField(
                  label: '소켓 서버 활성화',
                  value: socketServerEnabled,
                  onChanged: (v) => onSocketServerEnabledChanged?.call(v),
                ),
                if (socketServerEnabled) ...[
                  const SizedBox(height: 12),
                  AdminStepperField(
                    label: '소켓 서버 포트',
                    value: socketServerPort,
                    onChanged: (v) => onSocketServerPortChanged?.call(v),
                    min: 1024,
                    max: 65535,
                  ),
                ],
              ],
            ],
          ),
        );

        if (isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: isAutoDetecting ? null : onAutoDetect,
                    icon: isAutoDetecting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 20),
                    label: Text(isAutoDetecting ? '탐지 중...' : '자동 탐지'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        cameraCard,
                        const SizedBox(height: 24),
                        paymentCard,
                        const SizedBox(height: 24),
                        rgbCard,
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: printerCard),
                ],
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '| 하드웨어 설정',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: isAutoDetecting ? null : onAutoDetect,
                    icon: isAutoDetecting
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 18),
                    label: Text(isAutoDetecting ? '탐지 중...' : '자동 탐지'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              cameraCard,
              const SizedBox(height: 16),
              printerCard,
              const SizedBox(height: 16),
              paymentCard,
              const SizedBox(height: 16),
              rgbCard,
            ],
          );
        }
      },
    );
  }
}
