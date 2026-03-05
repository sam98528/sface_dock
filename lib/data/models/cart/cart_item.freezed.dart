// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  int get feedsIdx => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  PhotoDetail get photoData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({int feedsIdx, int quantity, int price, PhotoDetail photoData});

  $PhotoDetailCopyWith<$Res> get photoData;
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedsIdx = null,
    Object? quantity = null,
    Object? price = null,
    Object? photoData = null,
  }) {
    return _then(_value.copyWith(
      feedsIdx: null == feedsIdx
          ? _value.feedsIdx
          : feedsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      photoData: null == photoData
          ? _value.photoData
          : photoData // ignore: cast_nullable_to_non_nullable
              as PhotoDetail,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PhotoDetailCopyWith<$Res> get photoData {
    return $PhotoDetailCopyWith<$Res>(_value.photoData, (value) {
      return _then(_value.copyWith(photoData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int feedsIdx, int quantity, int price, PhotoDetail photoData});

  @override
  $PhotoDetailCopyWith<$Res> get photoData;
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedsIdx = null,
    Object? quantity = null,
    Object? price = null,
    Object? photoData = null,
  }) {
    return _then(_$CartItemImpl(
      feedsIdx: null == feedsIdx
          ? _value.feedsIdx
          : feedsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      photoData: null == photoData
          ? _value.photoData
          : photoData // ignore: cast_nullable_to_non_nullable
              as PhotoDetail,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl(
      {required this.feedsIdx,
      required this.quantity,
      required this.price,
      required this.photoData});

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final int feedsIdx;
  @override
  final int quantity;
  @override
  final int price;
  @override
  final PhotoDetail photoData;

  @override
  String toString() {
    return 'CartItem(feedsIdx: $feedsIdx, quantity: $quantity, price: $price, photoData: $photoData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.feedsIdx, feedsIdx) ||
                other.feedsIdx == feedsIdx) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.photoData, photoData) ||
                other.photoData == photoData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, feedsIdx, quantity, price, photoData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem implements CartItem {
  const factory _CartItem(
      {required final int feedsIdx,
      required final int quantity,
      required final int price,
      required final PhotoDetail photoData}) = _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  int get feedsIdx;
  @override
  int get quantity;
  @override
  int get price;
  @override
  PhotoDetail get photoData;
  @override
  @JsonKey(ignore: true)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
