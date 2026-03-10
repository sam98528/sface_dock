// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionModel {

 String get sessionId; DateTime get startTime; Map<String, dynamic> get contentSnapshot; List<String> get layoutOptions; Map<String, dynamic> get pricing;
/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionModelCopyWith<SessionModel> get copyWith => _$SessionModelCopyWithImpl<SessionModel>(this as SessionModel, _$identity);

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other.contentSnapshot, contentSnapshot)&&const DeepCollectionEquality().equals(other.layoutOptions, layoutOptions)&&const DeepCollectionEquality().equals(other.pricing, pricing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,startTime,const DeepCollectionEquality().hash(contentSnapshot),const DeepCollectionEquality().hash(layoutOptions),const DeepCollectionEquality().hash(pricing));

@override
String toString() {
  return 'SessionModel(sessionId: $sessionId, startTime: $startTime, contentSnapshot: $contentSnapshot, layoutOptions: $layoutOptions, pricing: $pricing)';
}


}

/// @nodoc
abstract mixin class $SessionModelCopyWith<$Res>  {
  factory $SessionModelCopyWith(SessionModel value, $Res Function(SessionModel) _then) = _$SessionModelCopyWithImpl;
@useResult
$Res call({
 String sessionId, DateTime startTime, Map<String, dynamic> contentSnapshot, List<String> layoutOptions, Map<String, dynamic> pricing
});




}
/// @nodoc
class _$SessionModelCopyWithImpl<$Res>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._self, this._then);

  final SessionModel _self;
  final $Res Function(SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? startTime = null,Object? contentSnapshot = null,Object? layoutOptions = null,Object? pricing = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,contentSnapshot: null == contentSnapshot ? _self.contentSnapshot : contentSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,layoutOptions: null == layoutOptions ? _self.layoutOptions : layoutOptions // ignore: cast_nullable_to_non_nullable
as List<String>,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionModel].
extension SessionModelPatterns on SessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  DateTime startTime,  Map<String, dynamic> contentSnapshot,  List<String> layoutOptions,  Map<String, dynamic> pricing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.sessionId,_that.startTime,_that.contentSnapshot,_that.layoutOptions,_that.pricing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  DateTime startTime,  Map<String, dynamic> contentSnapshot,  List<String> layoutOptions,  Map<String, dynamic> pricing)  $default,) {final _that = this;
switch (_that) {
case _SessionModel():
return $default(_that.sessionId,_that.startTime,_that.contentSnapshot,_that.layoutOptions,_that.pricing);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  DateTime startTime,  Map<String, dynamic> contentSnapshot,  List<String> layoutOptions,  Map<String, dynamic> pricing)?  $default,) {final _that = this;
switch (_that) {
case _SessionModel() when $default != null:
return $default(_that.sessionId,_that.startTime,_that.contentSnapshot,_that.layoutOptions,_that.pricing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionModel implements SessionModel {
  const _SessionModel({required this.sessionId, required this.startTime, required final  Map<String, dynamic> contentSnapshot, required final  List<String> layoutOptions, required final  Map<String, dynamic> pricing}): _contentSnapshot = contentSnapshot,_layoutOptions = layoutOptions,_pricing = pricing;
  factory _SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

@override final  String sessionId;
@override final  DateTime startTime;
 final  Map<String, dynamic> _contentSnapshot;
@override Map<String, dynamic> get contentSnapshot {
  if (_contentSnapshot is EqualUnmodifiableMapView) return _contentSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_contentSnapshot);
}

 final  List<String> _layoutOptions;
@override List<String> get layoutOptions {
  if (_layoutOptions is EqualUnmodifiableListView) return _layoutOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layoutOptions);
}

 final  Map<String, dynamic> _pricing;
@override Map<String, dynamic> get pricing {
  if (_pricing is EqualUnmodifiableMapView) return _pricing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pricing);
}


/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionModelCopyWith<_SessionModel> get copyWith => __$SessionModelCopyWithImpl<_SessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other._contentSnapshot, _contentSnapshot)&&const DeepCollectionEquality().equals(other._layoutOptions, _layoutOptions)&&const DeepCollectionEquality().equals(other._pricing, _pricing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,startTime,const DeepCollectionEquality().hash(_contentSnapshot),const DeepCollectionEquality().hash(_layoutOptions),const DeepCollectionEquality().hash(_pricing));

@override
String toString() {
  return 'SessionModel(sessionId: $sessionId, startTime: $startTime, contentSnapshot: $contentSnapshot, layoutOptions: $layoutOptions, pricing: $pricing)';
}


}

/// @nodoc
abstract mixin class _$SessionModelCopyWith<$Res> implements $SessionModelCopyWith<$Res> {
  factory _$SessionModelCopyWith(_SessionModel value, $Res Function(_SessionModel) _then) = __$SessionModelCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, DateTime startTime, Map<String, dynamic> contentSnapshot, List<String> layoutOptions, Map<String, dynamic> pricing
});




}
/// @nodoc
class __$SessionModelCopyWithImpl<$Res>
    implements _$SessionModelCopyWith<$Res> {
  __$SessionModelCopyWithImpl(this._self, this._then);

  final _SessionModel _self;
  final $Res Function(_SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? startTime = null,Object? contentSnapshot = null,Object? layoutOptions = null,Object? pricing = null,}) {
  return _then(_SessionModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,contentSnapshot: null == contentSnapshot ? _self._contentSnapshot : contentSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,layoutOptions: null == layoutOptions ? _self._layoutOptions : layoutOptions // ignore: cast_nullable_to_non_nullable
as List<String>,pricing: null == pricing ? _self._pricing : pricing // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
