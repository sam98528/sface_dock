// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SessionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() active,
    required TResult Function(SessionEndReason reason) ended,
    required TResult Function(List<String> errorCodes) deviceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? active,
    TResult? Function(SessionEndReason reason)? ended,
    TResult? Function(List<String> errorCodes)? deviceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? active,
    TResult Function(SessionEndReason reason)? ended,
    TResult Function(List<String> errorCodes)? deviceError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Active value) active,
    required TResult Function(_Ended value) ended,
    required TResult Function(_DeviceError value) deviceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Active value)? active,
    TResult? Function(_Ended value)? ended,
    TResult? Function(_DeviceError value)? deviceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Active value)? active,
    TResult Function(_Ended value)? ended,
    TResult Function(_DeviceError value)? deviceError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) then) =
      _$SessionStateCopyWithImpl<$Res, SessionState>;
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'SessionState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() active,
    required TResult Function(SessionEndReason reason) ended,
    required TResult Function(List<String> errorCodes) deviceError,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? active,
    TResult? Function(SessionEndReason reason)? ended,
    TResult? Function(List<String> errorCodes)? deviceError,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? active,
    TResult Function(SessionEndReason reason)? ended,
    TResult Function(List<String> errorCodes)? deviceError,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Active value) active,
    required TResult Function(_Ended value) ended,
    required TResult Function(_DeviceError value) deviceError,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Active value)? active,
    TResult? Function(_Ended value)? ended,
    TResult? Function(_DeviceError value)? deviceError,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Active value)? active,
    TResult Function(_Ended value)? ended,
    TResult Function(_DeviceError value)? deviceError,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements SessionState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$ActiveImplCopyWith<$Res> {
  factory _$$ActiveImplCopyWith(
          _$ActiveImpl value, $Res Function(_$ActiveImpl) then) =
      __$$ActiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActiveImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$ActiveImpl>
    implements _$$ActiveImplCopyWith<$Res> {
  __$$ActiveImplCopyWithImpl(
      _$ActiveImpl _value, $Res Function(_$ActiveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActiveImpl implements _Active {
  const _$ActiveImpl();

  @override
  String toString() {
    return 'SessionState.active()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ActiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() active,
    required TResult Function(SessionEndReason reason) ended,
    required TResult Function(List<String> errorCodes) deviceError,
  }) {
    return active();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? active,
    TResult? Function(SessionEndReason reason)? ended,
    TResult? Function(List<String> errorCodes)? deviceError,
  }) {
    return active?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? active,
    TResult Function(SessionEndReason reason)? ended,
    TResult Function(List<String> errorCodes)? deviceError,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Active value) active,
    required TResult Function(_Ended value) ended,
    required TResult Function(_DeviceError value) deviceError,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Active value)? active,
    TResult? Function(_Ended value)? ended,
    TResult? Function(_DeviceError value)? deviceError,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Active value)? active,
    TResult Function(_Ended value)? ended,
    TResult Function(_DeviceError value)? deviceError,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class _Active implements SessionState {
  const factory _Active() = _$ActiveImpl;
}

/// @nodoc
abstract class _$$EndedImplCopyWith<$Res> {
  factory _$$EndedImplCopyWith(
          _$EndedImpl value, $Res Function(_$EndedImpl) then) =
      __$$EndedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SessionEndReason reason});
}

/// @nodoc
class __$$EndedImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$EndedImpl>
    implements _$$EndedImplCopyWith<$Res> {
  __$$EndedImplCopyWithImpl(
      _$EndedImpl _value, $Res Function(_$EndedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$EndedImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as SessionEndReason,
    ));
  }
}

/// @nodoc

class _$EndedImpl implements _Ended {
  const _$EndedImpl({required this.reason});

  @override
  final SessionEndReason reason;

  @override
  String toString() {
    return 'SessionState.ended(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndedImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EndedImplCopyWith<_$EndedImpl> get copyWith =>
      __$$EndedImplCopyWithImpl<_$EndedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() active,
    required TResult Function(SessionEndReason reason) ended,
    required TResult Function(List<String> errorCodes) deviceError,
  }) {
    return ended(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? active,
    TResult? Function(SessionEndReason reason)? ended,
    TResult? Function(List<String> errorCodes)? deviceError,
  }) {
    return ended?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? active,
    TResult Function(SessionEndReason reason)? ended,
    TResult Function(List<String> errorCodes)? deviceError,
    required TResult orElse(),
  }) {
    if (ended != null) {
      return ended(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Active value) active,
    required TResult Function(_Ended value) ended,
    required TResult Function(_DeviceError value) deviceError,
  }) {
    return ended(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Active value)? active,
    TResult? Function(_Ended value)? ended,
    TResult? Function(_DeviceError value)? deviceError,
  }) {
    return ended?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Active value)? active,
    TResult Function(_Ended value)? ended,
    TResult Function(_DeviceError value)? deviceError,
    required TResult orElse(),
  }) {
    if (ended != null) {
      return ended(this);
    }
    return orElse();
  }
}

abstract class _Ended implements SessionState {
  const factory _Ended({required final SessionEndReason reason}) = _$EndedImpl;

  SessionEndReason get reason;
  @JsonKey(ignore: true)
  _$$EndedImplCopyWith<_$EndedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeviceErrorImplCopyWith<$Res> {
  factory _$$DeviceErrorImplCopyWith(
          _$DeviceErrorImpl value, $Res Function(_$DeviceErrorImpl) then) =
      __$$DeviceErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> errorCodes});
}

/// @nodoc
class __$$DeviceErrorImplCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$DeviceErrorImpl>
    implements _$$DeviceErrorImplCopyWith<$Res> {
  __$$DeviceErrorImplCopyWithImpl(
      _$DeviceErrorImpl _value, $Res Function(_$DeviceErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCodes = null,
  }) {
    return _then(_$DeviceErrorImpl(
      errorCodes: null == errorCodes
          ? _value._errorCodes
          : errorCodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$DeviceErrorImpl implements _DeviceError {
  const _$DeviceErrorImpl({required final List<String> errorCodes})
      : _errorCodes = errorCodes;

  final List<String> _errorCodes;
  @override
  List<String> get errorCodes {
    if (_errorCodes is EqualUnmodifiableListView) return _errorCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errorCodes);
  }

  @override
  String toString() {
    return 'SessionState.deviceError(errorCodes: $errorCodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceErrorImpl &&
            const DeepCollectionEquality()
                .equals(other._errorCodes, _errorCodes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_errorCodes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceErrorImplCopyWith<_$DeviceErrorImpl> get copyWith =>
      __$$DeviceErrorImplCopyWithImpl<_$DeviceErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() active,
    required TResult Function(SessionEndReason reason) ended,
    required TResult Function(List<String> errorCodes) deviceError,
  }) {
    return deviceError(errorCodes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? active,
    TResult? Function(SessionEndReason reason)? ended,
    TResult? Function(List<String> errorCodes)? deviceError,
  }) {
    return deviceError?.call(errorCodes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? active,
    TResult Function(SessionEndReason reason)? ended,
    TResult Function(List<String> errorCodes)? deviceError,
    required TResult orElse(),
  }) {
    if (deviceError != null) {
      return deviceError(errorCodes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Active value) active,
    required TResult Function(_Ended value) ended,
    required TResult Function(_DeviceError value) deviceError,
  }) {
    return deviceError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Active value)? active,
    TResult? Function(_Ended value)? ended,
    TResult? Function(_DeviceError value)? deviceError,
  }) {
    return deviceError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Active value)? active,
    TResult Function(_Ended value)? ended,
    TResult Function(_DeviceError value)? deviceError,
    required TResult orElse(),
  }) {
    if (deviceError != null) {
      return deviceError(this);
    }
    return orElse();
  }
}

abstract class _DeviceError implements SessionState {
  const factory _DeviceError({required final List<String> errorCodes}) =
      _$DeviceErrorImpl;

  List<String> get errorCodes;
  @JsonKey(ignore: true)
  _$$DeviceErrorImplCopyWith<_$DeviceErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
