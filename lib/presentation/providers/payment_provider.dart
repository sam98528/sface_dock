import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/admin/controllers/admin_controller.dart';
import '../../core/device/services/device_service_providers.dart';
import '../../core/device/services/payment/payment_device_service.dart';

/// 결제 단계
enum PaymentPhase { idle, processing, completed, cancelled, error }

/// 결제 승인 결과
class PaymentResult {
  final String transactionId;
  final int amount;
  final String? cardNumber;
  final String? approvalNumber;
  final Map<String, dynamic> approvalDetail;

  const PaymentResult({
    required this.transactionId,
    required this.amount,
    this.cardNumber,
    this.approvalNumber,
    this.approvalDetail = const {},
  });
}

/// 결제 상태
class PaymentState {
  final PaymentPhase phase;
  final PaymentResult? result;
  final String? errorMessage;

  const PaymentState({
    this.phase = PaymentPhase.idle,
    this.result,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentPhase? phase,
    PaymentResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return PaymentState(
      phase: phase ?? this.phase,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(this._ref) : super(const PaymentState()) {
    _paymentService = _ref.read(paymentDeviceServiceProvider);
    _eventSubscription = _paymentService.paymentEvents.listen(_handleEvent);
  }

  final Ref _ref;
  late final PaymentDeviceService _paymentService;
  late final StreamSubscription<Map<String, dynamic>> _eventSubscription;

  bool get _isDebugMode =>
      !_ref.read(adminControllerProvider).paymentTerminalEnabled;

  /// 결제 시작
  Future<void> startPayment(int amount) async {
    state = const PaymentState(phase: PaymentPhase.processing);

    if (_isDebugMode) {
      debugPrint('[Payment] 디버그 모드 - 시뮬레이션 대기 중 (amount: $amount)');
      return;
    }

    try {
      final response = await _paymentService.startPayment(amount);
      final status = response?['status']?.toString().toUpperCase();
      if (status == 'FAILED') {
        final error = response?['error']?.toString() ?? '결제 요청 실패';
        state = PaymentState(
          phase: PaymentPhase.error,
          errorMessage: error,
        );
      }
      // OK → processing 유지, 이벤트 스트림에서 결과 수신 대기
    } catch (e) {
      state = PaymentState(
        phase: PaymentPhase.error,
        errorMessage: '결제 요청 중 오류: $e',
      );
    }
  }

  /// 결제 취소
  Future<void> cancelPayment() async {
    if (_isDebugMode) {
      state = const PaymentState(phase: PaymentPhase.cancelled);
      return;
    }

    try {
      await _paymentService.cancelPayment();
    } catch (e) {
      debugPrint('[Payment] cancelPayment error: $e');
    }
    // 실제 취소 결과는 이벤트 스트림에서 수신
  }

  /// 상태 초기화
  void reset() {
    state = const PaymentState();
  }

  /// IPC 이벤트 처리
  void _handleEvent(Map<String, dynamic> event) {
    final eventType = event['eventType']?.toString() ?? '';
    final data = event['data'] as Map<String, dynamic>? ?? event;

    debugPrint('[Payment] 이벤트 수신: $eventType');

    switch (eventType) {
      case 'payment_complete':
        final result = PaymentResult(
          transactionId: data['transactionId']?.toString() ?? '',
          amount: int.tryParse(data['amount']?.toString() ?? '0') ?? 0,
          cardNumber: data['cardNumber']?.toString(),
          approvalNumber: data['approvalNumber']?.toString(),
          approvalDetail: data,
        );
        state = PaymentState(
          phase: PaymentPhase.completed,
          result: result,
        );
        break;

      case 'payment_failed':
        final errorMsg =
            data['errorMessage']?.toString() ?? '결제가 실패하였습니다.';
        state = PaymentState(
          phase: PaymentPhase.error,
          errorMessage: errorMsg,
        );
        break;

      case 'payment_cancelled':
        state = const PaymentState(phase: PaymentPhase.cancelled);
        break;
    }
  }

  // --- 디버그 시뮬레이션 메서드 ---

  void simulateComplete(int amount) {
    state = PaymentState(
      phase: PaymentPhase.completed,
      result: PaymentResult(
        transactionId: 'DEBUG_${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        cardNumber: '****0000',
        approvalNumber: 'DBG12345',
      ),
    );
  }

  void simulateError(String message) {
    state = PaymentState(
      phase: PaymentPhase.error,
      errorMessage: message,
    );
  }

  void simulateCancelled() {
    state = const PaymentState(phase: PaymentPhase.cancelled);
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }
}

// --- Providers ---

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref);
});

final paymentPhaseProvider = Provider<PaymentPhase>((ref) {
  return ref.watch(paymentProvider).phase;
});

final paymentResultProvider = Provider<PaymentResult?>((ref) {
  return ref.watch(paymentProvider).result;
});

final paymentDebugModeProvider = Provider<bool>((ref) {
  return !ref.watch(adminControllerProvider).paymentTerminalEnabled;
});
