// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeviceLoginResponse _$DeviceLoginResponseFromJson(Map<String, dynamic> json) {
  return _DeviceLoginResponse.fromJson(json);
}

/// @nodoc
mixin _$DeviceLoginResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DeviceLoginData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceLoginResponseCopyWith<DeviceLoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceLoginResponseCopyWith<$Res> {
  factory $DeviceLoginResponseCopyWith(
          DeviceLoginResponse value, $Res Function(DeviceLoginResponse) then) =
      _$DeviceLoginResponseCopyWithImpl<$Res, DeviceLoginResponse>;
  @useResult
  $Res call({bool success, String? message, DeviceLoginData? data});

  $DeviceLoginDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$DeviceLoginResponseCopyWithImpl<$Res, $Val extends DeviceLoginResponse>
    implements $DeviceLoginResponseCopyWith<$Res> {
  _$DeviceLoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DeviceLoginData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DeviceLoginDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DeviceLoginDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeviceLoginResponseImplCopyWith<$Res>
    implements $DeviceLoginResponseCopyWith<$Res> {
  factory _$$DeviceLoginResponseImplCopyWith(_$DeviceLoginResponseImpl value,
          $Res Function(_$DeviceLoginResponseImpl) then) =
      __$$DeviceLoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message, DeviceLoginData? data});

  @override
  $DeviceLoginDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$DeviceLoginResponseImplCopyWithImpl<$Res>
    extends _$DeviceLoginResponseCopyWithImpl<$Res, _$DeviceLoginResponseImpl>
    implements _$$DeviceLoginResponseImplCopyWith<$Res> {
  __$$DeviceLoginResponseImplCopyWithImpl(_$DeviceLoginResponseImpl _value,
      $Res Function(_$DeviceLoginResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_$DeviceLoginResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as DeviceLoginData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceLoginResponseImpl implements _DeviceLoginResponse {
  const _$DeviceLoginResponseImpl(
      {required this.success, this.message, this.data});

  factory _$DeviceLoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceLoginResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  @override
  final DeviceLoginData? data;

  @override
  String toString() {
    return 'DeviceLoginResponse(success: $success, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceLoginResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceLoginResponseImplCopyWith<_$DeviceLoginResponseImpl> get copyWith =>
      __$$DeviceLoginResponseImplCopyWithImpl<_$DeviceLoginResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceLoginResponseImplToJson(
      this,
    );
  }
}

abstract class _DeviceLoginResponse implements DeviceLoginResponse {
  const factory _DeviceLoginResponse(
      {required final bool success,
      final String? message,
      final DeviceLoginData? data}) = _$DeviceLoginResponseImpl;

  factory _DeviceLoginResponse.fromJson(Map<String, dynamic> json) =
      _$DeviceLoginResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  DeviceLoginData? get data;
  @override
  @JsonKey(ignore: true)
  _$$DeviceLoginResponseImplCopyWith<_$DeviceLoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceLoginData _$DeviceLoginDataFromJson(Map<String, dynamic> json) {
  return _DeviceLoginData.fromJson(json);
}

/// @nodoc
mixin _$DeviceLoginData {
// ignore: non_constant_identifier_names
  String? get device_id =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get device_name =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get device_password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceLoginDataCopyWith<DeviceLoginData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceLoginDataCopyWith<$Res> {
  factory $DeviceLoginDataCopyWith(
          DeviceLoginData value, $Res Function(DeviceLoginData) then) =
      _$DeviceLoginDataCopyWithImpl<$Res, DeviceLoginData>;
  @useResult
  $Res call({String? device_id, String? device_name, String? device_password});
}

/// @nodoc
class _$DeviceLoginDataCopyWithImpl<$Res, $Val extends DeviceLoginData>
    implements $DeviceLoginDataCopyWith<$Res> {
  _$DeviceLoginDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device_id = freezed,
    Object? device_name = freezed,
    Object? device_password = freezed,
  }) {
    return _then(_value.copyWith(
      device_id: freezed == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as String?,
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      device_password: freezed == device_password
          ? _value.device_password
          : device_password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceLoginDataImplCopyWith<$Res>
    implements $DeviceLoginDataCopyWith<$Res> {
  factory _$$DeviceLoginDataImplCopyWith(_$DeviceLoginDataImpl value,
          $Res Function(_$DeviceLoginDataImpl) then) =
      __$$DeviceLoginDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? device_id, String? device_name, String? device_password});
}

/// @nodoc
class __$$DeviceLoginDataImplCopyWithImpl<$Res>
    extends _$DeviceLoginDataCopyWithImpl<$Res, _$DeviceLoginDataImpl>
    implements _$$DeviceLoginDataImplCopyWith<$Res> {
  __$$DeviceLoginDataImplCopyWithImpl(
      _$DeviceLoginDataImpl _value, $Res Function(_$DeviceLoginDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device_id = freezed,
    Object? device_name = freezed,
    Object? device_password = freezed,
  }) {
    return _then(_$DeviceLoginDataImpl(
      device_id: freezed == device_id
          ? _value.device_id
          : device_id // ignore: cast_nullable_to_non_nullable
              as String?,
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      device_password: freezed == device_password
          ? _value.device_password
          : device_password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceLoginDataImpl implements _DeviceLoginData {
  const _$DeviceLoginDataImpl(
      {this.device_id, this.device_name, this.device_password});

  factory _$DeviceLoginDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceLoginDataImplFromJson(json);

// ignore: non_constant_identifier_names
  @override
  final String? device_id;
// ignore: non_constant_identifier_names
  @override
  final String? device_name;
// ignore: non_constant_identifier_names
  @override
  final String? device_password;

  @override
  String toString() {
    return 'DeviceLoginData(device_id: $device_id, device_name: $device_name, device_password: $device_password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceLoginDataImpl &&
            (identical(other.device_id, device_id) ||
                other.device_id == device_id) &&
            (identical(other.device_name, device_name) ||
                other.device_name == device_name) &&
            (identical(other.device_password, device_password) ||
                other.device_password == device_password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, device_id, device_name, device_password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceLoginDataImplCopyWith<_$DeviceLoginDataImpl> get copyWith =>
      __$$DeviceLoginDataImplCopyWithImpl<_$DeviceLoginDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceLoginDataImplToJson(
      this,
    );
  }
}

abstract class _DeviceLoginData implements DeviceLoginData {
  const factory _DeviceLoginData(
      {final String? device_id,
      final String? device_name,
      final String? device_password}) = _$DeviceLoginDataImpl;

  factory _DeviceLoginData.fromJson(Map<String, dynamic> json) =
      _$DeviceLoginDataImpl.fromJson;

  @override // ignore: non_constant_identifier_names
  String? get device_id;
  @override // ignore: non_constant_identifier_names
  String? get device_name;
  @override // ignore: non_constant_identifier_names
  String? get device_password;
  @override
  @JsonKey(ignore: true)
  _$$DeviceLoginDataImplCopyWith<_$DeviceLoginDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateDeviceRequest _$UpdateDeviceRequestFromJson(Map<String, dynamic> json) {
  return _UpdateDeviceRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateDeviceRequest {
// ignore: non_constant_identifier_names
  String? get device_name =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get software_type =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get is_active =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get allow_update =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get disabled_select_filter =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get app_version =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get before_app_version =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get is_tester =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get allow_select_paper_type =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get enabled_basic_paper =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get additional_paper_types =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get remotecon_type =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get camera_angle =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get camera_model =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get camera_lens =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get printer_model =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get printer_lifecounter =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get printer_remaining =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get payment_methods =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get cardreader_num =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get billacceptor_num =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get print_types =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get photo_types =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get liveview_modes => throw _privateConstructorUsedError;
  String? get note =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get print_greyscale_additional =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get fix_print_quantity =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get winning_probability =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get liveview_timer_countDown =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get liveview_timer_remote =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  int? get liveview_timer_remote_cont =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get send_userphotos_methods =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  bool? get is_offline_mode =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String? get is_verified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateDeviceRequestCopyWith<UpdateDeviceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateDeviceRequestCopyWith<$Res> {
  factory $UpdateDeviceRequestCopyWith(
          UpdateDeviceRequest value, $Res Function(UpdateDeviceRequest) then) =
      _$UpdateDeviceRequestCopyWithImpl<$Res, UpdateDeviceRequest>;
  @useResult
  $Res call(
      {String? device_name,
      String? software_type,
      bool? is_active,
      bool? allow_update,
      bool? disabled_select_filter,
      String? app_version,
      String? before_app_version,
      bool? is_tester,
      bool? allow_select_paper_type,
      bool? enabled_basic_paper,
      String? additional_paper_types,
      int? remotecon_type,
      String? camera_angle,
      String? camera_model,
      String? camera_lens,
      String? printer_model,
      int? printer_lifecounter,
      String? printer_remaining,
      String? payment_methods,
      String? cardreader_num,
      String? billacceptor_num,
      String? print_types,
      String? photo_types,
      String? liveview_modes,
      String? note,
      bool? print_greyscale_additional,
      bool? fix_print_quantity,
      int? winning_probability,
      int? liveview_timer_countDown,
      int? liveview_timer_remote,
      int? liveview_timer_remote_cont,
      String? send_userphotos_methods,
      bool? is_offline_mode,
      String? is_verified});
}

/// @nodoc
class _$UpdateDeviceRequestCopyWithImpl<$Res, $Val extends UpdateDeviceRequest>
    implements $UpdateDeviceRequestCopyWith<$Res> {
  _$UpdateDeviceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device_name = freezed,
    Object? software_type = freezed,
    Object? is_active = freezed,
    Object? allow_update = freezed,
    Object? disabled_select_filter = freezed,
    Object? app_version = freezed,
    Object? before_app_version = freezed,
    Object? is_tester = freezed,
    Object? allow_select_paper_type = freezed,
    Object? enabled_basic_paper = freezed,
    Object? additional_paper_types = freezed,
    Object? remotecon_type = freezed,
    Object? camera_angle = freezed,
    Object? camera_model = freezed,
    Object? camera_lens = freezed,
    Object? printer_model = freezed,
    Object? printer_lifecounter = freezed,
    Object? printer_remaining = freezed,
    Object? payment_methods = freezed,
    Object? cardreader_num = freezed,
    Object? billacceptor_num = freezed,
    Object? print_types = freezed,
    Object? photo_types = freezed,
    Object? liveview_modes = freezed,
    Object? note = freezed,
    Object? print_greyscale_additional = freezed,
    Object? fix_print_quantity = freezed,
    Object? winning_probability = freezed,
    Object? liveview_timer_countDown = freezed,
    Object? liveview_timer_remote = freezed,
    Object? liveview_timer_remote_cont = freezed,
    Object? send_userphotos_methods = freezed,
    Object? is_offline_mode = freezed,
    Object? is_verified = freezed,
  }) {
    return _then(_value.copyWith(
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      software_type: freezed == software_type
          ? _value.software_type
          : software_type // ignore: cast_nullable_to_non_nullable
              as String?,
      is_active: freezed == is_active
          ? _value.is_active
          : is_active // ignore: cast_nullable_to_non_nullable
              as bool?,
      allow_update: freezed == allow_update
          ? _value.allow_update
          : allow_update // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled_select_filter: freezed == disabled_select_filter
          ? _value.disabled_select_filter
          : disabled_select_filter // ignore: cast_nullable_to_non_nullable
              as bool?,
      app_version: freezed == app_version
          ? _value.app_version
          : app_version // ignore: cast_nullable_to_non_nullable
              as String?,
      before_app_version: freezed == before_app_version
          ? _value.before_app_version
          : before_app_version // ignore: cast_nullable_to_non_nullable
              as String?,
      is_tester: freezed == is_tester
          ? _value.is_tester
          : is_tester // ignore: cast_nullable_to_non_nullable
              as bool?,
      allow_select_paper_type: freezed == allow_select_paper_type
          ? _value.allow_select_paper_type
          : allow_select_paper_type // ignore: cast_nullable_to_non_nullable
              as bool?,
      enabled_basic_paper: freezed == enabled_basic_paper
          ? _value.enabled_basic_paper
          : enabled_basic_paper // ignore: cast_nullable_to_non_nullable
              as bool?,
      additional_paper_types: freezed == additional_paper_types
          ? _value.additional_paper_types
          : additional_paper_types // ignore: cast_nullable_to_non_nullable
              as String?,
      remotecon_type: freezed == remotecon_type
          ? _value.remotecon_type
          : remotecon_type // ignore: cast_nullable_to_non_nullable
              as int?,
      camera_angle: freezed == camera_angle
          ? _value.camera_angle
          : camera_angle // ignore: cast_nullable_to_non_nullable
              as String?,
      camera_model: freezed == camera_model
          ? _value.camera_model
          : camera_model // ignore: cast_nullable_to_non_nullable
              as String?,
      camera_lens: freezed == camera_lens
          ? _value.camera_lens
          : camera_lens // ignore: cast_nullable_to_non_nullable
              as String?,
      printer_model: freezed == printer_model
          ? _value.printer_model
          : printer_model // ignore: cast_nullable_to_non_nullable
              as String?,
      printer_lifecounter: freezed == printer_lifecounter
          ? _value.printer_lifecounter
          : printer_lifecounter // ignore: cast_nullable_to_non_nullable
              as int?,
      printer_remaining: freezed == printer_remaining
          ? _value.printer_remaining
          : printer_remaining // ignore: cast_nullable_to_non_nullable
              as String?,
      payment_methods: freezed == payment_methods
          ? _value.payment_methods
          : payment_methods // ignore: cast_nullable_to_non_nullable
              as String?,
      cardreader_num: freezed == cardreader_num
          ? _value.cardreader_num
          : cardreader_num // ignore: cast_nullable_to_non_nullable
              as String?,
      billacceptor_num: freezed == billacceptor_num
          ? _value.billacceptor_num
          : billacceptor_num // ignore: cast_nullable_to_non_nullable
              as String?,
      print_types: freezed == print_types
          ? _value.print_types
          : print_types // ignore: cast_nullable_to_non_nullable
              as String?,
      photo_types: freezed == photo_types
          ? _value.photo_types
          : photo_types // ignore: cast_nullable_to_non_nullable
              as String?,
      liveview_modes: freezed == liveview_modes
          ? _value.liveview_modes
          : liveview_modes // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      print_greyscale_additional: freezed == print_greyscale_additional
          ? _value.print_greyscale_additional
          : print_greyscale_additional // ignore: cast_nullable_to_non_nullable
              as bool?,
      fix_print_quantity: freezed == fix_print_quantity
          ? _value.fix_print_quantity
          : fix_print_quantity // ignore: cast_nullable_to_non_nullable
              as bool?,
      winning_probability: freezed == winning_probability
          ? _value.winning_probability
          : winning_probability // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_countDown: freezed == liveview_timer_countDown
          ? _value.liveview_timer_countDown
          : liveview_timer_countDown // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_remote: freezed == liveview_timer_remote
          ? _value.liveview_timer_remote
          : liveview_timer_remote // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_remote_cont: freezed == liveview_timer_remote_cont
          ? _value.liveview_timer_remote_cont
          : liveview_timer_remote_cont // ignore: cast_nullable_to_non_nullable
              as int?,
      send_userphotos_methods: freezed == send_userphotos_methods
          ? _value.send_userphotos_methods
          : send_userphotos_methods // ignore: cast_nullable_to_non_nullable
              as String?,
      is_offline_mode: freezed == is_offline_mode
          ? _value.is_offline_mode
          : is_offline_mode // ignore: cast_nullable_to_non_nullable
              as bool?,
      is_verified: freezed == is_verified
          ? _value.is_verified
          : is_verified // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateDeviceRequestImplCopyWith<$Res>
    implements $UpdateDeviceRequestCopyWith<$Res> {
  factory _$$UpdateDeviceRequestImplCopyWith(_$UpdateDeviceRequestImpl value,
          $Res Function(_$UpdateDeviceRequestImpl) then) =
      __$$UpdateDeviceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? device_name,
      String? software_type,
      bool? is_active,
      bool? allow_update,
      bool? disabled_select_filter,
      String? app_version,
      String? before_app_version,
      bool? is_tester,
      bool? allow_select_paper_type,
      bool? enabled_basic_paper,
      String? additional_paper_types,
      int? remotecon_type,
      String? camera_angle,
      String? camera_model,
      String? camera_lens,
      String? printer_model,
      int? printer_lifecounter,
      String? printer_remaining,
      String? payment_methods,
      String? cardreader_num,
      String? billacceptor_num,
      String? print_types,
      String? photo_types,
      String? liveview_modes,
      String? note,
      bool? print_greyscale_additional,
      bool? fix_print_quantity,
      int? winning_probability,
      int? liveview_timer_countDown,
      int? liveview_timer_remote,
      int? liveview_timer_remote_cont,
      String? send_userphotos_methods,
      bool? is_offline_mode,
      String? is_verified});
}

/// @nodoc
class __$$UpdateDeviceRequestImplCopyWithImpl<$Res>
    extends _$UpdateDeviceRequestCopyWithImpl<$Res, _$UpdateDeviceRequestImpl>
    implements _$$UpdateDeviceRequestImplCopyWith<$Res> {
  __$$UpdateDeviceRequestImplCopyWithImpl(_$UpdateDeviceRequestImpl _value,
      $Res Function(_$UpdateDeviceRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device_name = freezed,
    Object? software_type = freezed,
    Object? is_active = freezed,
    Object? allow_update = freezed,
    Object? disabled_select_filter = freezed,
    Object? app_version = freezed,
    Object? before_app_version = freezed,
    Object? is_tester = freezed,
    Object? allow_select_paper_type = freezed,
    Object? enabled_basic_paper = freezed,
    Object? additional_paper_types = freezed,
    Object? remotecon_type = freezed,
    Object? camera_angle = freezed,
    Object? camera_model = freezed,
    Object? camera_lens = freezed,
    Object? printer_model = freezed,
    Object? printer_lifecounter = freezed,
    Object? printer_remaining = freezed,
    Object? payment_methods = freezed,
    Object? cardreader_num = freezed,
    Object? billacceptor_num = freezed,
    Object? print_types = freezed,
    Object? photo_types = freezed,
    Object? liveview_modes = freezed,
    Object? note = freezed,
    Object? print_greyscale_additional = freezed,
    Object? fix_print_quantity = freezed,
    Object? winning_probability = freezed,
    Object? liveview_timer_countDown = freezed,
    Object? liveview_timer_remote = freezed,
    Object? liveview_timer_remote_cont = freezed,
    Object? send_userphotos_methods = freezed,
    Object? is_offline_mode = freezed,
    Object? is_verified = freezed,
  }) {
    return _then(_$UpdateDeviceRequestImpl(
      device_name: freezed == device_name
          ? _value.device_name
          : device_name // ignore: cast_nullable_to_non_nullable
              as String?,
      software_type: freezed == software_type
          ? _value.software_type
          : software_type // ignore: cast_nullable_to_non_nullable
              as String?,
      is_active: freezed == is_active
          ? _value.is_active
          : is_active // ignore: cast_nullable_to_non_nullable
              as bool?,
      allow_update: freezed == allow_update
          ? _value.allow_update
          : allow_update // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled_select_filter: freezed == disabled_select_filter
          ? _value.disabled_select_filter
          : disabled_select_filter // ignore: cast_nullable_to_non_nullable
              as bool?,
      app_version: freezed == app_version
          ? _value.app_version
          : app_version // ignore: cast_nullable_to_non_nullable
              as String?,
      before_app_version: freezed == before_app_version
          ? _value.before_app_version
          : before_app_version // ignore: cast_nullable_to_non_nullable
              as String?,
      is_tester: freezed == is_tester
          ? _value.is_tester
          : is_tester // ignore: cast_nullable_to_non_nullable
              as bool?,
      allow_select_paper_type: freezed == allow_select_paper_type
          ? _value.allow_select_paper_type
          : allow_select_paper_type // ignore: cast_nullable_to_non_nullable
              as bool?,
      enabled_basic_paper: freezed == enabled_basic_paper
          ? _value.enabled_basic_paper
          : enabled_basic_paper // ignore: cast_nullable_to_non_nullable
              as bool?,
      additional_paper_types: freezed == additional_paper_types
          ? _value.additional_paper_types
          : additional_paper_types // ignore: cast_nullable_to_non_nullable
              as String?,
      remotecon_type: freezed == remotecon_type
          ? _value.remotecon_type
          : remotecon_type // ignore: cast_nullable_to_non_nullable
              as int?,
      camera_angle: freezed == camera_angle
          ? _value.camera_angle
          : camera_angle // ignore: cast_nullable_to_non_nullable
              as String?,
      camera_model: freezed == camera_model
          ? _value.camera_model
          : camera_model // ignore: cast_nullable_to_non_nullable
              as String?,
      camera_lens: freezed == camera_lens
          ? _value.camera_lens
          : camera_lens // ignore: cast_nullable_to_non_nullable
              as String?,
      printer_model: freezed == printer_model
          ? _value.printer_model
          : printer_model // ignore: cast_nullable_to_non_nullable
              as String?,
      printer_lifecounter: freezed == printer_lifecounter
          ? _value.printer_lifecounter
          : printer_lifecounter // ignore: cast_nullable_to_non_nullable
              as int?,
      printer_remaining: freezed == printer_remaining
          ? _value.printer_remaining
          : printer_remaining // ignore: cast_nullable_to_non_nullable
              as String?,
      payment_methods: freezed == payment_methods
          ? _value.payment_methods
          : payment_methods // ignore: cast_nullable_to_non_nullable
              as String?,
      cardreader_num: freezed == cardreader_num
          ? _value.cardreader_num
          : cardreader_num // ignore: cast_nullable_to_non_nullable
              as String?,
      billacceptor_num: freezed == billacceptor_num
          ? _value.billacceptor_num
          : billacceptor_num // ignore: cast_nullable_to_non_nullable
              as String?,
      print_types: freezed == print_types
          ? _value.print_types
          : print_types // ignore: cast_nullable_to_non_nullable
              as String?,
      photo_types: freezed == photo_types
          ? _value.photo_types
          : photo_types // ignore: cast_nullable_to_non_nullable
              as String?,
      liveview_modes: freezed == liveview_modes
          ? _value.liveview_modes
          : liveview_modes // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      print_greyscale_additional: freezed == print_greyscale_additional
          ? _value.print_greyscale_additional
          : print_greyscale_additional // ignore: cast_nullable_to_non_nullable
              as bool?,
      fix_print_quantity: freezed == fix_print_quantity
          ? _value.fix_print_quantity
          : fix_print_quantity // ignore: cast_nullable_to_non_nullable
              as bool?,
      winning_probability: freezed == winning_probability
          ? _value.winning_probability
          : winning_probability // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_countDown: freezed == liveview_timer_countDown
          ? _value.liveview_timer_countDown
          : liveview_timer_countDown // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_remote: freezed == liveview_timer_remote
          ? _value.liveview_timer_remote
          : liveview_timer_remote // ignore: cast_nullable_to_non_nullable
              as int?,
      liveview_timer_remote_cont: freezed == liveview_timer_remote_cont
          ? _value.liveview_timer_remote_cont
          : liveview_timer_remote_cont // ignore: cast_nullable_to_non_nullable
              as int?,
      send_userphotos_methods: freezed == send_userphotos_methods
          ? _value.send_userphotos_methods
          : send_userphotos_methods // ignore: cast_nullable_to_non_nullable
              as String?,
      is_offline_mode: freezed == is_offline_mode
          ? _value.is_offline_mode
          : is_offline_mode // ignore: cast_nullable_to_non_nullable
              as bool?,
      is_verified: freezed == is_verified
          ? _value.is_verified
          : is_verified // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateDeviceRequestImpl implements _UpdateDeviceRequest {
  const _$UpdateDeviceRequestImpl(
      {this.device_name,
      this.software_type,
      this.is_active,
      this.allow_update,
      this.disabled_select_filter,
      this.app_version,
      this.before_app_version,
      this.is_tester,
      this.allow_select_paper_type,
      this.enabled_basic_paper,
      this.additional_paper_types,
      this.remotecon_type,
      this.camera_angle,
      this.camera_model,
      this.camera_lens,
      this.printer_model,
      this.printer_lifecounter,
      this.printer_remaining,
      this.payment_methods,
      this.cardreader_num,
      this.billacceptor_num,
      this.print_types,
      this.photo_types,
      this.liveview_modes,
      this.note,
      this.print_greyscale_additional,
      this.fix_print_quantity,
      this.winning_probability,
      this.liveview_timer_countDown,
      this.liveview_timer_remote,
      this.liveview_timer_remote_cont,
      this.send_userphotos_methods,
      this.is_offline_mode,
      this.is_verified});

  factory _$UpdateDeviceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateDeviceRequestImplFromJson(json);

// ignore: non_constant_identifier_names
  @override
  final String? device_name;
// ignore: non_constant_identifier_names
  @override
  final String? software_type;
// ignore: non_constant_identifier_names
  @override
  final bool? is_active;
// ignore: non_constant_identifier_names
  @override
  final bool? allow_update;
// ignore: non_constant_identifier_names
  @override
  final bool? disabled_select_filter;
// ignore: non_constant_identifier_names
  @override
  final String? app_version;
// ignore: non_constant_identifier_names
  @override
  final String? before_app_version;
// ignore: non_constant_identifier_names
  @override
  final bool? is_tester;
// ignore: non_constant_identifier_names
  @override
  final bool? allow_select_paper_type;
// ignore: non_constant_identifier_names
  @override
  final bool? enabled_basic_paper;
// ignore: non_constant_identifier_names
  @override
  final String? additional_paper_types;
// ignore: non_constant_identifier_names
  @override
  final int? remotecon_type;
// ignore: non_constant_identifier_names
  @override
  final String? camera_angle;
// ignore: non_constant_identifier_names
  @override
  final String? camera_model;
// ignore: non_constant_identifier_names
  @override
  final String? camera_lens;
// ignore: non_constant_identifier_names
  @override
  final String? printer_model;
// ignore: non_constant_identifier_names
  @override
  final int? printer_lifecounter;
// ignore: non_constant_identifier_names
  @override
  final String? printer_remaining;
// ignore: non_constant_identifier_names
  @override
  final String? payment_methods;
// ignore: non_constant_identifier_names
  @override
  final String? cardreader_num;
// ignore: non_constant_identifier_names
  @override
  final String? billacceptor_num;
// ignore: non_constant_identifier_names
  @override
  final String? print_types;
// ignore: non_constant_identifier_names
  @override
  final String? photo_types;
// ignore: non_constant_identifier_names
  @override
  final String? liveview_modes;
  @override
  final String? note;
// ignore: non_constant_identifier_names
  @override
  final bool? print_greyscale_additional;
// ignore: non_constant_identifier_names
  @override
  final bool? fix_print_quantity;
// ignore: non_constant_identifier_names
  @override
  final int? winning_probability;
// ignore: non_constant_identifier_names
  @override
  final int? liveview_timer_countDown;
// ignore: non_constant_identifier_names
  @override
  final int? liveview_timer_remote;
// ignore: non_constant_identifier_names
  @override
  final int? liveview_timer_remote_cont;
// ignore: non_constant_identifier_names
  @override
  final String? send_userphotos_methods;
// ignore: non_constant_identifier_names
  @override
  final bool? is_offline_mode;
// ignore: non_constant_identifier_names
  @override
  final String? is_verified;

  @override
  String toString() {
    return 'UpdateDeviceRequest(device_name: $device_name, software_type: $software_type, is_active: $is_active, allow_update: $allow_update, disabled_select_filter: $disabled_select_filter, app_version: $app_version, before_app_version: $before_app_version, is_tester: $is_tester, allow_select_paper_type: $allow_select_paper_type, enabled_basic_paper: $enabled_basic_paper, additional_paper_types: $additional_paper_types, remotecon_type: $remotecon_type, camera_angle: $camera_angle, camera_model: $camera_model, camera_lens: $camera_lens, printer_model: $printer_model, printer_lifecounter: $printer_lifecounter, printer_remaining: $printer_remaining, payment_methods: $payment_methods, cardreader_num: $cardreader_num, billacceptor_num: $billacceptor_num, print_types: $print_types, photo_types: $photo_types, liveview_modes: $liveview_modes, note: $note, print_greyscale_additional: $print_greyscale_additional, fix_print_quantity: $fix_print_quantity, winning_probability: $winning_probability, liveview_timer_countDown: $liveview_timer_countDown, liveview_timer_remote: $liveview_timer_remote, liveview_timer_remote_cont: $liveview_timer_remote_cont, send_userphotos_methods: $send_userphotos_methods, is_offline_mode: $is_offline_mode, is_verified: $is_verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDeviceRequestImpl &&
            (identical(other.device_name, device_name) ||
                other.device_name == device_name) &&
            (identical(other.software_type, software_type) ||
                other.software_type == software_type) &&
            (identical(other.is_active, is_active) ||
                other.is_active == is_active) &&
            (identical(other.allow_update, allow_update) ||
                other.allow_update == allow_update) &&
            (identical(other.disabled_select_filter, disabled_select_filter) ||
                other.disabled_select_filter == disabled_select_filter) &&
            (identical(other.app_version, app_version) ||
                other.app_version == app_version) &&
            (identical(other.before_app_version, before_app_version) ||
                other.before_app_version == before_app_version) &&
            (identical(other.is_tester, is_tester) ||
                other.is_tester == is_tester) &&
            (identical(other.allow_select_paper_type, allow_select_paper_type) ||
                other.allow_select_paper_type == allow_select_paper_type) &&
            (identical(other.enabled_basic_paper, enabled_basic_paper) ||
                other.enabled_basic_paper == enabled_basic_paper) &&
            (identical(other.additional_paper_types, additional_paper_types) ||
                other.additional_paper_types == additional_paper_types) &&
            (identical(other.remotecon_type, remotecon_type) ||
                other.remotecon_type == remotecon_type) &&
            (identical(other.camera_angle, camera_angle) ||
                other.camera_angle == camera_angle) &&
            (identical(other.camera_model, camera_model) ||
                other.camera_model == camera_model) &&
            (identical(other.camera_lens, camera_lens) ||
                other.camera_lens == camera_lens) &&
            (identical(other.printer_model, printer_model) ||
                other.printer_model == printer_model) &&
            (identical(other.printer_lifecounter, printer_lifecounter) ||
                other.printer_lifecounter == printer_lifecounter) &&
            (identical(other.printer_remaining, printer_remaining) ||
                other.printer_remaining == printer_remaining) &&
            (identical(other.payment_methods, payment_methods) ||
                other.payment_methods == payment_methods) &&
            (identical(other.cardreader_num, cardreader_num) ||
                other.cardreader_num == cardreader_num) &&
            (identical(other.billacceptor_num, billacceptor_num) ||
                other.billacceptor_num == billacceptor_num) &&
            (identical(other.print_types, print_types) ||
                other.print_types == print_types) &&
            (identical(other.photo_types, photo_types) ||
                other.photo_types == photo_types) &&
            (identical(other.liveview_modes, liveview_modes) ||
                other.liveview_modes == liveview_modes) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.print_greyscale_additional, print_greyscale_additional) ||
                other.print_greyscale_additional ==
                    print_greyscale_additional) &&
            (identical(other.fix_print_quantity, fix_print_quantity) ||
                other.fix_print_quantity == fix_print_quantity) &&
            (identical(other.winning_probability, winning_probability) ||
                other.winning_probability == winning_probability) &&
            (identical(other.liveview_timer_countDown, liveview_timer_countDown) ||
                other.liveview_timer_countDown == liveview_timer_countDown) &&
            (identical(other.liveview_timer_remote, liveview_timer_remote) ||
                other.liveview_timer_remote == liveview_timer_remote) &&
            (identical(other.liveview_timer_remote_cont, liveview_timer_remote_cont) ||
                other.liveview_timer_remote_cont ==
                    liveview_timer_remote_cont) &&
            (identical(other.send_userphotos_methods, send_userphotos_methods) ||
                other.send_userphotos_methods == send_userphotos_methods) &&
            (identical(other.is_offline_mode, is_offline_mode) ||
                other.is_offline_mode == is_offline_mode) &&
            (identical(other.is_verified, is_verified) || other.is_verified == is_verified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        device_name,
        software_type,
        is_active,
        allow_update,
        disabled_select_filter,
        app_version,
        before_app_version,
        is_tester,
        allow_select_paper_type,
        enabled_basic_paper,
        additional_paper_types,
        remotecon_type,
        camera_angle,
        camera_model,
        camera_lens,
        printer_model,
        printer_lifecounter,
        printer_remaining,
        payment_methods,
        cardreader_num,
        billacceptor_num,
        print_types,
        photo_types,
        liveview_modes,
        note,
        print_greyscale_additional,
        fix_print_quantity,
        winning_probability,
        liveview_timer_countDown,
        liveview_timer_remote,
        liveview_timer_remote_cont,
        send_userphotos_methods,
        is_offline_mode,
        is_verified
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDeviceRequestImplCopyWith<_$UpdateDeviceRequestImpl> get copyWith =>
      __$$UpdateDeviceRequestImplCopyWithImpl<_$UpdateDeviceRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateDeviceRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateDeviceRequest implements UpdateDeviceRequest {
  const factory _UpdateDeviceRequest(
      {final String? device_name,
      final String? software_type,
      final bool? is_active,
      final bool? allow_update,
      final bool? disabled_select_filter,
      final String? app_version,
      final String? before_app_version,
      final bool? is_tester,
      final bool? allow_select_paper_type,
      final bool? enabled_basic_paper,
      final String? additional_paper_types,
      final int? remotecon_type,
      final String? camera_angle,
      final String? camera_model,
      final String? camera_lens,
      final String? printer_model,
      final int? printer_lifecounter,
      final String? printer_remaining,
      final String? payment_methods,
      final String? cardreader_num,
      final String? billacceptor_num,
      final String? print_types,
      final String? photo_types,
      final String? liveview_modes,
      final String? note,
      final bool? print_greyscale_additional,
      final bool? fix_print_quantity,
      final int? winning_probability,
      final int? liveview_timer_countDown,
      final int? liveview_timer_remote,
      final int? liveview_timer_remote_cont,
      final String? send_userphotos_methods,
      final bool? is_offline_mode,
      final String? is_verified}) = _$UpdateDeviceRequestImpl;

  factory _UpdateDeviceRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateDeviceRequestImpl.fromJson;

  @override // ignore: non_constant_identifier_names
  String? get device_name;
  @override // ignore: non_constant_identifier_names
  String? get software_type;
  @override // ignore: non_constant_identifier_names
  bool? get is_active;
  @override // ignore: non_constant_identifier_names
  bool? get allow_update;
  @override // ignore: non_constant_identifier_names
  bool? get disabled_select_filter;
  @override // ignore: non_constant_identifier_names
  String? get app_version;
  @override // ignore: non_constant_identifier_names
  String? get before_app_version;
  @override // ignore: non_constant_identifier_names
  bool? get is_tester;
  @override // ignore: non_constant_identifier_names
  bool? get allow_select_paper_type;
  @override // ignore: non_constant_identifier_names
  bool? get enabled_basic_paper;
  @override // ignore: non_constant_identifier_names
  String? get additional_paper_types;
  @override // ignore: non_constant_identifier_names
  int? get remotecon_type;
  @override // ignore: non_constant_identifier_names
  String? get camera_angle;
  @override // ignore: non_constant_identifier_names
  String? get camera_model;
  @override // ignore: non_constant_identifier_names
  String? get camera_lens;
  @override // ignore: non_constant_identifier_names
  String? get printer_model;
  @override // ignore: non_constant_identifier_names
  int? get printer_lifecounter;
  @override // ignore: non_constant_identifier_names
  String? get printer_remaining;
  @override // ignore: non_constant_identifier_names
  String? get payment_methods;
  @override // ignore: non_constant_identifier_names
  String? get cardreader_num;
  @override // ignore: non_constant_identifier_names
  String? get billacceptor_num;
  @override // ignore: non_constant_identifier_names
  String? get print_types;
  @override // ignore: non_constant_identifier_names
  String? get photo_types;
  @override // ignore: non_constant_identifier_names
  String? get liveview_modes;
  @override
  String? get note;
  @override // ignore: non_constant_identifier_names
  bool? get print_greyscale_additional;
  @override // ignore: non_constant_identifier_names
  bool? get fix_print_quantity;
  @override // ignore: non_constant_identifier_names
  int? get winning_probability;
  @override // ignore: non_constant_identifier_names
  int? get liveview_timer_countDown;
  @override // ignore: non_constant_identifier_names
  int? get liveview_timer_remote;
  @override // ignore: non_constant_identifier_names
  int? get liveview_timer_remote_cont;
  @override // ignore: non_constant_identifier_names
  String? get send_userphotos_methods;
  @override // ignore: non_constant_identifier_names
  bool? get is_offline_mode;
  @override // ignore: non_constant_identifier_names
  String? get is_verified;
  @override
  @JsonKey(ignore: true)
  _$$UpdateDeviceRequestImplCopyWith<_$UpdateDeviceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) {
  return _ApiError.fromJson(json);
}

/// @nodoc
mixin _$ApiError {
  int? get statusCode => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiErrorCopyWith<ApiError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorCopyWith<$Res> {
  factory $ApiErrorCopyWith(ApiError value, $Res Function(ApiError) then) =
      _$ApiErrorCopyWithImpl<$Res, ApiError>;
  @useResult
  $Res call({int? statusCode, String? message, String? error, int? code});
}

/// @nodoc
class _$ApiErrorCopyWithImpl<$Res, $Val extends ApiError>
    implements $ApiErrorCopyWith<$Res> {
  _$ApiErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? error = freezed,
    Object? code = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$ApiErrorImplCopyWith(
          _$ApiErrorImpl value, $Res Function(_$ApiErrorImpl) then) =
      __$$ApiErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? statusCode, String? message, String? error, int? code});
}

/// @nodoc
class __$$ApiErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$ApiErrorImpl>
    implements _$$ApiErrorImplCopyWith<$Res> {
  __$$ApiErrorImplCopyWithImpl(
      _$ApiErrorImpl _value, $Res Function(_$ApiErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? error = freezed,
    Object? code = freezed,
  }) {
    return _then(_$ApiErrorImpl(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorImpl implements _ApiError {
  const _$ApiErrorImpl({this.statusCode, this.message, this.error, this.code});

  factory _$ApiErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorImplFromJson(json);

  @override
  final int? statusCode;
  @override
  final String? message;
  @override
  final String? error;
  @override
  final int? code;

  @override
  String toString() {
    return 'ApiError(statusCode: $statusCode, message: $message, error: $error, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, statusCode, message, error, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorImplCopyWith<_$ApiErrorImpl> get copyWith =>
      __$$ApiErrorImplCopyWithImpl<_$ApiErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorImplToJson(
      this,
    );
  }
}

abstract class _ApiError implements ApiError {
  const factory _ApiError(
      {final int? statusCode,
      final String? message,
      final String? error,
      final int? code}) = _$ApiErrorImpl;

  factory _ApiError.fromJson(Map<String, dynamic> json) =
      _$ApiErrorImpl.fromJson;

  @override
  int? get statusCode;
  @override
  String? get message;
  @override
  String? get error;
  @override
  int? get code;
  @override
  @JsonKey(ignore: true)
  _$$ApiErrorImplCopyWith<_$ApiErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
