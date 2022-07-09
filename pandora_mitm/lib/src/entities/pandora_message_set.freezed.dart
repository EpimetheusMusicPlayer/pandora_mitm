// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pandora_message_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PandoraMessageSet {
  PandoraApiRequest? get apiRequest => throw _privateConstructorUsedError;
  PandoraResponse? get response => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PandoraMessageSetCopyWith<PandoraMessageSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandoraMessageSetCopyWith<$Res> {
  factory $PandoraMessageSetCopyWith(
          PandoraMessageSet value, $Res Function(PandoraMessageSet) then) =
      _$PandoraMessageSetCopyWithImpl<$Res>;
  $Res call({PandoraApiRequest? apiRequest, PandoraResponse? response});

  $PandoraApiRequestCopyWith<$Res>? get apiRequest;
  $PandoraResponseCopyWith<$Res>? get response;
}

/// @nodoc
class _$PandoraMessageSetCopyWithImpl<$Res>
    implements $PandoraMessageSetCopyWith<$Res> {
  _$PandoraMessageSetCopyWithImpl(this._value, this._then);

  final PandoraMessageSet _value;
  // ignore: unused_field
  final $Res Function(PandoraMessageSet) _then;

  @override
  $Res call({
    Object? apiRequest = freezed,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      apiRequest: apiRequest == freezed
          ? _value.apiRequest
          : apiRequest // ignore: cast_nullable_to_non_nullable
              as PandoraApiRequest?,
      response: response == freezed
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as PandoraResponse?,
    ));
  }

  @override
  $PandoraApiRequestCopyWith<$Res>? get apiRequest {
    if (_value.apiRequest == null) {
      return null;
    }

    return $PandoraApiRequestCopyWith<$Res>(_value.apiRequest!, (value) {
      return _then(_value.copyWith(apiRequest: value));
    });
  }

  @override
  $PandoraResponseCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $PandoraResponseCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value));
    });
  }
}

/// @nodoc
abstract class _$$_PandoraMessageSetCopyWith<$Res>
    implements $PandoraMessageSetCopyWith<$Res> {
  factory _$$_PandoraMessageSetCopyWith(_$_PandoraMessageSet value,
          $Res Function(_$_PandoraMessageSet) then) =
      __$$_PandoraMessageSetCopyWithImpl<$Res>;
  @override
  $Res call({PandoraApiRequest? apiRequest, PandoraResponse? response});

  @override
  $PandoraApiRequestCopyWith<$Res>? get apiRequest;
  @override
  $PandoraResponseCopyWith<$Res>? get response;
}

/// @nodoc
class __$$_PandoraMessageSetCopyWithImpl<$Res>
    extends _$PandoraMessageSetCopyWithImpl<$Res>
    implements _$$_PandoraMessageSetCopyWith<$Res> {
  __$$_PandoraMessageSetCopyWithImpl(
      _$_PandoraMessageSet _value, $Res Function(_$_PandoraMessageSet) _then)
      : super(_value, (v) => _then(v as _$_PandoraMessageSet));

  @override
  _$_PandoraMessageSet get _value => super._value as _$_PandoraMessageSet;

  @override
  $Res call({
    Object? apiRequest = freezed,
    Object? response = freezed,
  }) {
    return _then(_$_PandoraMessageSet(
      apiRequest: apiRequest == freezed
          ? _value.apiRequest
          : apiRequest // ignore: cast_nullable_to_non_nullable
              as PandoraApiRequest?,
      response: response == freezed
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as PandoraResponse?,
    ));
  }
}

/// @nodoc

class _$_PandoraMessageSet implements _PandoraMessageSet {
  const _$_PandoraMessageSet({this.apiRequest, this.response});

  @override
  final PandoraApiRequest? apiRequest;
  @override
  final PandoraResponse? response;

  @override
  String toString() {
    return 'PandoraMessageSet(apiRequest: $apiRequest, response: $response)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PandoraMessageSet &&
            const DeepCollectionEquality()
                .equals(other.apiRequest, apiRequest) &&
            const DeepCollectionEquality().equals(other.response, response));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(apiRequest),
      const DeepCollectionEquality().hash(response));

  @JsonKey(ignore: true)
  @override
  _$$_PandoraMessageSetCopyWith<_$_PandoraMessageSet> get copyWith =>
      __$$_PandoraMessageSetCopyWithImpl<_$_PandoraMessageSet>(
          this, _$identity);
}

abstract class _PandoraMessageSet implements PandoraMessageSet {
  const factory _PandoraMessageSet(
      {final PandoraApiRequest? apiRequest,
      final PandoraResponse? response}) = _$_PandoraMessageSet;

  @override
  PandoraApiRequest? get apiRequest;
  @override
  PandoraResponse? get response;
  @override
  @JsonKey(ignore: true)
  _$$_PandoraMessageSetCopyWith<_$_PandoraMessageSet> get copyWith =>
      throw _privateConstructorUsedError;
}
