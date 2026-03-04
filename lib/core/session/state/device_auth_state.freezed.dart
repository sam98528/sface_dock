// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DeviceAuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceAuthStateCopyWith<$Res> {
  factory $DeviceAuthStateCopyWith(
    DeviceAuthState value,
    $Res Function(DeviceAuthState) then,
  ) = _$DeviceAuthStateCopyWithImpl<$Res, DeviceAuthState>;
}

/// @nodoc
class _$DeviceAuthStateCopyWithImpl<$Res, $Val extends DeviceAuthState>
    implements $DeviceAuthStateCopyWith<$Res> {
  _$DeviceAuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeviceAuthInitialImplCopyWith<$Res> {
  factory _$$DeviceAuthInitialImplCopyWith(
    _$DeviceAuthInitialImpl value,
    $Res Function(_$DeviceAuthInitialImpl) then,
  ) = __$$DeviceAuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeviceAuthInitialImplCopyWithImpl<$Res>
    extends _$DeviceAuthStateCopyWithImpl<$Res, _$DeviceAuthInitialImpl>
    implements _$$DeviceAuthInitialImplCopyWith<$Res> {
  __$$DeviceAuthInitialImplCopyWithImpl(
    _$DeviceAuthInitialImpl _value,
    $Res Function(_$DeviceAuthInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeviceAuthInitialImpl implements DeviceAuthInitial {
  const _$DeviceAuthInitialImpl();

  @override
  String toString() {
    return 'DeviceAuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeviceAuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class DeviceAuthInitial implements DeviceAuthState {
  const factory DeviceAuthInitial() = _$DeviceAuthInitialImpl;
}

/// @nodoc
abstract class _$$DeviceAuthNotLoggedInImplCopyWith<$Res> {
  factory _$$DeviceAuthNotLoggedInImplCopyWith(
    _$DeviceAuthNotLoggedInImpl value,
    $Res Function(_$DeviceAuthNotLoggedInImpl) then,
  ) = __$$DeviceAuthNotLoggedInImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeviceAuthNotLoggedInImplCopyWithImpl<$Res>
    extends _$DeviceAuthStateCopyWithImpl<$Res, _$DeviceAuthNotLoggedInImpl>
    implements _$$DeviceAuthNotLoggedInImplCopyWith<$Res> {
  __$$DeviceAuthNotLoggedInImplCopyWithImpl(
    _$DeviceAuthNotLoggedInImpl _value,
    $Res Function(_$DeviceAuthNotLoggedInImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeviceAuthNotLoggedInImpl implements DeviceAuthNotLoggedIn {
  const _$DeviceAuthNotLoggedInImpl();

  @override
  String toString() {
    return 'DeviceAuthState.notLoggedIn()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceAuthNotLoggedInImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) {
    return notLoggedIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) {
    return notLoggedIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notLoggedIn != null) {
      return notLoggedIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) {
    return notLoggedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) {
    return notLoggedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) {
    if (notLoggedIn != null) {
      return notLoggedIn(this);
    }
    return orElse();
  }
}

abstract class DeviceAuthNotLoggedIn implements DeviceAuthState {
  const factory DeviceAuthNotLoggedIn() = _$DeviceAuthNotLoggedInImpl;
}

/// @nodoc
abstract class _$$DeviceAuthLoggingInImplCopyWith<$Res> {
  factory _$$DeviceAuthLoggingInImplCopyWith(
    _$DeviceAuthLoggingInImpl value,
    $Res Function(_$DeviceAuthLoggingInImpl) then,
  ) = __$$DeviceAuthLoggingInImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeviceAuthLoggingInImplCopyWithImpl<$Res>
    extends _$DeviceAuthStateCopyWithImpl<$Res, _$DeviceAuthLoggingInImpl>
    implements _$$DeviceAuthLoggingInImplCopyWith<$Res> {
  __$$DeviceAuthLoggingInImplCopyWithImpl(
    _$DeviceAuthLoggingInImpl _value,
    $Res Function(_$DeviceAuthLoggingInImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeviceAuthLoggingInImpl implements DeviceAuthLoggingIn {
  const _$DeviceAuthLoggingInImpl();

  @override
  String toString() {
    return 'DeviceAuthState.loggingIn()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceAuthLoggingInImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) {
    return loggingIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) {
    return loggingIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loggingIn != null) {
      return loggingIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) {
    return loggingIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) {
    return loggingIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) {
    if (loggingIn != null) {
      return loggingIn(this);
    }
    return orElse();
  }
}

abstract class DeviceAuthLoggingIn implements DeviceAuthState {
  const factory DeviceAuthLoggingIn() = _$DeviceAuthLoggingInImpl;
}

/// @nodoc
abstract class _$$DeviceAuthLoggedInImplCopyWith<$Res> {
  factory _$$DeviceAuthLoggedInImplCopyWith(
    _$DeviceAuthLoggedInImpl value,
    $Res Function(_$DeviceAuthLoggedInImpl) then,
  ) = __$$DeviceAuthLoggedInImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String devicePassword, String? deviceId, String? deviceName});
}

/// @nodoc
class __$$DeviceAuthLoggedInImplCopyWithImpl<$Res>
    extends _$DeviceAuthStateCopyWithImpl<$Res, _$DeviceAuthLoggedInImpl>
    implements _$$DeviceAuthLoggedInImplCopyWith<$Res> {
  __$$DeviceAuthLoggedInImplCopyWithImpl(
    _$DeviceAuthLoggedInImpl _value,
    $Res Function(_$DeviceAuthLoggedInImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devicePassword = null,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
  }) {
    return _then(
      _$DeviceAuthLoggedInImpl(
        devicePassword: null == devicePassword
            ? _value.devicePassword
            : devicePassword // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: freezed == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deviceName: freezed == deviceName
            ? _value.deviceName
            : deviceName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DeviceAuthLoggedInImpl implements DeviceAuthLoggedIn {
  const _$DeviceAuthLoggedInImpl({
    required this.devicePassword,
    this.deviceId,
    this.deviceName,
  });

  @override
  final String devicePassword;
  @override
  final String? deviceId;
  @override
  final String? deviceName;

  @override
  String toString() {
    return 'DeviceAuthState.loggedIn(devicePassword: $devicePassword, deviceId: $deviceId, deviceName: $deviceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceAuthLoggedInImpl &&
            (identical(other.devicePassword, devicePassword) ||
                other.devicePassword == devicePassword) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, devicePassword, deviceId, deviceName);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceAuthLoggedInImplCopyWith<_$DeviceAuthLoggedInImpl> get copyWith =>
      __$$DeviceAuthLoggedInImplCopyWithImpl<_$DeviceAuthLoggedInImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) {
    return loggedIn(devicePassword, deviceId, deviceName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) {
    return loggedIn?.call(devicePassword, deviceId, deviceName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loggedIn != null) {
      return loggedIn(devicePassword, deviceId, deviceName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) {
    return loggedIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) {
    return loggedIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) {
    if (loggedIn != null) {
      return loggedIn(this);
    }
    return orElse();
  }
}

abstract class DeviceAuthLoggedIn implements DeviceAuthState {
  const factory DeviceAuthLoggedIn({
    required final String devicePassword,
    final String? deviceId,
    final String? deviceName,
  }) = _$DeviceAuthLoggedInImpl;

  String get devicePassword;
  String? get deviceId;
  String? get deviceName;

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceAuthLoggedInImplCopyWith<_$DeviceAuthLoggedInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeviceAuthErrorImplCopyWith<$Res> {
  factory _$$DeviceAuthErrorImplCopyWith(
    _$DeviceAuthErrorImpl value,
    $Res Function(_$DeviceAuthErrorImpl) then,
  ) = __$$DeviceAuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DeviceAuthErrorImplCopyWithImpl<$Res>
    extends _$DeviceAuthStateCopyWithImpl<$Res, _$DeviceAuthErrorImpl>
    implements _$$DeviceAuthErrorImplCopyWith<$Res> {
  __$$DeviceAuthErrorImplCopyWithImpl(
    _$DeviceAuthErrorImpl _value,
    $Res Function(_$DeviceAuthErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$DeviceAuthErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeviceAuthErrorImpl implements DeviceAuthError {
  const _$DeviceAuthErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'DeviceAuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceAuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceAuthErrorImplCopyWith<_$DeviceAuthErrorImpl> get copyWith =>
      __$$DeviceAuthErrorImplCopyWithImpl<_$DeviceAuthErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() notLoggedIn,
    required TResult Function() loggingIn,
    required TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )
    loggedIn,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? notLoggedIn,
    TResult? Function()? loggingIn,
    TResult? Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? notLoggedIn,
    TResult Function()? loggingIn,
    TResult Function(
      String devicePassword,
      String? deviceId,
      String? deviceName,
    )?
    loggedIn,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeviceAuthInitial value) initial,
    required TResult Function(DeviceAuthNotLoggedIn value) notLoggedIn,
    required TResult Function(DeviceAuthLoggingIn value) loggingIn,
    required TResult Function(DeviceAuthLoggedIn value) loggedIn,
    required TResult Function(DeviceAuthError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeviceAuthInitial value)? initial,
    TResult? Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult? Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult? Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult? Function(DeviceAuthError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeviceAuthInitial value)? initial,
    TResult Function(DeviceAuthNotLoggedIn value)? notLoggedIn,
    TResult Function(DeviceAuthLoggingIn value)? loggingIn,
    TResult Function(DeviceAuthLoggedIn value)? loggedIn,
    TResult Function(DeviceAuthError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DeviceAuthError implements DeviceAuthState {
  const factory DeviceAuthError({required final String message}) =
      _$DeviceAuthErrorImpl;

  String get message;

  /// Create a copy of DeviceAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceAuthErrorImplCopyWith<_$DeviceAuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
