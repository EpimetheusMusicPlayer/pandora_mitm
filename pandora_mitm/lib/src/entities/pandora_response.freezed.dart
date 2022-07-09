// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pandora_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PandoraResponse {
  int get statusCode => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  Map<String, List<String>> get headers => throw _privateConstructorUsedError;
  bool get encryptedBody => throw _privateConstructorUsedError;
  PandoraApiResponse get apiResponse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PandoraResponseCopyWith<PandoraResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandoraResponseCopyWith<$Res> {
  factory $PandoraResponseCopyWith(
          PandoraResponse value, $Res Function(PandoraResponse) then) =
      _$PandoraResponseCopyWithImpl<$Res>;
  $Res call(
      {int statusCode,
      String? reason,
      Map<String, List<String>> headers,
      bool encryptedBody,
      PandoraApiResponse apiResponse});

  $PandoraApiResponseCopyWith<$Res> get apiResponse;
}

/// @nodoc
class _$PandoraResponseCopyWithImpl<$Res>
    implements $PandoraResponseCopyWith<$Res> {
  _$PandoraResponseCopyWithImpl(this._value, this._then);

  final PandoraResponse _value;
  // ignore: unused_field
  final $Res Function(PandoraResponse) _then;

  @override
  $Res call({
    Object? statusCode = freezed,
    Object? reason = freezed,
    Object? headers = freezed,
    Object? encryptedBody = freezed,
    Object? apiResponse = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      reason: reason == freezed
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      headers: headers == freezed
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      encryptedBody: encryptedBody == freezed
          ? _value.encryptedBody
          : encryptedBody // ignore: cast_nullable_to_non_nullable
              as bool,
      apiResponse: apiResponse == freezed
          ? _value.apiResponse
          : apiResponse // ignore: cast_nullable_to_non_nullable
              as PandoraApiResponse,
    ));
  }

  @override
  $PandoraApiResponseCopyWith<$Res> get apiResponse {
    return $PandoraApiResponseCopyWith<$Res>(_value.apiResponse, (value) {
      return _then(_value.copyWith(apiResponse: value));
    });
  }
}

/// @nodoc
abstract class _$$_PandoraResponseCopyWith<$Res>
    implements $PandoraResponseCopyWith<$Res> {
  factory _$$_PandoraResponseCopyWith(
          _$_PandoraResponse value, $Res Function(_$_PandoraResponse) then) =
      __$$_PandoraResponseCopyWithImpl<$Res>;
  @override
  $Res call(
      {int statusCode,
      String? reason,
      Map<String, List<String>> headers,
      bool encryptedBody,
      PandoraApiResponse apiResponse});

  @override
  $PandoraApiResponseCopyWith<$Res> get apiResponse;
}

/// @nodoc
class __$$_PandoraResponseCopyWithImpl<$Res>
    extends _$PandoraResponseCopyWithImpl<$Res>
    implements _$$_PandoraResponseCopyWith<$Res> {
  __$$_PandoraResponseCopyWithImpl(
      _$_PandoraResponse _value, $Res Function(_$_PandoraResponse) _then)
      : super(_value, (v) => _then(v as _$_PandoraResponse));

  @override
  _$_PandoraResponse get _value => super._value as _$_PandoraResponse;

  @override
  $Res call({
    Object? statusCode = freezed,
    Object? reason = freezed,
    Object? headers = freezed,
    Object? encryptedBody = freezed,
    Object? apiResponse = freezed,
  }) {
    return _then(_$_PandoraResponse(
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      reason: reason == freezed
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      headers: headers == freezed
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      encryptedBody: encryptedBody == freezed
          ? _value.encryptedBody
          : encryptedBody // ignore: cast_nullable_to_non_nullable
              as bool,
      apiResponse: apiResponse == freezed
          ? _value.apiResponse
          : apiResponse // ignore: cast_nullable_to_non_nullable
              as PandoraApiResponse,
    ));
  }
}

/// @nodoc

class _$_PandoraResponse implements _PandoraResponse {
  const _$_PandoraResponse(
      {this.statusCode = 200,
      this.reason,
      final Map<String, List<String>> headers = const {
        'server': ['envoy'],
        'content-type': ['text/plain;charset=utf-8']
      },
      this.encryptedBody = false,
      required this.apiResponse})
      : _headers = headers;

  @override
  @JsonKey()
  final int statusCode;
  @override
  final String? reason;
  final Map<String, List<String>> _headers;
  @override
  @JsonKey()
  Map<String, List<String>> get headers {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_headers);
  }

  @override
  @JsonKey()
  final bool encryptedBody;
  @override
  final PandoraApiResponse apiResponse;

  @override
  String toString() {
    return 'PandoraResponse(statusCode: $statusCode, reason: $reason, headers: $headers, encryptedBody: $encryptedBody, apiResponse: $apiResponse)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PandoraResponse &&
            const DeepCollectionEquality()
                .equals(other.statusCode, statusCode) &&
            const DeepCollectionEquality().equals(other.reason, reason) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other.encryptedBody, encryptedBody) &&
            const DeepCollectionEquality()
                .equals(other.apiResponse, apiResponse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(statusCode),
      const DeepCollectionEquality().hash(reason),
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(encryptedBody),
      const DeepCollectionEquality().hash(apiResponse));

  @JsonKey(ignore: true)
  @override
  _$$_PandoraResponseCopyWith<_$_PandoraResponse> get copyWith =>
      __$$_PandoraResponseCopyWithImpl<_$_PandoraResponse>(this, _$identity);
}

abstract class _PandoraResponse implements PandoraResponse {
  const factory _PandoraResponse(
      {final int statusCode,
      final String? reason,
      final Map<String, List<String>> headers,
      final bool encryptedBody,
      required final PandoraApiResponse apiResponse}) = _$_PandoraResponse;

  @override
  int get statusCode;
  @override
  String? get reason;
  @override
  Map<String, List<String>> get headers;
  @override
  bool get encryptedBody;
  @override
  PandoraApiResponse get apiResponse;
  @override
  @JsonKey(ignore: true)
  _$$_PandoraResponseCopyWith<_$_PandoraResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
