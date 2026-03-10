// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState()';
}


}

/// @nodoc
class $SessionStateCopyWith<$Res>  {
$SessionStateCopyWith(SessionState _, $Res Function(SessionState) __);
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _Active value)?  active,TResult Function( _Ended value)?  ended,TResult Function( _DeviceError value)?  deviceError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Active() when active != null:
return active(_that);case _Ended() when ended != null:
return ended(_that);case _DeviceError() when deviceError != null:
return deviceError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _Active value)  active,required TResult Function( _Ended value)  ended,required TResult Function( _DeviceError value)  deviceError,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _Active():
return active(_that);case _Ended():
return ended(_that);case _DeviceError():
return deviceError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _Active value)?  active,TResult? Function( _Ended value)?  ended,TResult? Function( _DeviceError value)?  deviceError,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Active() when active != null:
return active(_that);case _Ended() when ended != null:
return ended(_that);case _DeviceError() when deviceError != null:
return deviceError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  active,TResult Function( SessionEndReason reason)?  ended,TResult Function( List<String> errorCodes)?  deviceError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Active() when active != null:
return active();case _Ended() when ended != null:
return ended(_that.reason);case _DeviceError() when deviceError != null:
return deviceError(_that.errorCodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  active,required TResult Function( SessionEndReason reason)  ended,required TResult Function( List<String> errorCodes)  deviceError,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _Active():
return active();case _Ended():
return ended(_that.reason);case _DeviceError():
return deviceError(_that.errorCodes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  active,TResult? Function( SessionEndReason reason)?  ended,TResult? Function( List<String> errorCodes)?  deviceError,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Active() when active != null:
return active();case _Ended() when ended != null:
return ended(_that.reason);case _DeviceError() when deviceError != null:
return deviceError(_that.errorCodes);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements SessionState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.idle()';
}


}




/// @nodoc


class _Active implements SessionState {
  const _Active();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Active);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.active()';
}


}




/// @nodoc


class _Ended implements SessionState {
  const _Ended({required this.reason});
  

 final  SessionEndReason reason;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndedCopyWith<_Ended> get copyWith => __$EndedCopyWithImpl<_Ended>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ended&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SessionState.ended(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$EndedCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$EndedCopyWith(_Ended value, $Res Function(_Ended) _then) = __$EndedCopyWithImpl;
@useResult
$Res call({
 SessionEndReason reason
});




}
/// @nodoc
class __$EndedCopyWithImpl<$Res>
    implements _$EndedCopyWith<$Res> {
  __$EndedCopyWithImpl(this._self, this._then);

  final _Ended _self;
  final $Res Function(_Ended) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_Ended(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SessionEndReason,
  ));
}


}

/// @nodoc


class _DeviceError implements SessionState {
  const _DeviceError({required final  List<String> errorCodes}): _errorCodes = errorCodes;
  

 final  List<String> _errorCodes;
 List<String> get errorCodes {
  if (_errorCodes is EqualUnmodifiableListView) return _errorCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errorCodes);
}


/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceErrorCopyWith<_DeviceError> get copyWith => __$DeviceErrorCopyWithImpl<_DeviceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceError&&const DeepCollectionEquality().equals(other._errorCodes, _errorCodes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_errorCodes));

@override
String toString() {
  return 'SessionState.deviceError(errorCodes: $errorCodes)';
}


}

/// @nodoc
abstract mixin class _$DeviceErrorCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$DeviceErrorCopyWith(_DeviceError value, $Res Function(_DeviceError) _then) = __$DeviceErrorCopyWithImpl;
@useResult
$Res call({
 List<String> errorCodes
});




}
/// @nodoc
class __$DeviceErrorCopyWithImpl<$Res>
    implements _$DeviceErrorCopyWith<$Res> {
  __$DeviceErrorCopyWithImpl(this._self, this._then);

  final _DeviceError _self;
  final $Res Function(_DeviceError) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorCodes = null,}) {
  return _then(_DeviceError(
errorCodes: null == errorCodes ? _self._errorCodes : errorCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
