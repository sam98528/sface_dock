// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceSummaryState {
  bool get connected => throw _privateConstructorUsedError;
  Map<String, dynamic>? get summary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceSummaryStateCopyWith<DeviceSummaryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSummaryStateCopyWith<$Res> {
  factory $DeviceSummaryStateCopyWith(
          DeviceSummaryState value, $Res Function(DeviceSummaryState) then) =
      _$DeviceSummaryStateCopyWithImpl<$Res, DeviceSummaryState>;
  @useResult
  $Res call({bool connected, Map<String, dynamic>? summary});
}

/// @nodoc
class _$DeviceSummaryStateCopyWithImpl<$Res, $Val extends DeviceSummaryState>
    implements $DeviceSummaryStateCopyWith<$Res> {
  _$DeviceSummaryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connected = null,
    Object? summary = freezed,
  }) {
    return _then(_value.copyWith(
      connected: null == connected
          ? _value.connected
          : connected // ignore: cast_nullable_to_non_nullable
              as bool,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceSummaryStateImplCopyWith<$Res>
    implements $DeviceSummaryStateCopyWith<$Res> {
  factory _$$DeviceSummaryStateImplCopyWith(_$DeviceSummaryStateImpl value,
          $Res Function(_$DeviceSummaryStateImpl) then) =
      __$$DeviceSummaryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool connected, Map<String, dynamic>? summary});
}

/// @nodoc
class __$$DeviceSummaryStateImplCopyWithImpl<$Res>
    extends _$DeviceSummaryStateCopyWithImpl<$Res, _$DeviceSummaryStateImpl>
    implements _$$DeviceSummaryStateImplCopyWith<$Res> {
  __$$DeviceSummaryStateImplCopyWithImpl(_$DeviceSummaryStateImpl _value,
      $Res Function(_$DeviceSummaryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connected = null,
    Object? summary = freezed,
  }) {
    return _then(_$DeviceSummaryStateImpl(
      connected: null == connected
          ? _value.connected
          : connected // ignore: cast_nullable_to_non_nullable
              as bool,
      summary: freezed == summary
          ? _value._summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$DeviceSummaryStateImpl implements _DeviceSummaryState {
  const _$DeviceSummaryStateImpl(
      {required this.connected, required final Map<String, dynamic>? summary})
      : _summary = summary;

  @override
  final bool connected;
  final Map<String, dynamic>? _summary;
  @override
  Map<String, dynamic>? get summary {
    final value = _summary;
    if (value == null) return null;
    if (_summary is EqualUnmodifiableMapView) return _summary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DeviceSummaryState(connected: $connected, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSummaryStateImpl &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            const DeepCollectionEquality().equals(other._summary, _summary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, connected, const DeepCollectionEquality().hash(_summary));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSummaryStateImplCopyWith<_$DeviceSummaryStateImpl> get copyWith =>
      __$$DeviceSummaryStateImplCopyWithImpl<_$DeviceSummaryStateImpl>(
          this, _$identity);
}

abstract class _DeviceSummaryState implements DeviceSummaryState {
  const factory _DeviceSummaryState(
      {required final bool connected,
      required final Map<String, dynamic>? summary}) = _$DeviceSummaryStateImpl;

  @override
  bool get connected;
  @override
  Map<String, dynamic>? get summary;
  @override
  @JsonKey(ignore: true)
  _$$DeviceSummaryStateImplCopyWith<_$DeviceSummaryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
