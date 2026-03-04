// lib/core/device/state/device_summary_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_summary_state.freezed.dart';

/// Device summary state derived from Device Controller Service.
///
/// This state comes from IPC communication with the service.
/// Flutter treats service as a black box.
@freezed
class DeviceSummaryState with _$DeviceSummaryState {
  const factory DeviceSummaryState({
    required bool connected,
    required Map<String, dynamic>? summary,
  }) = _DeviceSummaryState;
}
