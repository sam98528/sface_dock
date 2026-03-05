import 'package:freezed_annotation/freezed_annotation.dart';
import '../photogoods/photo_detail.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required int feedsIdx,
    required int quantity,
    required int price,
    required PhotoDetail photoData,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
