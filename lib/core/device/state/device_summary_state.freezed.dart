// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceSummaryState {

 bool get connected; Map<String, dynamic>? get summary;
/// Create a copy of DeviceSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSummaryStateCopyWith<DeviceSummaryState> get copyWith => _$DeviceSummaryStateCopyWithImpl<DeviceSummaryState>(this as DeviceSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSummaryState&&(identical(other.connected, connected) || other.connected == connected)&&const DeepCollectionEquality().equals(other.summary, summary));
}


@override
int get hashCode => Object.hash(runtimeType,connected,const DeepCollectionEquality().hash(summary));

@override
String toString() {
  return 'DeviceSummaryState(connected: $connected, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $DeviceSummaryStateCopyWith<$Res>  {
  factory $DeviceSummaryStateCopyWith(DeviceSummaryState value, $Res Function(DeviceSummaryState) _then) = _$DeviceSummaryStateCopyWithImpl;
@useResult
$Res call({
 bool connected, Map<String, dynamic>? summary
});




}
/// @nodoc
class _$DeviceSummaryStateCopyWithImpl<$Res>
    implements $DeviceSummaryStateCopyWith<$Res> {
  _$DeviceSummaryStateCopyWithImpl(this._self, this._then);

  final DeviceSummaryState _self;
  final $Res Function(DeviceSummaryState) _then;

/// Create a copy of DeviceSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connected = null,Object? summary = freezed,}) {
  return _then(_self.copyWith(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceSummaryState].
extension DeviceSummaryStatePatterns on DeviceSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _DeviceSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool connected,  Map<String, dynamic>? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceSummaryState() when $default != null:
return $default(_that.connected,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool connected,  Map<String, dynamic>? summary)  $default,) {final _that = this;
switch (_that) {
case _DeviceSummaryState():
return $default(_that.connected,_that.summary);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool connected,  Map<String, dynamic>? summary)?  $default,) {final _that = this;
switch (_that) {
case _DeviceSummaryState() when $default != null:
return $default(_that.connected,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceSummaryState implements DeviceSummaryState {
  const _DeviceSummaryState({required this.connected, required final  Map<String, dynamic>? summary}): _summary = summary;
  

@override final  bool connected;
 final  Map<String, dynamic>? _summary;
@override Map<String, dynamic>? get summary {
  final value = _summary;
  if (value == null) return null;
  if (_summary is EqualUnmodifiableMapView) return _summary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of DeviceSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceSummaryStateCopyWith<_DeviceSummaryState> get copyWith => __$DeviceSummaryStateCopyWithImpl<_DeviceSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceSummaryState&&(identical(other.connected, connected) || other.connected == connected)&&const DeepCollectionEquality().equals(other._summary, _summary));
}


@override
int get hashCode => Object.hash(runtimeType,connected,const DeepCollectionEquality().hash(_summary));

@override
String toString() {
  return 'DeviceSummaryState(connected: $connected, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$DeviceSummaryStateCopyWith<$Res> implements $DeviceSummaryStateCopyWith<$Res> {
  factory _$DeviceSummaryStateCopyWith(_DeviceSummaryState value, $Res Function(_DeviceSummaryState) _then) = __$DeviceSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 bool connected, Map<String, dynamic>? summary
});




}
/// @nodoc
class __$DeviceSummaryStateCopyWithImpl<$Res>
    implements _$DeviceSummaryStateCopyWith<$Res> {
  __$DeviceSummaryStateCopyWithImpl(this._self, this._then);

  final _DeviceSummaryState _self;
  final $Res Function(_DeviceSummaryState) _then;

/// Create a copy of DeviceSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connected = null,Object? summary = freezed,}) {
  return _then(_DeviceSummaryState(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self._summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
