import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../kiosk/kiosk_photo.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required int feedsIdx,
    required int quantity,
    required int price,
    required KioskPhoto photoData,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(null)
    Uint8List? selectedFrameBytes,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(null)
    String? selectedFrameDisplayName,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
