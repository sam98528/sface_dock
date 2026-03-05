// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return _SessionModel.fromJson(json);
}

/// @nodoc
mixin _$SessionModel {
  String get sessionId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  Map<String, dynamic> get contentSnapshot =>
      throw _privateConstructorUsedError;
  List<String> get layoutOptions => throw _privateConstructorUsedError;
  Map<String, dynamic> get pricing => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionModelCopyWith<SessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionModelCopyWith<$Res> {
  factory $SessionModelCopyWith(
          SessionModel value, $Res Function(SessionModel) then) =
      _$SessionModelCopyWithImpl<$Res, SessionModel>;
  @useResult
  $Res call(
      {String sessionId,
      DateTime startTime,
      Map<String, dynamic> contentSnapshot,
      List<String> layoutOptions,
      Map<String, dynamic> pricing});
}

/// @nodoc
class _$SessionModelCopyWithImpl<$Res, $Val extends SessionModel>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startTime = null,
    Object? contentSnapshot = null,
    Object? layoutOptions = null,
    Object? pricing = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contentSnapshot: null == contentSnapshot
          ? _value.contentSnapshot
          : contentSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      layoutOptions: null == layoutOptions
          ? _value.layoutOptions
          : layoutOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pricing: null == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionModelImplCopyWith<$Res>
    implements $SessionModelCopyWith<$Res> {
  factory _$$SessionModelImplCopyWith(
          _$SessionModelImpl value, $Res Function(_$SessionModelImpl) then) =
      __$$SessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      DateTime startTime,
      Map<String, dynamic> contentSnapshot,
      List<String> layoutOptions,
      Map<String, dynamic> pricing});
}

/// @nodoc
class __$$SessionModelImplCopyWithImpl<$Res>
    extends _$SessionModelCopyWithImpl<$Res, _$SessionModelImpl>
    implements _$$SessionModelImplCopyWith<$Res> {
  __$$SessionModelImplCopyWithImpl(
      _$SessionModelImpl _value, $Res Function(_$SessionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startTime = null,
    Object? contentSnapshot = null,
    Object? layoutOptions = null,
    Object? pricing = null,
  }) {
    return _then(_$SessionModelImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contentSnapshot: null == contentSnapshot
          ? _value._contentSnapshot
          : contentSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      layoutOptions: null == layoutOptions
          ? _value._layoutOptions
          : layoutOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pricing: null == pricing
          ? _value._pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionModelImpl implements _SessionModel {
  const _$SessionModelImpl(
      {required this.sessionId,
      required this.startTime,
      required final Map<String, dynamic> contentSnapshot,
      required final List<String> layoutOptions,
      required final Map<String, dynamic> pricing})
      : _contentSnapshot = contentSnapshot,
        _layoutOptions = layoutOptions,
        _pricing = pricing;

  factory _$SessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionModelImplFromJson(json);

  @override
  final String sessionId;
  @override
  final DateTime startTime;
  final Map<String, dynamic> _contentSnapshot;
  @override
  Map<String, dynamic> get contentSnapshot {
    if (_contentSnapshot is EqualUnmodifiableMapView) return _contentSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contentSnapshot);
  }

  final List<String> _layoutOptions;
  @override
  List<String> get layoutOptions {
    if (_layoutOptions is EqualUnmodifiableListView) return _layoutOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layoutOptions);
  }

  final Map<String, dynamic> _pricing;
  @override
  Map<String, dynamic> get pricing {
    if (_pricing is EqualUnmodifiableMapView) return _pricing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pricing);
  }

  @override
  String toString() {
    return 'SessionModel(sessionId: $sessionId, startTime: $startTime, contentSnapshot: $contentSnapshot, layoutOptions: $layoutOptions, pricing: $pricing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionModelImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            const DeepCollectionEquality()
                .equals(other._contentSnapshot, _contentSnapshot) &&
            const DeepCollectionEquality()
                .equals(other._layoutOptions, _layoutOptions) &&
            const DeepCollectionEquality().equals(other._pricing, _pricing));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      startTime,
      const DeepCollectionEquality().hash(_contentSnapshot),
      const DeepCollectionEquality().hash(_layoutOptions),
      const DeepCollectionEquality().hash(_pricing));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      __$$SessionModelImplCopyWithImpl<_$SessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionModelImplToJson(
      this,
    );
  }
}

abstract class _SessionModel implements SessionModel {
  const factory _SessionModel(
      {required final String sessionId,
      required final DateTime startTime,
      required final Map<String, dynamic> contentSnapshot,
      required final List<String> layoutOptions,
      required final Map<String, dynamic> pricing}) = _$SessionModelImpl;

  factory _SessionModel.fromJson(Map<String, dynamic> json) =
      _$SessionModelImpl.fromJson;

  @override
  String get sessionId;
  @override
  DateTime get startTime;
  @override
  Map<String, dynamic> get contentSnapshot;
  @override
  List<String> get layoutOptions;
  @override
  Map<String, dynamic> get pricing;
  @override
  @JsonKey(ignore: true)
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
