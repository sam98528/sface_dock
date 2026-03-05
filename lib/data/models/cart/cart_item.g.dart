// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      feedsIdx: (json['feedsIdx'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      photoData:
          PhotoDetail.fromJson(json['photoData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'feedsIdx': instance.feedsIdx,
      'quantity': instance.quantity,
      'price': instance.price,
      'photoData': instance.photoData,
    };
