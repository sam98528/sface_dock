// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItem {

 int get feedsIdx; int get quantity; int get price; KioskPhoto get photoData;@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? get selectedFrameBytes;@JsonKey(includeFromJson: false, includeToJson: false) String? get selectedFrameDisplayName;
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemCopyWith<CartItem> get copyWith => _$CartItemCopyWithImpl<CartItem>(this as CartItem, _$identity);

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItem&&(identical(other.feedsIdx, feedsIdx) || other.feedsIdx == feedsIdx)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoData, photoData) || other.photoData == photoData)&&const DeepCollectionEquality().equals(other.selectedFrameBytes, selectedFrameBytes)&&(identical(other.selectedFrameDisplayName, selectedFrameDisplayName) || other.selectedFrameDisplayName == selectedFrameDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feedsIdx,quantity,price,photoData,const DeepCollectionEquality().hash(selectedFrameBytes),selectedFrameDisplayName);

@override
String toString() {
  return 'CartItem(feedsIdx: $feedsIdx, quantity: $quantity, price: $price, photoData: $photoData, selectedFrameBytes: $selectedFrameBytes, selectedFrameDisplayName: $selectedFrameDisplayName)';
}


}

/// @nodoc
abstract mixin class $CartItemCopyWith<$Res>  {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) _then) = _$CartItemCopyWithImpl;
@useResult
$Res call({
 int feedsIdx, int quantity, int price, KioskPhoto photoData,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? selectedFrameBytes,@JsonKey(includeFromJson: false, includeToJson: false) String? selectedFrameDisplayName
});




}
/// @nodoc
class _$CartItemCopyWithImpl<$Res>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._self, this._then);

  final CartItem _self;
  final $Res Function(CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feedsIdx = null,Object? quantity = null,Object? price = null,Object? photoData = null,Object? selectedFrameBytes = freezed,Object? selectedFrameDisplayName = freezed,}) {
  return _then(_self.copyWith(
feedsIdx: null == feedsIdx ? _self.feedsIdx : feedsIdx // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,photoData: null == photoData ? _self.photoData : photoData // ignore: cast_nullable_to_non_nullable
as KioskPhoto,selectedFrameBytes: freezed == selectedFrameBytes ? _self.selectedFrameBytes : selectedFrameBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,selectedFrameDisplayName: freezed == selectedFrameDisplayName ? _self.selectedFrameDisplayName : selectedFrameDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItem].
extension CartItemPatterns on CartItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItem value)  $default,){
final _that = this;
switch (_that) {
case _CartItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItem value)?  $default,){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int feedsIdx,  int quantity,  int price,  KioskPhoto photoData, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? selectedFrameBytes, @JsonKey(includeFromJson: false, includeToJson: false)  String? selectedFrameDisplayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.feedsIdx,_that.quantity,_that.price,_that.photoData,_that.selectedFrameBytes,_that.selectedFrameDisplayName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int feedsIdx,  int quantity,  int price,  KioskPhoto photoData, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? selectedFrameBytes, @JsonKey(includeFromJson: false, includeToJson: false)  String? selectedFrameDisplayName)  $default,) {final _that = this;
switch (_that) {
case _CartItem():
return $default(_that.feedsIdx,_that.quantity,_that.price,_that.photoData,_that.selectedFrameBytes,_that.selectedFrameDisplayName);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int feedsIdx,  int quantity,  int price,  KioskPhoto photoData, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? selectedFrameBytes, @JsonKey(includeFromJson: false, includeToJson: false)  String? selectedFrameDisplayName)?  $default,) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.feedsIdx,_that.quantity,_that.price,_that.photoData,_that.selectedFrameBytes,_that.selectedFrameDisplayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItem implements CartItem {
  const _CartItem({required this.feedsIdx, required this.quantity, required this.price, required this.photoData, @JsonKey(includeFromJson: false, includeToJson: false) this.selectedFrameBytes = null, @JsonKey(includeFromJson: false, includeToJson: false) this.selectedFrameDisplayName = null});
  factory _CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

@override final  int feedsIdx;
@override final  int quantity;
@override final  int price;
@override final  KioskPhoto photoData;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  Uint8List? selectedFrameBytes;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? selectedFrameDisplayName;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemCopyWith<_CartItem> get copyWith => __$CartItemCopyWithImpl<_CartItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItem&&(identical(other.feedsIdx, feedsIdx) || other.feedsIdx == feedsIdx)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoData, photoData) || other.photoData == photoData)&&const DeepCollectionEquality().equals(other.selectedFrameBytes, selectedFrameBytes)&&(identical(other.selectedFrameDisplayName, selectedFrameDisplayName) || other.selectedFrameDisplayName == selectedFrameDisplayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feedsIdx,quantity,price,photoData,const DeepCollectionEquality().hash(selectedFrameBytes),selectedFrameDisplayName);

@override
String toString() {
  return 'CartItem(feedsIdx: $feedsIdx, quantity: $quantity, price: $price, photoData: $photoData, selectedFrameBytes: $selectedFrameBytes, selectedFrameDisplayName: $selectedFrameDisplayName)';
}


}

/// @nodoc
abstract mixin class _$CartItemCopyWith<$Res> implements $CartItemCopyWith<$Res> {
  factory _$CartItemCopyWith(_CartItem value, $Res Function(_CartItem) _then) = __$CartItemCopyWithImpl;
@override @useResult
$Res call({
 int feedsIdx, int quantity, int price, KioskPhoto photoData,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? selectedFrameBytes,@JsonKey(includeFromJson: false, includeToJson: false) String? selectedFrameDisplayName
});




}
/// @nodoc
class __$CartItemCopyWithImpl<$Res>
    implements _$CartItemCopyWith<$Res> {
  __$CartItemCopyWithImpl(this._self, this._then);

  final _CartItem _self;
  final $Res Function(_CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feedsIdx = null,Object? quantity = null,Object? price = null,Object? photoData = null,Object? selectedFrameBytes = freezed,Object? selectedFrameDisplayName = freezed,}) {
  return _then(_CartItem(
feedsIdx: null == feedsIdx ? _self.feedsIdx : feedsIdx // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,photoData: null == photoData ? _self.photoData : photoData // ignore: cast_nullable_to_non_nullable
as KioskPhoto,selectedFrameBytes: freezed == selectedFrameBytes ? _self.selectedFrameBytes : selectedFrameBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,selectedFrameDisplayName: freezed == selectedFrameDisplayName ? _self.selectedFrameDisplayName : selectedFrameDisplayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
