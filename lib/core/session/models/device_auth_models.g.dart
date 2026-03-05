// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceLoginResponseImpl _$$DeviceLoginResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceLoginResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DeviceLoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DeviceLoginResponseImplToJson(
        _$DeviceLoginResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_$DeviceLoginDataImpl _$$DeviceLoginDataImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceLoginDataImpl(
      device_id: json['device_id'] as String?,
      device_name: json['device_name'] as String?,
      device_password: json['device_password'] as String?,
    );

Map<String, dynamic> _$$DeviceLoginDataImplToJson(
        _$DeviceLoginDataImpl instance) =>
    <String, dynamic>{
      'device_id': instance.device_id,
      'device_name': instance.device_name,
      'device_password': instance.device_password,
    };

_$UpdateDeviceRequestImpl _$$UpdateDeviceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateDeviceRequestImpl(
      device_name: json['device_name'] as String?,
      software_type: json['software_type'] as String?,
      is_active: json['is_active'] as bool?,
      allow_update: json['allow_update'] as bool?,
      disabled_select_filter: json['disabled_select_filter'] as bool?,
      app_version: json['app_version'] as String?,
      before_app_version: json['before_app_version'] as String?,
      is_tester: json['is_tester'] as bool?,
      allow_select_paper_type: json['allow_select_paper_type'] as bool?,
      enabled_basic_paper: json['enabled_basic_paper'] as bool?,
      additional_paper_types: json['additional_paper_types'] as String?,
      remotecon_type: (json['remotecon_type'] as num?)?.toInt(),
      camera_angle: json['camera_angle'] as String?,
      camera_model: json['camera_model'] as String?,
      camera_lens: json['camera_lens'] as String?,
      printer_model: json['printer_model'] as String?,
      printer_lifecounter: (json['printer_lifecounter'] as num?)?.toInt(),
      printer_remaining: json['printer_remaining'] as String?,
      payment_methods: json['payment_methods'] as String?,
      cardreader_num: json['cardreader_num'] as String?,
      billacceptor_num: json['billacceptor_num'] as String?,
      print_types: json['print_types'] as String?,
      photo_types: json['photo_types'] as String?,
      liveview_modes: json['liveview_modes'] as String?,
      note: json['note'] as String?,
      print_greyscale_additional: json['print_greyscale_additional'] as bool?,
      fix_print_quantity: json['fix_print_quantity'] as bool?,
      winning_probability: (json['winning_probability'] as num?)?.toInt(),
      liveview_timer_countDown:
          (json['liveview_timer_countDown'] as num?)?.toInt(),
      liveview_timer_remote: (json['liveview_timer_remote'] as num?)?.toInt(),
      liveview_timer_remote_cont:
          (json['liveview_timer_remote_cont'] as num?)?.toInt(),
      send_userphotos_methods: json['send_userphotos_methods'] as String?,
      is_offline_mode: json['is_offline_mode'] as bool?,
      is_verified: json['is_verified'] as String?,
    );

Map<String, dynamic> _$$UpdateDeviceRequestImplToJson(
        _$UpdateDeviceRequestImpl instance) =>
    <String, dynamic>{
      'device_name': instance.device_name,
      'software_type': instance.software_type,
      'is_active': instance.is_active,
      'allow_update': instance.allow_update,
      'disabled_select_filter': instance.disabled_select_filter,
      'app_version': instance.app_version,
      'before_app_version': instance.before_app_version,
      'is_tester': instance.is_tester,
      'allow_select_paper_type': instance.allow_select_paper_type,
      'enabled_basic_paper': instance.enabled_basic_paper,
      'additional_paper_types': instance.additional_paper_types,
      'remotecon_type': instance.remotecon_type,
      'camera_angle': instance.camera_angle,
      'camera_model': instance.camera_model,
      'camera_lens': instance.camera_lens,
      'printer_model': instance.printer_model,
      'printer_lifecounter': instance.printer_lifecounter,
      'printer_remaining': instance.printer_remaining,
      'payment_methods': instance.payment_methods,
      'cardreader_num': instance.cardreader_num,
      'billacceptor_num': instance.billacceptor_num,
      'print_types': instance.print_types,
      'photo_types': instance.photo_types,
      'liveview_modes': instance.liveview_modes,
      'note': instance.note,
      'print_greyscale_additional': instance.print_greyscale_additional,
      'fix_print_quantity': instance.fix_print_quantity,
      'winning_probability': instance.winning_probability,
      'liveview_timer_countDown': instance.liveview_timer_countDown,
      'liveview_timer_remote': instance.liveview_timer_remote,
      'liveview_timer_remote_cont': instance.liveview_timer_remote_cont,
      'send_userphotos_methods': instance.send_userphotos_methods,
      'is_offline_mode': instance.is_offline_mode,
      'is_verified': instance.is_verified,
    };

_$ApiErrorImpl _$$ApiErrorImplFromJson(Map<String, dynamic> json) =>
    _$ApiErrorImpl(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      error: json['error'] as String?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiErrorImplToJson(_$ApiErrorImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'error': instance.error,
      'code': instance.code,
    };
