// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceAuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceAuthState()';
}


}

/// @nodoc
class $DeviceAuthStateCopyWith<$Res>  {
$DeviceAuthStateCopyWith(DeviceAuthState _, $Res Function(DeviceAuthState) __);
}


/// Adds pattern-matching-related methods to [DeviceAuthState].
extension DeviceAuthStatePatterns on DeviceAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceAuthInitial value)?  initial,TResult Function( DeviceAuthNotLoggedIn value)?  notLoggedIn,TResult Function( DeviceAuthLoggingIn value)?  loggingIn,TResult Function( DeviceAuthLoggedIn value)?  loggedIn,TResult Function( DeviceAuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceAuthInitial() when initial != null:
return initial(_that);case DeviceAuthNotLoggedIn() when notLoggedIn != null:
return notLoggedIn(_that);case DeviceAuthLoggingIn() when loggingIn != null:
return loggingIn(_that);case DeviceAuthLoggedIn() when loggedIn != null:
return loggedIn(_that);case DeviceAuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceAuthInitial value)  initial,required TResult Function( DeviceAuthNotLoggedIn value)  notLoggedIn,required TResult Function( DeviceAuthLoggingIn value)  loggingIn,required TResult Function( DeviceAuthLoggedIn value)  loggedIn,required TResult Function( DeviceAuthError value)  error,}){
final _that = this;
switch (_that) {
case DeviceAuthInitial():
return initial(_that);case DeviceAuthNotLoggedIn():
return notLoggedIn(_that);case DeviceAuthLoggingIn():
return loggingIn(_that);case DeviceAuthLoggedIn():
return loggedIn(_that);case DeviceAuthError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceAuthInitial value)?  initial,TResult? Function( DeviceAuthNotLoggedIn value)?  notLoggedIn,TResult? Function( DeviceAuthLoggingIn value)?  loggingIn,TResult? Function( DeviceAuthLoggedIn value)?  loggedIn,TResult? Function( DeviceAuthError value)?  error,}){
final _that = this;
switch (_that) {
case DeviceAuthInitial() when initial != null:
return initial(_that);case DeviceAuthNotLoggedIn() when notLoggedIn != null:
return notLoggedIn(_that);case DeviceAuthLoggingIn() when loggingIn != null:
return loggingIn(_that);case DeviceAuthLoggedIn() when loggedIn != null:
return loggedIn(_that);case DeviceAuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  notLoggedIn,TResult Function()?  loggingIn,TResult Function( String devicePassword,  String? deviceId,  String? deviceName)?  loggedIn,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceAuthInitial() when initial != null:
return initial();case DeviceAuthNotLoggedIn() when notLoggedIn != null:
return notLoggedIn();case DeviceAuthLoggingIn() when loggingIn != null:
return loggingIn();case DeviceAuthLoggedIn() when loggedIn != null:
return loggedIn(_that.devicePassword,_that.deviceId,_that.deviceName);case DeviceAuthError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  notLoggedIn,required TResult Function()  loggingIn,required TResult Function( String devicePassword,  String? deviceId,  String? deviceName)  loggedIn,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case DeviceAuthInitial():
return initial();case DeviceAuthNotLoggedIn():
return notLoggedIn();case DeviceAuthLoggingIn():
return loggingIn();case DeviceAuthLoggedIn():
return loggedIn(_that.devicePassword,_that.deviceId,_that.deviceName);case DeviceAuthError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  notLoggedIn,TResult? Function()?  loggingIn,TResult? Function( String devicePassword,  String? deviceId,  String? deviceName)?  loggedIn,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case DeviceAuthInitial() when initial != null:
return initial();case DeviceAuthNotLoggedIn() when notLoggedIn != null:
return notLoggedIn();case DeviceAuthLoggingIn() when loggingIn != null:
return loggingIn();case DeviceAuthLoggedIn() when loggedIn != null:
return loggedIn(_that.devicePassword,_that.deviceId,_that.deviceName);case DeviceAuthError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class DeviceAuthInitial implements DeviceAuthState {
  const DeviceAuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceAuthState.initial()';
}


}




/// @nodoc


class DeviceAuthNotLoggedIn implements DeviceAuthState {
  const DeviceAuthNotLoggedIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthNotLoggedIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceAuthState.notLoggedIn()';
}


}




/// @nodoc


class DeviceAuthLoggingIn implements DeviceAuthState {
  const DeviceAuthLoggingIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthLoggingIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeviceAuthState.loggingIn()';
}


}




/// @nodoc


class DeviceAuthLoggedIn implements DeviceAuthState {
  const DeviceAuthLoggedIn({required this.devicePassword, this.deviceId, this.deviceName});
  

 final  String devicePassword;
 final  String? deviceId;
 final  String? deviceName;

/// Create a copy of DeviceAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceAuthLoggedInCopyWith<DeviceAuthLoggedIn> get copyWith => _$DeviceAuthLoggedInCopyWithImpl<DeviceAuthLoggedIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthLoggedIn&&(identical(other.devicePassword, devicePassword) || other.devicePassword == devicePassword)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}


@override
int get hashCode => Object.hash(runtimeType,devicePassword,deviceId,deviceName);

@override
String toString() {
  return 'DeviceAuthState.loggedIn(devicePassword: $devicePassword, deviceId: $deviceId, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class $DeviceAuthLoggedInCopyWith<$Res> implements $DeviceAuthStateCopyWith<$Res> {
  factory $DeviceAuthLoggedInCopyWith(DeviceAuthLoggedIn value, $Res Function(DeviceAuthLoggedIn) _then) = _$DeviceAuthLoggedInCopyWithImpl;
@useResult
$Res call({
 String devicePassword, String? deviceId, String? deviceName
});




}
/// @nodoc
class _$DeviceAuthLoggedInCopyWithImpl<$Res>
    implements $DeviceAuthLoggedInCopyWith<$Res> {
  _$DeviceAuthLoggedInCopyWithImpl(this._self, this._then);

  final DeviceAuthLoggedIn _self;
  final $Res Function(DeviceAuthLoggedIn) _then;

/// Create a copy of DeviceAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? devicePassword = null,Object? deviceId = freezed,Object? deviceName = freezed,}) {
  return _then(DeviceAuthLoggedIn(
devicePassword: null == devicePassword ? _self.devicePassword : devicePassword // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DeviceAuthError implements DeviceAuthState {
  const DeviceAuthError({required this.message});
  

 final  String message;

/// Create a copy of DeviceAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceAuthErrorCopyWith<DeviceAuthError> get copyWith => _$DeviceAuthErrorCopyWithImpl<DeviceAuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceAuthError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DeviceAuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DeviceAuthErrorCopyWith<$Res> implements $DeviceAuthStateCopyWith<$Res> {
  factory $DeviceAuthErrorCopyWith(DeviceAuthError value, $Res Function(DeviceAuthError) _then) = _$DeviceAuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DeviceAuthErrorCopyWithImpl<$Res>
    implements $DeviceAuthErrorCopyWith<$Res> {
  _$DeviceAuthErrorCopyWithImpl(this._self, this._then);

  final DeviceAuthError _self;
  final $Res Function(DeviceAuthError) _then;

/// Create a copy of DeviceAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DeviceAuthError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
