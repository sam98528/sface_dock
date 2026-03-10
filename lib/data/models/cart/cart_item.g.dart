// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  feedsIdx: (json['feedsIdx'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toInt(),
  photoData: KioskPhoto.fromJson(json['photoData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'feedsIdx': instance.feedsIdx,
  'quantity': instance.quantity,
  'price': instance.price,
  'photoData': instance.photoData,
};
