# QR 코드 스캔 기능 구현 계획

## Context
Flutter 키오스크 앱(sface_dock)에서 QR 스캐너 화면은 이미 구현되어 있지만, C++ device-controller-service에 QR 감지 관련 코드가 전혀 없어서 `camera_enable_qr_detection` 등의 커맨드가 rejected됨. 또한 라이브뷰 URL 키 불일치(`liveview_url` vs `mjpegUrl`)로 MJPEG 스트림도 Flutter에서 안 보임.

**결정 사항:** ZXing-cpp 라이브러리 사용, 매 5프레임마다 QR 스캔

---

## 작업 순서

### 1. [Flutter] 라이브뷰 URL 키 수정
**파일:** `sface_dock/lib/presentation/screens/qr_scanner_screen.dart:81`
- `result?['mjpegUrl']` → `result?['liveview_url']` 변경
- C++이 `resp.responseMap["liveview_url"]`로 반환하므로 Flutter가 맞춰야 함

### 2. [C++] message_types.h에 QR 커맨드/이벤트 타입 추가
**파일:** `device-controller-service-kiosk/include/ipc/message_types.h`

CommandType enum 추가:
```
CAMERA_ENABLE_QR_DETECTION, CAMERA_DISABLE_QR_DETECTION, CAMERA_RESET_QR_DETECTION
```
EventType enum 추가:
```
QR_CODE_DETECTED
```
+ 모든 문자열 변환 함수 4곳에 매핑 추가

### 3. [C++] ZXing-cpp 의존성 추가
**파일:** `device-controller-service-kiosk/CMakeLists.txt`
- FetchContent로 zxing-cpp 가져오기
- target_link_libraries에 ZXing::ZXing 추가
- 기존 `third_party/stb_image.h`로 JPEG→pixels 변환 (이미 프로젝트에 존재)

### 4. [C++] ICamera 인터페이스 확장
**파일:** `device-controller-service-kiosk/include/devices/icamera.h`

추가:
```cpp
virtual bool enableQrDetection(bool enable) = 0;
virtual bool resetQrDetection() = 0;
virtual void setQrDetectedCallback(std::function<void(const std::string&)> cb) = 0;
```

### 5. [C++] EdsdkCameraAdapter에 QR 감지 구현
**헤더:** `device-controller-service-kiosk/include/vendor_adapters/canon/edsdk_camera_adapter.h`
**구현:** `device-controller-service-kiosk/src/vendor_adapters/canon/edsdk_camera_adapter.cpp`

멤버 변수:
```cpp
std::atomic<bool> qrDetectionEnabled_{false};
std::atomic<int> evfFrameCount_{0};
std::string lastDetectedQr_;
std::mutex qrMutex_;
std::function<void(const std::string&)> qrDetectedCallback_;
static constexpr int QR_SCAN_INTERVAL = 5; // 매 5프레임
```

메서드:
- `enableQrDetection(bool)` → 플래그 토글
- `resetQrDetection()` → `lastDetectedQr_` 클리어 (같은 QR 재감지 허용)
- `tryDecodeQr(const uint8_t* jpegData, size_t len)` → stb_image 디코드 + ZXing ReadBarcode

### 6. [C++] GetEvfFrameCommand에 QR 스캔 삽입
**파일:** `device-controller-service-kiosk/src/vendor_adapters/canon/edsdk_commands.cpp`

기존 흐름: JPEG 추출 → `liveViewServer_.setFrame()`
추가 흐름:
```
evfFrameCount_++
if (qrDetectionEnabled_ && evfFrameCount_ % 5 == 0):
    adapter->tryDecodeQr(jpegData, jpegLen)
```

`tryDecodeQr` 내부:
1. `stbi_load_from_memory()` → grayscale pixels
2. `ZXing::ReadBarcode(imageView, hints)` (hints: QR only)
3. 텍스트 감지 && 텍스트 != lastDetectedQr_ → 콜백 호출, lastDetectedQr_ 갱신

### 7. [C++] ServiceCore에 커맨드 핸들러 등록
**파일:** `device-controller-service-kiosk/src/core/service_core.cpp`
**헤더:** `device-controller-service-kiosk/include/core/service_core.h`

핸들러 등록:
```cpp
ipcServer_.registerHandler(CommandType::CAMERA_ENABLE_QR_DETECTION, ...);
ipcServer_.registerHandler(CommandType::CAMERA_DISABLE_QR_DETECTION, ...);
ipcServer_.registerHandler(CommandType::CAMERA_RESET_QR_DETECTION, ...);
```

핸들러 구현: camera→enableQrDetection() / resetQrDetection() 호출

QR 콜백 등록 (카메라 초기화 시):
```cpp
camera->setQrDetectedCallback([this](const std::string& qrText) {
    ipc::Event evt;
    evt.eventType = ipc::EventType::QR_CODE_DETECTED;
    evt.deviceType = "camera";
    evt.data["qrText"] = qrText;
    ipcServer_.broadcastEvent(evt);
});
```

---

## 파일 수정 요약

| # | 프로젝트 | 파일 | 변경 |
|---|---------|------|------|
| 1 | Flutter | `lib/presentation/screens/qr_scanner_screen.dart` | `mjpegUrl` → `liveview_url` |
| 2 | C++ | `include/ipc/message_types.h` | CommandType 3개 + EventType 1개 + 문자열 매핑 |
| 3 | C++ | `CMakeLists.txt` | ZXing-cpp FetchContent 추가 |
| 4 | C++ | `include/devices/icamera.h` | QR 메서드 3개 추가 |
| 5 | C++ | `include/vendor_adapters/canon/edsdk_camera_adapter.h` | QR 멤버/메서드 선언 |
| 6 | C++ | `src/vendor_adapters/canon/edsdk_camera_adapter.cpp` | QR 메서드 구현 |
| 7 | C++ | `src/vendor_adapters/canon/edsdk_commands.cpp` | GetEvfFrameCommand에 QR 스캔 |
| 8 | C++ | `include/core/service_core.h` | 핸들러 메서드 선언 |
| 9 | C++ | `src/core/service_core.cpp` | 핸들러 등록 + 콜백 연결 |

---

## 검증
1. C++ 빌드 성공 확인 (CMake + MSVC)
2. 서비스 실행 → Flutter QR 스캐너 화면 진입
3. MJPEG 라이브뷰 정상 표시 확인
4. QR 코드를 카메라에 비추면 `qr_code_detected` 이벤트 → Flutter에서 PhotoDetailDialog 열림
5. `resetQrDetection` 후 같은 QR 재인식 가능 확인
6. 인증번호 직접 입력도 정상 동작 확인
