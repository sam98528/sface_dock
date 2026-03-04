// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionModelImpl _$$SessionModelImplFromJson(Map<String, dynamic> json) =>
    _$SessionModelImpl(
      sessionId: json['sessionId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      contentSnapshot: json['contentSnapshot'] as Map<String, dynamic>,
      layoutOptions: (json['layoutOptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pricing: json['pricing'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$SessionModelImplToJson(_$SessionModelImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'startTime': instance.startTime.toIso8601String(),
      'contentSnapshot': instance.contentSnapshot,
      'layoutOptions': instance.layoutOptions,
      'pricing': instance.pricing,
    };
