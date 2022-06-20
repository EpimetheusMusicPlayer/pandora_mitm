// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'api_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PandoraApiRequest {
  int? get partnerId => throw _privateConstructorUsedError;
  String? get authToken => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  bool get encrypted => throw _privateConstructorUsedError;
  Map<String, dynamic> get body => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PandoraApiRequestCopyWith<PandoraApiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandoraApiRequestCopyWith<$Res> {
  factory $PandoraApiRequestCopyWith(
          PandoraApiRequest value, $Res Function(PandoraApiRequest) then) =
      _$PandoraApiRequestCopyWithImpl<$Res>;
  $Res call(
      {int? partnerId,
      String? authToken,
      String? deviceId,
      String method,
      bool encrypted,
      Map<String, dynamic> body});
}

/// @nodoc
class _$PandoraApiRequestCopyWithImpl<$Res>
    implements $PandoraApiRequestCopyWith<$Res> {
  _$PandoraApiRequestCopyWithImpl(this._value, this._then);

  final PandoraApiRequest _value;
  // ignore: unused_field
  final $Res Function(PandoraApiRequest) _then;

  @override
  $Res call({
    Object? partnerId = freezed,
    Object? authToken = freezed,
    Object? deviceId = freezed,
    Object? method = freezed,
    Object? encrypted = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      partnerId: partnerId == freezed
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int?,
      authToken: authToken == freezed
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      method: method == freezed
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      encrypted: encrypted == freezed
          ? _value.encrypted
          : encrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$$_PandoraApiRequestCopyWith<$Res>
    implements $PandoraApiRequestCopyWith<$Res> {
  factory _$$_PandoraApiRequestCopyWith(_$_PandoraApiRequest value,
          $Res Function(_$_PandoraApiRequest) then) =
      __$$_PandoraApiRequestCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? partnerId,
      String? authToken,
      String? deviceId,
      String method,
      bool encrypted,
      Map<String, dynamic> body});
}

/// @nodoc
class __$$_PandoraApiRequestCopyWithImpl<$Res>
    extends _$PandoraApiRequestCopyWithImpl<$Res>
    implements _$$_PandoraApiRequestCopyWith<$Res> {
  __$$_PandoraApiRequestCopyWithImpl(
      _$_PandoraApiRequest _value, $Res Function(_$_PandoraApiRequest) _then)
      : super(_value, (v) => _then(v as _$_PandoraApiRequest));

  @override
  _$_PandoraApiRequest get _value => super._value as _$_PandoraApiRequest;

  @override
  $Res call({
    Object? partnerId = freezed,
    Object? authToken = freezed,
    Object? deviceId = freezed,
    Object? method = freezed,
    Object? encrypted = freezed,
    Object? body = freezed,
  }) {
    return _then(_$_PandoraApiRequest(
      partnerId: partnerId == freezed
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int?,
      authToken: authToken == freezed
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      method: method == freezed
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      encrypted: encrypted == freezed
          ? _value.encrypted
          : encrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      body: body == freezed
          ? _value._body
          : body // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$_PandoraApiRequest extends _PandoraApiRequest {
  const _$_PandoraApiRequest(
      {this.partnerId,
      this.authToken,
      this.deviceId,
      required this.method,
      this.encrypted = false,
      required final Map<String, dynamic> body})
      : _body = body,
        super._();

  @override
  final int? partnerId;
  @override
  final String? authToken;
  @override
  final String? deviceId;
  @override
  final String method;
  @override
  @JsonKey()
  final bool encrypted;
  final Map<String, dynamic> _body;
  @override
  Map<String, dynamic> get body {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_body);
  }

  @override
  String toString() {
    return 'PandoraApiRequest(partnerId: $partnerId, authToken: $authToken, deviceId: $deviceId, method: $method, encrypted: $encrypted, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PandoraApiRequest &&
            const DeepCollectionEquality().equals(other.partnerId, partnerId) &&
            const DeepCollectionEquality().equals(other.authToken, authToken) &&
            const DeepCollectionEquality().equals(other.deviceId, deviceId) &&
            const DeepCollectionEquality().equals(other.method, method) &&
            const DeepCollectionEquality().equals(other.encrypted, encrypted) &&
            const DeepCollectionEquality().equals(other._body, _body));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(partnerId),
      const DeepCollectionEquality().hash(authToken),
      const DeepCollectionEquality().hash(deviceId),
      const DeepCollectionEquality().hash(method),
      const DeepCollectionEquality().hash(encrypted),
      const DeepCollectionEquality().hash(_body));

  @JsonKey(ignore: true)
  @override
  _$$_PandoraApiRequestCopyWith<_$_PandoraApiRequest> get copyWith =>
      __$$_PandoraApiRequestCopyWithImpl<_$_PandoraApiRequest>(
          this, _$identity);
}

abstract class _PandoraApiRequest extends PandoraApiRequest {
  const factory _PandoraApiRequest(
      {final int? partnerId,
      final String? authToken,
      final String? deviceId,
      required final String method,
      final bool encrypted,
      required final Map<String, dynamic> body}) = _$_PandoraApiRequest;
  const _PandoraApiRequest._() : super._();

  @override
  int? get partnerId => throw _privateConstructorUsedError;
  @override
  String? get authToken => throw _privateConstructorUsedError;
  @override
  String? get deviceId => throw _privateConstructorUsedError;
  @override
  String get method => throw _privateConstructorUsedError;
  @override
  bool get encrypted => throw _privateConstructorUsedError;
  @override
  Map<String, dynamic> get body => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PandoraApiRequestCopyWith<_$_PandoraApiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
