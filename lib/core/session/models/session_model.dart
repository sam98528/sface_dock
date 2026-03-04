// lib/core/session/models/session_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

/// Session model - immutable data structure.
///
/// Represents a session snapshot with fixed content/layout/pricing.
@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String sessionId,
    required DateTime startTime,
    required Map<String, dynamic> contentSnapshot,
    required List<String> layoutOptions,
    required Map<String, dynamic> pricing,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
