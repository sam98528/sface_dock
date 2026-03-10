// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceLoginResponse {

 bool get success; String? get message; DeviceLoginData? get data;
/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceLoginResponseCopyWith<DeviceLoginResponse> get copyWith => _$DeviceLoginResponseCopyWithImpl<DeviceLoginResponse>(this as DeviceLoginResponse, _$identity);

  /// Serializes this DeviceLoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceLoginResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'DeviceLoginResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $DeviceLoginResponseCopyWith<$Res>  {
  factory $DeviceLoginResponseCopyWith(DeviceLoginResponse value, $Res Function(DeviceLoginResponse) _then) = _$DeviceLoginResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String? message, DeviceLoginData? data
});


$DeviceLoginDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$DeviceLoginResponseCopyWithImpl<$Res>
    implements $DeviceLoginResponseCopyWith<$Res> {
  _$DeviceLoginResponseCopyWithImpl(this._self, this._then);

  final DeviceLoginResponse _self;
  final $Res Function(DeviceLoginResponse) _then;

/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DeviceLoginData?,
  ));
}
/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceLoginDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DeviceLoginDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceLoginResponse].
extension DeviceLoginResponsePatterns on DeviceLoginResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceLoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceLoginResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceLoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeviceLoginResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceLoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceLoginResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? message,  DeviceLoginData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceLoginResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? message,  DeviceLoginData? data)  $default,) {final _that = this;
switch (_that) {
case _DeviceLoginResponse():
return $default(_that.success,_that.message,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? message,  DeviceLoginData? data)?  $default,) {final _that = this;
switch (_that) {
case _DeviceLoginResponse() when $default != null:
return $default(_that.success,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceLoginResponse implements DeviceLoginResponse {
  const _DeviceLoginResponse({required this.success, this.message, this.data});
  factory _DeviceLoginResponse.fromJson(Map<String, dynamic> json) => _$DeviceLoginResponseFromJson(json);

@override final  bool success;
@override final  String? message;
@override final  DeviceLoginData? data;

/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceLoginResponseCopyWith<_DeviceLoginResponse> get copyWith => __$DeviceLoginResponseCopyWithImpl<_DeviceLoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceLoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceLoginResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data);

@override
String toString() {
  return 'DeviceLoginResponse(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$DeviceLoginResponseCopyWith<$Res> implements $DeviceLoginResponseCopyWith<$Res> {
  factory _$DeviceLoginResponseCopyWith(_DeviceLoginResponse value, $Res Function(_DeviceLoginResponse) _then) = __$DeviceLoginResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? message, DeviceLoginData? data
});


@override $DeviceLoginDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$DeviceLoginResponseCopyWithImpl<$Res>
    implements _$DeviceLoginResponseCopyWith<$Res> {
  __$DeviceLoginResponseCopyWithImpl(this._self, this._then);

  final _DeviceLoginResponse _self;
  final $Res Function(_DeviceLoginResponse) _then;

/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = freezed,}) {
  return _then(_DeviceLoginResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DeviceLoginData?,
  ));
}

/// Create a copy of DeviceLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceLoginDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DeviceLoginDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$DeviceLoginData {

// ignore: non_constant_identifier_names
 String? get device_id;// ignore: non_constant_identifier_names
 String? get device_name;// ignore: non_constant_identifier_names
 String? get device_password;
/// Create a copy of DeviceLoginData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceLoginDataCopyWith<DeviceLoginData> get copyWith => _$DeviceLoginDataCopyWithImpl<DeviceLoginData>(this as DeviceLoginData, _$identity);

  /// Serializes this DeviceLoginData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceLoginData&&(identical(other.device_id, device_id) || other.device_id == device_id)&&(identical(other.device_name, device_name) || other.device_name == device_name)&&(identical(other.device_password, device_password) || other.device_password == device_password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,device_id,device_name,device_password);

@override
String toString() {
  return 'DeviceLoginData(device_id: $device_id, device_name: $device_name, device_password: $device_password)';
}


}

/// @nodoc
abstract mixin class $DeviceLoginDataCopyWith<$Res>  {
  factory $DeviceLoginDataCopyWith(DeviceLoginData value, $Res Function(DeviceLoginData) _then) = _$DeviceLoginDataCopyWithImpl;
@useResult
$Res call({
 String? device_id, String? device_name, String? device_password
});




}
/// @nodoc
class _$DeviceLoginDataCopyWithImpl<$Res>
    implements $DeviceLoginDataCopyWith<$Res> {
  _$DeviceLoginDataCopyWithImpl(this._self, this._then);

  final DeviceLoginData _self;
  final $Res Function(DeviceLoginData) _then;

/// Create a copy of DeviceLoginData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device_id = freezed,Object? device_name = freezed,Object? device_password = freezed,}) {
  return _then(_self.copyWith(
device_id: freezed == device_id ? _self.device_id : device_id // ignore: cast_nullable_to_non_nullable
as String?,device_name: freezed == device_name ? _self.device_name : device_name // ignore: cast_nullable_to_non_nullable
as String?,device_password: freezed == device_password ? _self.device_password : device_password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceLoginData].
extension DeviceLoginDataPatterns on DeviceLoginData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceLoginData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceLoginData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceLoginData value)  $default,){
final _that = this;
switch (_that) {
case _DeviceLoginData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceLoginData value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceLoginData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? device_id,  String? device_name,  String? device_password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceLoginData() when $default != null:
return $default(_that.device_id,_that.device_name,_that.device_password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? device_id,  String? device_name,  String? device_password)  $default,) {final _that = this;
switch (_that) {
case _DeviceLoginData():
return $default(_that.device_id,_that.device_name,_that.device_password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? device_id,  String? device_name,  String? device_password)?  $default,) {final _that = this;
switch (_that) {
case _DeviceLoginData() when $default != null:
return $default(_that.device_id,_that.device_name,_that.device_password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceLoginData implements DeviceLoginData {
  const _DeviceLoginData({this.device_id, this.device_name, this.device_password});
  factory _DeviceLoginData.fromJson(Map<String, dynamic> json) => _$DeviceLoginDataFromJson(json);

// ignore: non_constant_identifier_names
@override final  String? device_id;
// ignore: non_constant_identifier_names
@override final  String? device_name;
// ignore: non_constant_identifier_names
@override final  String? device_password;

/// Create a copy of DeviceLoginData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceLoginDataCopyWith<_DeviceLoginData> get copyWith => __$DeviceLoginDataCopyWithImpl<_DeviceLoginData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceLoginDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceLoginData&&(identical(other.device_id, device_id) || other.device_id == device_id)&&(identical(other.device_name, device_name) || other.device_name == device_name)&&(identical(other.device_password, device_password) || other.device_password == device_password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,device_id,device_name,device_password);

@override
String toString() {
  return 'DeviceLoginData(device_id: $device_id, device_name: $device_name, device_password: $device_password)';
}


}

/// @nodoc
abstract mixin class _$DeviceLoginDataCopyWith<$Res> implements $DeviceLoginDataCopyWith<$Res> {
  factory _$DeviceLoginDataCopyWith(_DeviceLoginData value, $Res Function(_DeviceLoginData) _then) = __$DeviceLoginDataCopyWithImpl;
@override @useResult
$Res call({
 String? device_id, String? device_name, String? device_password
});




}
/// @nodoc
class __$DeviceLoginDataCopyWithImpl<$Res>
    implements _$DeviceLoginDataCopyWith<$Res> {
  __$DeviceLoginDataCopyWithImpl(this._self, this._then);

  final _DeviceLoginData _self;
  final $Res Function(_DeviceLoginData) _then;

/// Create a copy of DeviceLoginData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device_id = freezed,Object? device_name = freezed,Object? device_password = freezed,}) {
  return _then(_DeviceLoginData(
device_id: freezed == device_id ? _self.device_id : device_id // ignore: cast_nullable_to_non_nullable
as String?,device_name: freezed == device_name ? _self.device_name : device_name // ignore: cast_nullable_to_non_nullable
as String?,device_password: freezed == device_password ? _self.device_password : device_password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateDeviceRequest {

// ignore: non_constant_identifier_names
 String? get device_name;// ignore: non_constant_identifier_names
 String? get software_type;// ignore: non_constant_identifier_names
 bool? get is_active;// ignore: non_constant_identifier_names
 bool? get allow_update;// ignore: non_constant_identifier_names
 bool? get disabled_select_filter;// ignore: non_constant_identifier_names
 String? get app_version;// ignore: non_constant_identifier_names
 String? get before_app_version;// ignore: non_constant_identifier_names
 bool? get is_tester;// ignore: non_constant_identifier_names
 bool? get allow_select_paper_type;// ignore: non_constant_identifier_names
 bool? get enabled_basic_paper;// ignore: non_constant_identifier_names
 String? get additional_paper_types;// ignore: non_constant_identifier_names
 int? get remotecon_type;// ignore: non_constant_identifier_names
 String? get camera_angle;// ignore: non_constant_identifier_names
 String? get camera_model;// ignore: non_constant_identifier_names
 String? get camera_lens;// ignore: non_constant_identifier_names
 String? get printer_model;// ignore: non_constant_identifier_names
 int? get printer_lifecounter;// ignore: non_constant_identifier_names
 String? get printer_remaining;// ignore: non_constant_identifier_names
 String? get payment_methods;// ignore: non_constant_identifier_names
 String? get cardreader_num;// ignore: non_constant_identifier_names
 String? get billacceptor_num;// ignore: non_constant_identifier_names
 String? get print_types;// ignore: non_constant_identifier_names
 String? get photo_types;// ignore: non_constant_identifier_names
 String? get liveview_modes; String? get note;// ignore: non_constant_identifier_names
 bool? get print_greyscale_additional;// ignore: non_constant_identifier_names
 bool? get fix_print_quantity;// ignore: non_constant_identifier_names
 int? get winning_probability;// ignore: non_constant_identifier_names
 int? get liveview_timer_countDown;// ignore: non_constant_identifier_names
 int? get liveview_timer_remote;// ignore: non_constant_identifier_names
 int? get liveview_timer_remote_cont;// ignore: non_constant_identifier_names
 String? get send_userphotos_methods;// ignore: non_constant_identifier_names
 bool? get is_offline_mode;// ignore: non_constant_identifier_names
 String? get is_verified;
/// Create a copy of UpdateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDeviceRequestCopyWith<UpdateDeviceRequest> get copyWith => _$UpdateDeviceRequestCopyWithImpl<UpdateDeviceRequest>(this as UpdateDeviceRequest, _$identity);

  /// Serializes this UpdateDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDeviceRequest&&(identical(other.device_name, device_name) || other.device_name == device_name)&&(identical(other.software_type, software_type) || other.software_type == software_type)&&(identical(other.is_active, is_active) || other.is_active == is_active)&&(identical(other.allow_update, allow_update) || other.allow_update == allow_update)&&(identical(other.disabled_select_filter, disabled_select_filter) || other.disabled_select_filter == disabled_select_filter)&&(identical(other.app_version, app_version) || other.app_version == app_version)&&(identical(other.before_app_version, before_app_version) || other.before_app_version == before_app_version)&&(identical(other.is_tester, is_tester) || other.is_tester == is_tester)&&(identical(other.allow_select_paper_type, allow_select_paper_type) || other.allow_select_paper_type == allow_select_paper_type)&&(identical(other.enabled_basic_paper, enabled_basic_paper) || other.enabled_basic_paper == enabled_basic_paper)&&(identical(other.additional_paper_types, additional_paper_types) || other.additional_paper_types == additional_paper_types)&&(identical(other.remotecon_type, remotecon_type) || other.remotecon_type == remotecon_type)&&(identical(other.camera_angle, camera_angle) || other.camera_angle == camera_angle)&&(identical(other.camera_model, camera_model) || other.camera_model == camera_model)&&(identical(other.camera_lens, camera_lens) || other.camera_lens == camera_lens)&&(identical(other.printer_model, printer_model) || other.printer_model == printer_model)&&(identical(other.printer_lifecounter, printer_lifecounter) || other.printer_lifecounter == printer_lifecounter)&&(identical(other.printer_remaining, printer_remaining) || other.printer_remaining == printer_remaining)&&(identical(other.payment_methods, payment_methods) || other.payment_methods == payment_methods)&&(identical(other.cardreader_num, cardreader_num) || other.cardreader_num == cardreader_num)&&(identical(other.billacceptor_num, billacceptor_num) || other.billacceptor_num == billacceptor_num)&&(identical(other.print_types, print_types) || other.print_types == print_types)&&(identical(other.photo_types, photo_types) || other.photo_types == photo_types)&&(identical(other.liveview_modes, liveview_modes) || other.liveview_modes == liveview_modes)&&(identical(other.note, note) || other.note == note)&&(identical(other.print_greyscale_additional, print_greyscale_additional) || other.print_greyscale_additional == print_greyscale_additional)&&(identical(other.fix_print_quantity, fix_print_quantity) || other.fix_print_quantity == fix_print_quantity)&&(identical(other.winning_probability, winning_probability) || other.winning_probability == winning_probability)&&(identical(other.liveview_timer_countDown, liveview_timer_countDown) || other.liveview_timer_countDown == liveview_timer_countDown)&&(identical(other.liveview_timer_remote, liveview_timer_remote) || other.liveview_timer_remote == liveview_timer_remote)&&(identical(other.liveview_timer_remote_cont, liveview_timer_remote_cont) || other.liveview_timer_remote_cont == liveview_timer_remote_cont)&&(identical(other.send_userphotos_methods, send_userphotos_methods) || other.send_userphotos_methods == send_userphotos_methods)&&(identical(other.is_offline_mode, is_offline_mode) || other.is_offline_mode == is_offline_mode)&&(identical(other.is_verified, is_verified) || other.is_verified == is_verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,device_name,software_type,is_active,allow_update,disabled_select_filter,app_version,before_app_version,is_tester,allow_select_paper_type,enabled_basic_paper,additional_paper_types,remotecon_type,camera_angle,camera_model,camera_lens,printer_model,printer_lifecounter,printer_remaining,payment_methods,cardreader_num,billacceptor_num,print_types,photo_types,liveview_modes,note,print_greyscale_additional,fix_print_quantity,winning_probability,liveview_timer_countDown,liveview_timer_remote,liveview_timer_remote_cont,send_userphotos_methods,is_offline_mode,is_verified]);

@override
String toString() {
  return 'UpdateDeviceRequest(device_name: $device_name, software_type: $software_type, is_active: $is_active, allow_update: $allow_update, disabled_select_filter: $disabled_select_filter, app_version: $app_version, before_app_version: $before_app_version, is_tester: $is_tester, allow_select_paper_type: $allow_select_paper_type, enabled_basic_paper: $enabled_basic_paper, additional_paper_types: $additional_paper_types, remotecon_type: $remotecon_type, camera_angle: $camera_angle, camera_model: $camera_model, camera_lens: $camera_lens, printer_model: $printer_model, printer_lifecounter: $printer_lifecounter, printer_remaining: $printer_remaining, payment_methods: $payment_methods, cardreader_num: $cardreader_num, billacceptor_num: $billacceptor_num, print_types: $print_types, photo_types: $photo_types, liveview_modes: $liveview_modes, note: $note, print_greyscale_additional: $print_greyscale_additional, fix_print_quantity: $fix_print_quantity, winning_probability: $winning_probability, liveview_timer_countDown: $liveview_timer_countDown, liveview_timer_remote: $liveview_timer_remote, liveview_timer_remote_cont: $liveview_timer_remote_cont, send_userphotos_methods: $send_userphotos_methods, is_offline_mode: $is_offline_mode, is_verified: $is_verified)';
}


}

/// @nodoc
abstract mixin class $UpdateDeviceRequestCopyWith<$Res>  {
  factory $UpdateDeviceRequestCopyWith(UpdateDeviceRequest value, $Res Function(UpdateDeviceRequest) _then) = _$UpdateDeviceRequestCopyWithImpl;
@useResult
$Res call({
 String? device_name, String? software_type, bool? is_active, bool? allow_update, bool? disabled_select_filter, String? app_version, String? before_app_version, bool? is_tester, bool? allow_select_paper_type, bool? enabled_basic_paper, String? additional_paper_types, int? remotecon_type, String? camera_angle, String? camera_model, String? camera_lens, String? printer_model, int? printer_lifecounter, String? printer_remaining, String? payment_methods, String? cardreader_num, String? billacceptor_num, String? print_types, String? photo_types, String? liveview_modes, String? note, bool? print_greyscale_additional, bool? fix_print_quantity, int? winning_probability, int? liveview_timer_countDown, int? liveview_timer_remote, int? liveview_timer_remote_cont, String? send_userphotos_methods, bool? is_offline_mode, String? is_verified
});




}
/// @nodoc
class _$UpdateDeviceRequestCopyWithImpl<$Res>
    implements $UpdateDeviceRequestCopyWith<$Res> {
  _$UpdateDeviceRequestCopyWithImpl(this._self, this._then);

  final UpdateDeviceRequest _self;
  final $Res Function(UpdateDeviceRequest) _then;

/// Create a copy of UpdateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device_name = freezed,Object? software_type = freezed,Object? is_active = freezed,Object? allow_update = freezed,Object? disabled_select_filter = freezed,Object? app_version = freezed,Object? before_app_version = freezed,Object? is_tester = freezed,Object? allow_select_paper_type = freezed,Object? enabled_basic_paper = freezed,Object? additional_paper_types = freezed,Object? remotecon_type = freezed,Object? camera_angle = freezed,Object? camera_model = freezed,Object? camera_lens = freezed,Object? printer_model = freezed,Object? printer_lifecounter = freezed,Object? printer_remaining = freezed,Object? payment_methods = freezed,Object? cardreader_num = freezed,Object? billacceptor_num = freezed,Object? print_types = freezed,Object? photo_types = freezed,Object? liveview_modes = freezed,Object? note = freezed,Object? print_greyscale_additional = freezed,Object? fix_print_quantity = freezed,Object? winning_probability = freezed,Object? liveview_timer_countDown = freezed,Object? liveview_timer_remote = freezed,Object? liveview_timer_remote_cont = freezed,Object? send_userphotos_methods = freezed,Object? is_offline_mode = freezed,Object? is_verified = freezed,}) {
  return _then(_self.copyWith(
device_name: freezed == device_name ? _self.device_name : device_name // ignore: cast_nullable_to_non_nullable
as String?,software_type: freezed == software_type ? _self.software_type : software_type // ignore: cast_nullable_to_non_nullable
as String?,is_active: freezed == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool?,allow_update: freezed == allow_update ? _self.allow_update : allow_update // ignore: cast_nullable_to_non_nullable
as bool?,disabled_select_filter: freezed == disabled_select_filter ? _self.disabled_select_filter : disabled_select_filter // ignore: cast_nullable_to_non_nullable
as bool?,app_version: freezed == app_version ? _self.app_version : app_version // ignore: cast_nullable_to_non_nullable
as String?,before_app_version: freezed == before_app_version ? _self.before_app_version : before_app_version // ignore: cast_nullable_to_non_nullable
as String?,is_tester: freezed == is_tester ? _self.is_tester : is_tester // ignore: cast_nullable_to_non_nullable
as bool?,allow_select_paper_type: freezed == allow_select_paper_type ? _self.allow_select_paper_type : allow_select_paper_type // ignore: cast_nullable_to_non_nullable
as bool?,enabled_basic_paper: freezed == enabled_basic_paper ? _self.enabled_basic_paper : enabled_basic_paper // ignore: cast_nullable_to_non_nullable
as bool?,additional_paper_types: freezed == additional_paper_types ? _self.additional_paper_types : additional_paper_types // ignore: cast_nullable_to_non_nullable
as String?,remotecon_type: freezed == remotecon_type ? _self.remotecon_type : remotecon_type // ignore: cast_nullable_to_non_nullable
as int?,camera_angle: freezed == camera_angle ? _self.camera_angle : camera_angle // ignore: cast_nullable_to_non_nullable
as String?,camera_model: freezed == camera_model ? _self.camera_model : camera_model // ignore: cast_nullable_to_non_nullable
as String?,camera_lens: freezed == camera_lens ? _self.camera_lens : camera_lens // ignore: cast_nullable_to_non_nullable
as String?,printer_model: freezed == printer_model ? _self.printer_model : printer_model // ignore: cast_nullable_to_non_nullable
as String?,printer_lifecounter: freezed == printer_lifecounter ? _self.printer_lifecounter : printer_lifecounter // ignore: cast_nullable_to_non_nullable
as int?,printer_remaining: freezed == printer_remaining ? _self.printer_remaining : printer_remaining // ignore: cast_nullable_to_non_nullable
as String?,payment_methods: freezed == payment_methods ? _self.payment_methods : payment_methods // ignore: cast_nullable_to_non_nullable
as String?,cardreader_num: freezed == cardreader_num ? _self.cardreader_num : cardreader_num // ignore: cast_nullable_to_non_nullable
as String?,billacceptor_num: freezed == billacceptor_num ? _self.billacceptor_num : billacceptor_num // ignore: cast_nullable_to_non_nullable
as String?,print_types: freezed == print_types ? _self.print_types : print_types // ignore: cast_nullable_to_non_nullable
as String?,photo_types: freezed == photo_types ? _self.photo_types : photo_types // ignore: cast_nullable_to_non_nullable
as String?,liveview_modes: freezed == liveview_modes ? _self.liveview_modes : liveview_modes // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,print_greyscale_additional: freezed == print_greyscale_additional ? _self.print_greyscale_additional : print_greyscale_additional // ignore: cast_nullable_to_non_nullable
as bool?,fix_print_quantity: freezed == fix_print_quantity ? _self.fix_print_quantity : fix_print_quantity // ignore: cast_nullable_to_non_nullable
as bool?,winning_probability: freezed == winning_probability ? _self.winning_probability : winning_probability // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_countDown: freezed == liveview_timer_countDown ? _self.liveview_timer_countDown : liveview_timer_countDown // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_remote: freezed == liveview_timer_remote ? _self.liveview_timer_remote : liveview_timer_remote // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_remote_cont: freezed == liveview_timer_remote_cont ? _self.liveview_timer_remote_cont : liveview_timer_remote_cont // ignore: cast_nullable_to_non_nullable
as int?,send_userphotos_methods: freezed == send_userphotos_methods ? _self.send_userphotos_methods : send_userphotos_methods // ignore: cast_nullable_to_non_nullable
as String?,is_offline_mode: freezed == is_offline_mode ? _self.is_offline_mode : is_offline_mode // ignore: cast_nullable_to_non_nullable
as bool?,is_verified: freezed == is_verified ? _self.is_verified : is_verified // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateDeviceRequest].
extension UpdateDeviceRequestPatterns on UpdateDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? device_name,  String? software_type,  bool? is_active,  bool? allow_update,  bool? disabled_select_filter,  String? app_version,  String? before_app_version,  bool? is_tester,  bool? allow_select_paper_type,  bool? enabled_basic_paper,  String? additional_paper_types,  int? remotecon_type,  String? camera_angle,  String? camera_model,  String? camera_lens,  String? printer_model,  int? printer_lifecounter,  String? printer_remaining,  String? payment_methods,  String? cardreader_num,  String? billacceptor_num,  String? print_types,  String? photo_types,  String? liveview_modes,  String? note,  bool? print_greyscale_additional,  bool? fix_print_quantity,  int? winning_probability,  int? liveview_timer_countDown,  int? liveview_timer_remote,  int? liveview_timer_remote_cont,  String? send_userphotos_methods,  bool? is_offline_mode,  String? is_verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateDeviceRequest() when $default != null:
return $default(_that.device_name,_that.software_type,_that.is_active,_that.allow_update,_that.disabled_select_filter,_that.app_version,_that.before_app_version,_that.is_tester,_that.allow_select_paper_type,_that.enabled_basic_paper,_that.additional_paper_types,_that.remotecon_type,_that.camera_angle,_that.camera_model,_that.camera_lens,_that.printer_model,_that.printer_lifecounter,_that.printer_remaining,_that.payment_methods,_that.cardreader_num,_that.billacceptor_num,_that.print_types,_that.photo_types,_that.liveview_modes,_that.note,_that.print_greyscale_additional,_that.fix_print_quantity,_that.winning_probability,_that.liveview_timer_countDown,_that.liveview_timer_remote,_that.liveview_timer_remote_cont,_that.send_userphotos_methods,_that.is_offline_mode,_that.is_verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? device_name,  String? software_type,  bool? is_active,  bool? allow_update,  bool? disabled_select_filter,  String? app_version,  String? before_app_version,  bool? is_tester,  bool? allow_select_paper_type,  bool? enabled_basic_paper,  String? additional_paper_types,  int? remotecon_type,  String? camera_angle,  String? camera_model,  String? camera_lens,  String? printer_model,  int? printer_lifecounter,  String? printer_remaining,  String? payment_methods,  String? cardreader_num,  String? billacceptor_num,  String? print_types,  String? photo_types,  String? liveview_modes,  String? note,  bool? print_greyscale_additional,  bool? fix_print_quantity,  int? winning_probability,  int? liveview_timer_countDown,  int? liveview_timer_remote,  int? liveview_timer_remote_cont,  String? send_userphotos_methods,  bool? is_offline_mode,  String? is_verified)  $default,) {final _that = this;
switch (_that) {
case _UpdateDeviceRequest():
return $default(_that.device_name,_that.software_type,_that.is_active,_that.allow_update,_that.disabled_select_filter,_that.app_version,_that.before_app_version,_that.is_tester,_that.allow_select_paper_type,_that.enabled_basic_paper,_that.additional_paper_types,_that.remotecon_type,_that.camera_angle,_that.camera_model,_that.camera_lens,_that.printer_model,_that.printer_lifecounter,_that.printer_remaining,_that.payment_methods,_that.cardreader_num,_that.billacceptor_num,_that.print_types,_that.photo_types,_that.liveview_modes,_that.note,_that.print_greyscale_additional,_that.fix_print_quantity,_that.winning_probability,_that.liveview_timer_countDown,_that.liveview_timer_remote,_that.liveview_timer_remote_cont,_that.send_userphotos_methods,_that.is_offline_mode,_that.is_verified);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? device_name,  String? software_type,  bool? is_active,  bool? allow_update,  bool? disabled_select_filter,  String? app_version,  String? before_app_version,  bool? is_tester,  bool? allow_select_paper_type,  bool? enabled_basic_paper,  String? additional_paper_types,  int? remotecon_type,  String? camera_angle,  String? camera_model,  String? camera_lens,  String? printer_model,  int? printer_lifecounter,  String? printer_remaining,  String? payment_methods,  String? cardreader_num,  String? billacceptor_num,  String? print_types,  String? photo_types,  String? liveview_modes,  String? note,  bool? print_greyscale_additional,  bool? fix_print_quantity,  int? winning_probability,  int? liveview_timer_countDown,  int? liveview_timer_remote,  int? liveview_timer_remote_cont,  String? send_userphotos_methods,  bool? is_offline_mode,  String? is_verified)?  $default,) {final _that = this;
switch (_that) {
case _UpdateDeviceRequest() when $default != null:
return $default(_that.device_name,_that.software_type,_that.is_active,_that.allow_update,_that.disabled_select_filter,_that.app_version,_that.before_app_version,_that.is_tester,_that.allow_select_paper_type,_that.enabled_basic_paper,_that.additional_paper_types,_that.remotecon_type,_that.camera_angle,_that.camera_model,_that.camera_lens,_that.printer_model,_that.printer_lifecounter,_that.printer_remaining,_that.payment_methods,_that.cardreader_num,_that.billacceptor_num,_that.print_types,_that.photo_types,_that.liveview_modes,_that.note,_that.print_greyscale_additional,_that.fix_print_quantity,_that.winning_probability,_that.liveview_timer_countDown,_that.liveview_timer_remote,_that.liveview_timer_remote_cont,_that.send_userphotos_methods,_that.is_offline_mode,_that.is_verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateDeviceRequest implements UpdateDeviceRequest {
  const _UpdateDeviceRequest({this.device_name, this.software_type, this.is_active, this.allow_update, this.disabled_select_filter, this.app_version, this.before_app_version, this.is_tester, this.allow_select_paper_type, this.enabled_basic_paper, this.additional_paper_types, this.remotecon_type, this.camera_angle, this.camera_model, this.camera_lens, this.printer_model, this.printer_lifecounter, this.printer_remaining, this.payment_methods, this.cardreader_num, this.billacceptor_num, this.print_types, this.photo_types, this.liveview_modes, this.note, this.print_greyscale_additional, this.fix_print_quantity, this.winning_probability, this.liveview_timer_countDown, this.liveview_timer_remote, this.liveview_timer_remote_cont, this.send_userphotos_methods, this.is_offline_mode, this.is_verified});
  factory _UpdateDeviceRequest.fromJson(Map<String, dynamic> json) => _$UpdateDeviceRequestFromJson(json);

// ignore: non_constant_identifier_names
@override final  String? device_name;
// ignore: non_constant_identifier_names
@override final  String? software_type;
// ignore: non_constant_identifier_names
@override final  bool? is_active;
// ignore: non_constant_identifier_names
@override final  bool? allow_update;
// ignore: non_constant_identifier_names
@override final  bool? disabled_select_filter;
// ignore: non_constant_identifier_names
@override final  String? app_version;
// ignore: non_constant_identifier_names
@override final  String? before_app_version;
// ignore: non_constant_identifier_names
@override final  bool? is_tester;
// ignore: non_constant_identifier_names
@override final  bool? allow_select_paper_type;
// ignore: non_constant_identifier_names
@override final  bool? enabled_basic_paper;
// ignore: non_constant_identifier_names
@override final  String? additional_paper_types;
// ignore: non_constant_identifier_names
@override final  int? remotecon_type;
// ignore: non_constant_identifier_names
@override final  String? camera_angle;
// ignore: non_constant_identifier_names
@override final  String? camera_model;
// ignore: non_constant_identifier_names
@override final  String? camera_lens;
// ignore: non_constant_identifier_names
@override final  String? printer_model;
// ignore: non_constant_identifier_names
@override final  int? printer_lifecounter;
// ignore: non_constant_identifier_names
@override final  String? printer_remaining;
// ignore: non_constant_identifier_names
@override final  String? payment_methods;
// ignore: non_constant_identifier_names
@override final  String? cardreader_num;
// ignore: non_constant_identifier_names
@override final  String? billacceptor_num;
// ignore: non_constant_identifier_names
@override final  String? print_types;
// ignore: non_constant_identifier_names
@override final  String? photo_types;
// ignore: non_constant_identifier_names
@override final  String? liveview_modes;
@override final  String? note;
// ignore: non_constant_identifier_names
@override final  bool? print_greyscale_additional;
// ignore: non_constant_identifier_names
@override final  bool? fix_print_quantity;
// ignore: non_constant_identifier_names
@override final  int? winning_probability;
// ignore: non_constant_identifier_names
@override final  int? liveview_timer_countDown;
// ignore: non_constant_identifier_names
@override final  int? liveview_timer_remote;
// ignore: non_constant_identifier_names
@override final  int? liveview_timer_remote_cont;
// ignore: non_constant_identifier_names
@override final  String? send_userphotos_methods;
// ignore: non_constant_identifier_names
@override final  bool? is_offline_mode;
// ignore: non_constant_identifier_names
@override final  String? is_verified;

/// Create a copy of UpdateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDeviceRequestCopyWith<_UpdateDeviceRequest> get copyWith => __$UpdateDeviceRequestCopyWithImpl<_UpdateDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDeviceRequest&&(identical(other.device_name, device_name) || other.device_name == device_name)&&(identical(other.software_type, software_type) || other.software_type == software_type)&&(identical(other.is_active, is_active) || other.is_active == is_active)&&(identical(other.allow_update, allow_update) || other.allow_update == allow_update)&&(identical(other.disabled_select_filter, disabled_select_filter) || other.disabled_select_filter == disabled_select_filter)&&(identical(other.app_version, app_version) || other.app_version == app_version)&&(identical(other.before_app_version, before_app_version) || other.before_app_version == before_app_version)&&(identical(other.is_tester, is_tester) || other.is_tester == is_tester)&&(identical(other.allow_select_paper_type, allow_select_paper_type) || other.allow_select_paper_type == allow_select_paper_type)&&(identical(other.enabled_basic_paper, enabled_basic_paper) || other.enabled_basic_paper == enabled_basic_paper)&&(identical(other.additional_paper_types, additional_paper_types) || other.additional_paper_types == additional_paper_types)&&(identical(other.remotecon_type, remotecon_type) || other.remotecon_type == remotecon_type)&&(identical(other.camera_angle, camera_angle) || other.camera_angle == camera_angle)&&(identical(other.camera_model, camera_model) || other.camera_model == camera_model)&&(identical(other.camera_lens, camera_lens) || other.camera_lens == camera_lens)&&(identical(other.printer_model, printer_model) || other.printer_model == printer_model)&&(identical(other.printer_lifecounter, printer_lifecounter) || other.printer_lifecounter == printer_lifecounter)&&(identical(other.printer_remaining, printer_remaining) || other.printer_remaining == printer_remaining)&&(identical(other.payment_methods, payment_methods) || other.payment_methods == payment_methods)&&(identical(other.cardreader_num, cardreader_num) || other.cardreader_num == cardreader_num)&&(identical(other.billacceptor_num, billacceptor_num) || other.billacceptor_num == billacceptor_num)&&(identical(other.print_types, print_types) || other.print_types == print_types)&&(identical(other.photo_types, photo_types) || other.photo_types == photo_types)&&(identical(other.liveview_modes, liveview_modes) || other.liveview_modes == liveview_modes)&&(identical(other.note, note) || other.note == note)&&(identical(other.print_greyscale_additional, print_greyscale_additional) || other.print_greyscale_additional == print_greyscale_additional)&&(identical(other.fix_print_quantity, fix_print_quantity) || other.fix_print_quantity == fix_print_quantity)&&(identical(other.winning_probability, winning_probability) || other.winning_probability == winning_probability)&&(identical(other.liveview_timer_countDown, liveview_timer_countDown) || other.liveview_timer_countDown == liveview_timer_countDown)&&(identical(other.liveview_timer_remote, liveview_timer_remote) || other.liveview_timer_remote == liveview_timer_remote)&&(identical(other.liveview_timer_remote_cont, liveview_timer_remote_cont) || other.liveview_timer_remote_cont == liveview_timer_remote_cont)&&(identical(other.send_userphotos_methods, send_userphotos_methods) || other.send_userphotos_methods == send_userphotos_methods)&&(identical(other.is_offline_mode, is_offline_mode) || other.is_offline_mode == is_offline_mode)&&(identical(other.is_verified, is_verified) || other.is_verified == is_verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,device_name,software_type,is_active,allow_update,disabled_select_filter,app_version,before_app_version,is_tester,allow_select_paper_type,enabled_basic_paper,additional_paper_types,remotecon_type,camera_angle,camera_model,camera_lens,printer_model,printer_lifecounter,printer_remaining,payment_methods,cardreader_num,billacceptor_num,print_types,photo_types,liveview_modes,note,print_greyscale_additional,fix_print_quantity,winning_probability,liveview_timer_countDown,liveview_timer_remote,liveview_timer_remote_cont,send_userphotos_methods,is_offline_mode,is_verified]);

@override
String toString() {
  return 'UpdateDeviceRequest(device_name: $device_name, software_type: $software_type, is_active: $is_active, allow_update: $allow_update, disabled_select_filter: $disabled_select_filter, app_version: $app_version, before_app_version: $before_app_version, is_tester: $is_tester, allow_select_paper_type: $allow_select_paper_type, enabled_basic_paper: $enabled_basic_paper, additional_paper_types: $additional_paper_types, remotecon_type: $remotecon_type, camera_angle: $camera_angle, camera_model: $camera_model, camera_lens: $camera_lens, printer_model: $printer_model, printer_lifecounter: $printer_lifecounter, printer_remaining: $printer_remaining, payment_methods: $payment_methods, cardreader_num: $cardreader_num, billacceptor_num: $billacceptor_num, print_types: $print_types, photo_types: $photo_types, liveview_modes: $liveview_modes, note: $note, print_greyscale_additional: $print_greyscale_additional, fix_print_quantity: $fix_print_quantity, winning_probability: $winning_probability, liveview_timer_countDown: $liveview_timer_countDown, liveview_timer_remote: $liveview_timer_remote, liveview_timer_remote_cont: $liveview_timer_remote_cont, send_userphotos_methods: $send_userphotos_methods, is_offline_mode: $is_offline_mode, is_verified: $is_verified)';
}


}

/// @nodoc
abstract mixin class _$UpdateDeviceRequestCopyWith<$Res> implements $UpdateDeviceRequestCopyWith<$Res> {
  factory _$UpdateDeviceRequestCopyWith(_UpdateDeviceRequest value, $Res Function(_UpdateDeviceRequest) _then) = __$UpdateDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 String? device_name, String? software_type, bool? is_active, bool? allow_update, bool? disabled_select_filter, String? app_version, String? before_app_version, bool? is_tester, bool? allow_select_paper_type, bool? enabled_basic_paper, String? additional_paper_types, int? remotecon_type, String? camera_angle, String? camera_model, String? camera_lens, String? printer_model, int? printer_lifecounter, String? printer_remaining, String? payment_methods, String? cardreader_num, String? billacceptor_num, String? print_types, String? photo_types, String? liveview_modes, String? note, bool? print_greyscale_additional, bool? fix_print_quantity, int? winning_probability, int? liveview_timer_countDown, int? liveview_timer_remote, int? liveview_timer_remote_cont, String? send_userphotos_methods, bool? is_offline_mode, String? is_verified
});




}
/// @nodoc
class __$UpdateDeviceRequestCopyWithImpl<$Res>
    implements _$UpdateDeviceRequestCopyWith<$Res> {
  __$UpdateDeviceRequestCopyWithImpl(this._self, this._then);

  final _UpdateDeviceRequest _self;
  final $Res Function(_UpdateDeviceRequest) _then;

/// Create a copy of UpdateDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device_name = freezed,Object? software_type = freezed,Object? is_active = freezed,Object? allow_update = freezed,Object? disabled_select_filter = freezed,Object? app_version = freezed,Object? before_app_version = freezed,Object? is_tester = freezed,Object? allow_select_paper_type = freezed,Object? enabled_basic_paper = freezed,Object? additional_paper_types = freezed,Object? remotecon_type = freezed,Object? camera_angle = freezed,Object? camera_model = freezed,Object? camera_lens = freezed,Object? printer_model = freezed,Object? printer_lifecounter = freezed,Object? printer_remaining = freezed,Object? payment_methods = freezed,Object? cardreader_num = freezed,Object? billacceptor_num = freezed,Object? print_types = freezed,Object? photo_types = freezed,Object? liveview_modes = freezed,Object? note = freezed,Object? print_greyscale_additional = freezed,Object? fix_print_quantity = freezed,Object? winning_probability = freezed,Object? liveview_timer_countDown = freezed,Object? liveview_timer_remote = freezed,Object? liveview_timer_remote_cont = freezed,Object? send_userphotos_methods = freezed,Object? is_offline_mode = freezed,Object? is_verified = freezed,}) {
  return _then(_UpdateDeviceRequest(
device_name: freezed == device_name ? _self.device_name : device_name // ignore: cast_nullable_to_non_nullable
as String?,software_type: freezed == software_type ? _self.software_type : software_type // ignore: cast_nullable_to_non_nullable
as String?,is_active: freezed == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool?,allow_update: freezed == allow_update ? _self.allow_update : allow_update // ignore: cast_nullable_to_non_nullable
as bool?,disabled_select_filter: freezed == disabled_select_filter ? _self.disabled_select_filter : disabled_select_filter // ignore: cast_nullable_to_non_nullable
as bool?,app_version: freezed == app_version ? _self.app_version : app_version // ignore: cast_nullable_to_non_nullable
as String?,before_app_version: freezed == before_app_version ? _self.before_app_version : before_app_version // ignore: cast_nullable_to_non_nullable
as String?,is_tester: freezed == is_tester ? _self.is_tester : is_tester // ignore: cast_nullable_to_non_nullable
as bool?,allow_select_paper_type: freezed == allow_select_paper_type ? _self.allow_select_paper_type : allow_select_paper_type // ignore: cast_nullable_to_non_nullable
as bool?,enabled_basic_paper: freezed == enabled_basic_paper ? _self.enabled_basic_paper : enabled_basic_paper // ignore: cast_nullable_to_non_nullable
as bool?,additional_paper_types: freezed == additional_paper_types ? _self.additional_paper_types : additional_paper_types // ignore: cast_nullable_to_non_nullable
as String?,remotecon_type: freezed == remotecon_type ? _self.remotecon_type : remotecon_type // ignore: cast_nullable_to_non_nullable
as int?,camera_angle: freezed == camera_angle ? _self.camera_angle : camera_angle // ignore: cast_nullable_to_non_nullable
as String?,camera_model: freezed == camera_model ? _self.camera_model : camera_model // ignore: cast_nullable_to_non_nullable
as String?,camera_lens: freezed == camera_lens ? _self.camera_lens : camera_lens // ignore: cast_nullable_to_non_nullable
as String?,printer_model: freezed == printer_model ? _self.printer_model : printer_model // ignore: cast_nullable_to_non_nullable
as String?,printer_lifecounter: freezed == printer_lifecounter ? _self.printer_lifecounter : printer_lifecounter // ignore: cast_nullable_to_non_nullable
as int?,printer_remaining: freezed == printer_remaining ? _self.printer_remaining : printer_remaining // ignore: cast_nullable_to_non_nullable
as String?,payment_methods: freezed == payment_methods ? _self.payment_methods : payment_methods // ignore: cast_nullable_to_non_nullable
as String?,cardreader_num: freezed == cardreader_num ? _self.cardreader_num : cardreader_num // ignore: cast_nullable_to_non_nullable
as String?,billacceptor_num: freezed == billacceptor_num ? _self.billacceptor_num : billacceptor_num // ignore: cast_nullable_to_non_nullable
as String?,print_types: freezed == print_types ? _self.print_types : print_types // ignore: cast_nullable_to_non_nullable
as String?,photo_types: freezed == photo_types ? _self.photo_types : photo_types // ignore: cast_nullable_to_non_nullable
as String?,liveview_modes: freezed == liveview_modes ? _self.liveview_modes : liveview_modes // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,print_greyscale_additional: freezed == print_greyscale_additional ? _self.print_greyscale_additional : print_greyscale_additional // ignore: cast_nullable_to_non_nullable
as bool?,fix_print_quantity: freezed == fix_print_quantity ? _self.fix_print_quantity : fix_print_quantity // ignore: cast_nullable_to_non_nullable
as bool?,winning_probability: freezed == winning_probability ? _self.winning_probability : winning_probability // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_countDown: freezed == liveview_timer_countDown ? _self.liveview_timer_countDown : liveview_timer_countDown // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_remote: freezed == liveview_timer_remote ? _self.liveview_timer_remote : liveview_timer_remote // ignore: cast_nullable_to_non_nullable
as int?,liveview_timer_remote_cont: freezed == liveview_timer_remote_cont ? _self.liveview_timer_remote_cont : liveview_timer_remote_cont // ignore: cast_nullable_to_non_nullable
as int?,send_userphotos_methods: freezed == send_userphotos_methods ? _self.send_userphotos_methods : send_userphotos_methods // ignore: cast_nullable_to_non_nullable
as String?,is_offline_mode: freezed == is_offline_mode ? _self.is_offline_mode : is_offline_mode // ignore: cast_nullable_to_non_nullable
as bool?,is_verified: freezed == is_verified ? _self.is_verified : is_verified // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApiError {

 int? get statusCode; String? get message; String? get error; int? get code;
/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<ApiError> get copyWith => _$ApiErrorCopyWithImpl<ApiError>(this as ApiError, _$identity);

  /// Serializes this ApiError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiError&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,error,code);

@override
String toString() {
  return 'ApiError(statusCode: $statusCode, message: $message, error: $error, code: $code)';
}


}

/// @nodoc
abstract mixin class $ApiErrorCopyWith<$Res>  {
  factory $ApiErrorCopyWith(ApiError value, $Res Function(ApiError) _then) = _$ApiErrorCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? message, String? error, int? code
});




}
/// @nodoc
class _$ApiErrorCopyWithImpl<$Res>
    implements $ApiErrorCopyWith<$Res> {
  _$ApiErrorCopyWithImpl(this._self, this._then);

  final ApiError _self;
  final $Res Function(ApiError) _then;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = freezed,Object? message = freezed,Object? error = freezed,Object? code = freezed,}) {
  return _then(_self.copyWith(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiError].
extension ApiErrorPatterns on ApiError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiError value)  $default,){
final _that = this;
switch (_that) {
case _ApiError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiError value)?  $default,){
final _that = this;
switch (_that) {
case _ApiError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  String? error,  int? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiError() when $default != null:
return $default(_that.statusCode,_that.message,_that.error,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  String? error,  int? code)  $default,) {final _that = this;
switch (_that) {
case _ApiError():
return $default(_that.statusCode,_that.message,_that.error,_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? statusCode,  String? message,  String? error,  int? code)?  $default,) {final _that = this;
switch (_that) {
case _ApiError() when $default != null:
return $default(_that.statusCode,_that.message,_that.error,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiError implements ApiError {
  const _ApiError({this.statusCode, this.message, this.error, this.code});
  factory _ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);

@override final  int? statusCode;
@override final  String? message;
@override final  String? error;
@override final  int? code;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorCopyWith<_ApiError> get copyWith => __$ApiErrorCopyWithImpl<_ApiError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiError&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,error,code);

@override
String toString() {
  return 'ApiError(statusCode: $statusCode, message: $message, error: $error, code: $code)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorCopyWith<$Res> implements $ApiErrorCopyWith<$Res> {
  factory _$ApiErrorCopyWith(_ApiError value, $Res Function(_ApiError) _then) = __$ApiErrorCopyWithImpl;
@override @useResult
$Res call({
 int? statusCode, String? message, String? error, int? code
});




}
/// @nodoc
class __$ApiErrorCopyWithImpl<$Res>
    implements _$ApiErrorCopyWith<$Res> {
  __$ApiErrorCopyWithImpl(this._self, this._then);

  final _ApiError _self;
  final $Res Function(_ApiError) _then;

/// Create a copy of ApiError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? message = freezed,Object? error = freezed,Object? code = freezed,}) {
  return _then(_ApiError(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
