import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/admin/controllers/admin_controller.dart';
import '../../core/device/device_controller_proxy_provider.dart';
import '../../core/device/services/camera/camera_service.dart';
import '../../core/device/services/device_service_providers.dart';
import '../../core/theme/kiosk_colors.dart';
import '../../utils/encoding/qr_encryption.dart';
import '../components/mjpeg_viewer.dart';
import 'photo_detail_screen.dart';

/// QR 스캐너 화면.
///
/// device-controller-service를 통해 카메라 라이브뷰 + QR 코드 감지.
class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _statusMessage = 'SFACE QR 코드를 카메라에 비추세요';
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

  @override
  void initState() {
    super.initState();
    _cameraService = ref.read(cameraServiceProvider);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 서비스 연결 상태 + 디버그 스킵 옵션 확인
    final isConnected = ref.read(connectionStateProvider);
    final adminState = ref.read(adminControllerProvider);

    if (!isConnected || adminState.debugSkipDeviceConnection) {
      setState(() {
        _isInitializing = false;
        _skipCamera = true;
        _statusMessage = isConnected
            ? '디버그 모드: 장비 연결 스킵'
            : '서비스에 연결되어 있지 않습니다';
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
        _statusMessage = 'SFACE QR 코드를 카메라에 비추세요';
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

    if (!QREncryption.isValidSFACEQR(qrText)) {
      _displayQRFeedback(false, 'SFACE QR이 아닙니다');
      return;
    }

    final feedIdx = QREncryption.decryptToFeedIdx(qrText);
    if (feedIdx == null) {
      _displayQRFeedback(false, 'QR 코드 해석 실패');
      return;
    }

    _displayQRFeedback(true, 'QR 인식 성공');
    _navigateToDetail(feedIdx);
  }

  void _handleCodeSubmit() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _codeError = '인증번호를 입력해 주세요');
      return;
    }

    final feedIdx = int.tryParse(code);
    if (feedIdx == null) {
      setState(() => _codeError = '올바른 인증번호가 아닙니다');
      return;
    }

    setState(() => _codeError = null);
    _navigateToDetail(feedIdx);
  }

  void _navigateToDetail(int feedIdx) {
    Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;

      await _cameraService.enableQrDetection(false);
      _qrSubscription?.cancel();

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => PhotoDetailDialog(feedsIdx: feedIdx),
        );
      }
    });
  }

  void _displayQRFeedback(bool isSuccess, String message) {
    setState(() {
      _showQRFeedback = true;
      _isQRSuccess = isSuccess;
      _feedbackMessage = message;
    });

    final delay = isSuccess
        ? const Duration(seconds: 2)
        : const Duration(milliseconds: 500);

    Timer(delay, () {
      if (mounted) {
        setState(() {
          _showQRFeedback = false;
          _isProcessing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _qrSubscription?.cancel();
    _cameraService.enableQrDetection(false);
    _cameraService.stopPreview();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (photo_grid_screen과 동일)
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

          // 메인 컨텐츠: 좌측 광고 이미지 | 중앙 카메라뷰 | 우측 코드 입력
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

                // 중앙: 카메라 뷰 + 안내
                Expanded(
                  flex: 3,
                  child: Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '위쪽 카메라 렌즈에 QR코드를 인식해 주세요',
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

                // 우측: 인증번호 직접 입력
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: _buildCodeInput(textTheme),
                  ),
                ),
              ],
            ),
          ),

          // 상단 바 (SearchActionBar와 동일한 스타일)
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
                      onTap: () => Navigator.of(context).pop(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'QR코드 인식이 어렵다면\n인증번호를 직접 입력해주세요',
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
            child: TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: KioskColors.textPrimary,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: '인증번호 입력',
                hintStyle: textTheme.titleMedium?.copyWith(
                  color: KioskColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (_) {
                if (_codeError != null) setState(() => _codeError = null);
              },
              onSubmitted: (_) => _handleCodeSubmit(),
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
            onPressed: _handleCodeSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: KioskColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Text(
              '확인',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: KioskColors.primary,
              ),
            ),
          ),
        ),
      ],
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
                '우측에서 인증번호를 직접 입력해 주세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
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
