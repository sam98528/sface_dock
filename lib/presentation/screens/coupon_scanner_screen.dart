import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/admin/controllers/admin_controller.dart';
import '../../core/device/device_controller_proxy_provider.dart';
import '../../core/device/services/camera/camera_service.dart';
import '../../core/device/services/device_service_providers.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../data/repositories/coupon_repository.dart';
import '../../utils/encoding/qr_encryption.dart';
import '../components/kiosk_keyboard.dart';
import '../components/kiosk_keyboard_overlay.dart';
import '../../core/services/audio_service.dart';
import '../components/mjpeg_viewer.dart';

class CouponScannerScreen extends ConsumerStatefulWidget {
  const CouponScannerScreen({super.key});

  @override
  ConsumerState<CouponScannerScreen> createState() =>
      _CouponScannerScreenState();
}

class _CouponScannerScreenState extends ConsumerState<CouponScannerScreen> {
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _statusMessage = '쿠폰 QR 코드를 카메라에 비추세요';
  String? _mjpegUrl;

  StreamSubscription<String>? _qrSubscription;
  bool _isProcessing = false;
  bool _showQRFeedback = false;
  bool _isQRSuccess = false;
  String _feedbackMessage = '';

  late final CameraService _cameraService;
  final _codeController = TextEditingController();
  String? _codeError;
  bool _skipCamera = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _cameraService = ref.read(cameraServiceProvider);
    _codeController.addListener(() {
      if (_codeError != null) setState(() => _codeError = null);
    });
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final isConnected = ref.read(connectionStateProvider);
    final adminState = ref.read(adminControllerProvider);

    if (!isConnected || adminState.debugSkipDeviceConnection) {
      setState(() {
        _isInitializing = false;
        _skipCamera = true;
        _statusMessage =
            isConnected ? '디버그 모드: 장비 연결 스킵' : '서비스에 연결되어 있지 않습니다';
      });
      return;
    }

    try {
      setState(() => _statusMessage = '카메라 라이브뷰 시작 중...');

      final previewResult = await _cameraService.startPreview();
      if (previewResult == null) {
        setState(() {
          _hasError = true;
          _errorMessage = '카메라 라이브뷰를 시작할 수 없습니다.\n카메라 연결 상태를 확인해주세요.';
          _isInitializing = false;
        });
        return;
      }

      final result = previewResult['result'] as Map<String, dynamic>?;
      final mjpegUrl = result?['liveview_url']?.toString();
      if (mjpegUrl != null && mjpegUrl.isNotEmpty) {
        setState(() => _mjpegUrl = mjpegUrl);
      }

      await _cameraService.resetQrDetection();

      setState(() => _statusMessage = 'QR 감지 활성화 중...');

      final qrResult = await _cameraService.enableQrDetection(true);
      if (qrResult == null) {
        setState(() {
          _hasError = true;
          _errorMessage = 'QR 감지를 활성화할 수 없습니다.';
          _isInitializing = false;
        });
        return;
      }

      _qrSubscription = _cameraService.qrDetectedEvents.listen((qrText) {
        if (qrText.isNotEmpty && mounted && !_isProcessing) {
          _handleQRCode(qrText);
        }
      });

      setState(() {
        _isInitializing = false;
        _statusMessage = '쿠폰 QR 코드를 카메라에 비추세요';
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = '카메라 초기화 중 오류가 발생했습니다:\n$e';
        _isInitializing = false;
      });
    }
  }

  void _handleQRCode(String qrText) {
    setState(() => _isProcessing = true);
    debugPrint('[CouponScanner] QR raw: $qrText');

    if (!QREncryption.isCouponQR(qrText)) {
      debugPrint('[CouponScanner] 쿠폰 QR 아님 (SFACE_CPN_ prefix 없음)');
      _displayQRFeedback(false, '쿠폰 QR이 아닙니다');
      return;
    }

    final couponCode = QREncryption.decryptCouponCode(qrText);
    debugPrint('[CouponScanner] decryptCouponCode: $couponCode');
    if (couponCode == null) {
      debugPrint('[CouponScanner] 쿠폰 코드 복호화 실패');
      _displayQRFeedback(false, 'QR 코드 해석 실패');
      return;
    }

    debugPrint('[CouponScanner] couponCode: $couponCode');
    _displayQRFeedback(true, 'QR 인식 성공! 쿠폰 확인 중...');
    _verifyCoupon(couponCode);
  }

  void _handleCodeSubmit() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _codeError = '쿠폰 코드를 입력해 주세요');
      return;
    }

    setState(() => _codeError = null);
    _verifyCoupon(code);
  }

  Future<void> _verifyCoupon(String code) async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);
    debugPrint('[CouponScanner] verifyCoupon 호출: code=$code');

    try {
      final repository = ref.read(couponRepositoryProvider);
      final result = await repository.verifyCoupon(code);
      debugPrint('[CouponScanner] verify 결과: valid=${result.valid}, message=${result.message}, name=${result.couponName}, type=${result.couponDiscountType}');

      if (!mounted) return;

      if (result.valid) {
        _displayQRFeedback(true, '쿠폰 확인 완료!');
        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            _cleanup();
            Navigator.of(context).pop(result);
          }
        });
      } else {
        _displayQRFeedback(false, result.message ?? '사용할 수 없는 쿠폰입니다.');
        setState(() => _isVerifying = false);
      }
    } catch (e, st) {
      debugPrint('[CouponScanner] verifyCoupon 에러: $e\n$st');
      if (mounted) {
        _displayQRFeedback(false, '쿠폰 확인 중 오류가 발생했습니다.');
        setState(() => _isVerifying = false);
      }
    }
  }

  void _displayQRFeedback(bool isSuccess, String message) {
    setState(() {
      _showQRFeedback = true;
      _isQRSuccess = isSuccess;
      _feedbackMessage = message;
    });

    if (!isSuccess) {
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showQRFeedback = false;
            _isProcessing = false;
          });
        }
      });
    }
  }

  void _cleanup() {
    _qrSubscription?.cancel();
    _cameraService.enableQrDetection(false);
    _cameraService.stopPreview();
  }

  @override
  void dispose() {
    KioskKeyboardOverlay.dismiss();
    _cleanup();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [KioskColors.primary, KioskColors.secondary],
              ),
            ),
          ),

          // 메인 컨텐츠: 좌측 광고 | 중앙 카메라뷰 | 우측 코드 입력
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 좌측: 광고 이미지
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Image.asset(
                      'assets/images/sface_ad_image.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                // 중앙: 카메라 뷰
                Expanded(
                  flex: 3,
                  child: Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '위쪽 카메라 렌즈에 쿠폰 QR코드를 인식해 주세요',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 560,
                        width: 840,
                        child: _buildCameraView(),
                      ),
                      if (_showQRFeedback)
                        Text(
                          _feedbackMessage,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _isQRSuccess
                                ? KioskColors.success
                                : Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),

                // 우측: 쿠폰 코드 직접 입력
                Expanded(
                  flex: 2,
                  child: _buildCodeInput(textTheme),
                ),
              ],
            ),
          ),

          // 상단 바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    KioskColors.grey400.withValues(alpha: 0.7),
                    KioskColors.grey400.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                    decoration: BoxDecoration(
                      color: KioskColors.surface,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.playTapSound();
                        KioskKeyboardOverlay.dismiss();
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: KioskColors.primary,
                            size: 28,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '뒤로',
                              style: textTheme.titleMedium?.copyWith(
                                color: KioskColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'QR코드 인식이 어렵다면\n쿠폰 코드를 직접 입력해주세요',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            width: 300,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: GestureDetector(
                onTap: () {
                  if (!KioskKeyboardOverlay.isVisible) {
                    KioskKeyboardOverlay.show(
                      context,
                      controller: _codeController,
                      initialMode: KeyboardMode.english,
                      maxLength: 8,
                      forceUppercase: true,
                      onSubmit: _handleCodeSubmit,
                    );
                  }
                },
                child: TextField(
                  controller: _codeController,
                  readOnly: true,
                  showCursor: true,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: KioskColors.textPrimary,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    hintText: '쿠폰 코드 입력',
                    hintStyle: textTheme.titleMedium?.copyWith(
                      color: KioskColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onTap: () {
                    if (!KioskKeyboardOverlay.isVisible) {
                      KioskKeyboardOverlay.show(
                        context,
                        controller: _codeController,
                        initialMode: KeyboardMode.english,
                        maxLength: 8,
                        forceUppercase: true,
                        onSubmit: _handleCodeSubmit,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          if (_codeError != null) ...[
            const SizedBox(height: 12),
            Text(
              _codeError!,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 56,
            child: ElevatedButton(
              onPressed: _isVerifying
                  ? null
                  : () {
                      context.playTapSound();
                      _handleCodeSubmit();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: KioskColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: _isVerifying
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '확인',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: KioskColors.primary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (_skipCamera) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off, color: Colors.white, size: 64),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '우측에서 쿠폰 코드를 직접 입력해 주세요',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    if (_isInitializing) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Container(
        decoration: BoxDecoration(
          color: KioskColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: KioskColors.error.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 80),
              const SizedBox(height: 24),
              Text(
                _errorMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _mjpegUrl != null
                ? MjpegViewer(
                    streamUrl: _mjpegUrl!,
                    fit: BoxFit.contain,
                    loading: Container(
                      color: Colors.white.withValues(alpha: 0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white.withValues(alpha: 0.1),
                    child: const Center(
                      child: Text(
                        'QR 감지 대기 중...',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ),

        // QR 타겟 영역
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: _showQRFeedback
                    ? (_isQRSuccess ? KioskColors.success : KioskColors.error)
                    : Colors.white,
                width: 5,
              ),
            ),
          ),
        ),

        // 피드백 아이콘
        if (_showQRFeedback)
          Center(
            child: AnimatedOpacity(
              opacity: _showQRFeedback ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _isQRSuccess
                      ? KioskColors.success.withValues(alpha: 0.9)
                      : KioskColors.error.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  _isQRSuccess ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
