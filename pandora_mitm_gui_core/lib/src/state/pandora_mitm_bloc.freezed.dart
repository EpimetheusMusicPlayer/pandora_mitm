// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pandora_mitm_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PandoraMitmState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PandoraMitmStateCopyWith<$Res> {
  factory $PandoraMitmStateCopyWith(
          PandoraMitmState value, $Res Function(PandoraMitmState) then) =
      _$PandoraMitmStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PandoraMitmStateCopyWithImpl<$Res>
    implements $PandoraMitmStateCopyWith<$Res> {
  _$PandoraMitmStateCopyWithImpl(this._value, this._then);

  final PandoraMitmState _value;
  // ignore: unused_field
  final $Res Function(PandoraMitmState) _then;
}

/// @nodoc
abstract class _$$DisconnectedPandoraMitmStateCopyWith<$Res> {
  factory _$$DisconnectedPandoraMitmStateCopyWith(
          _$DisconnectedPandoraMitmState value,
          $Res Function(_$DisconnectedPandoraMitmState) then) =
      __$$DisconnectedPandoraMitmStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectedPandoraMitmStateCopyWithImpl<$Res>
    extends _$PandoraMitmStateCopyWithImpl<$Res>
    implements _$$DisconnectedPandoraMitmStateCopyWith<$Res> {
  __$$DisconnectedPandoraMitmStateCopyWithImpl(
      _$DisconnectedPandoraMitmState _value,
      $Res Function(_$DisconnectedPandoraMitmState) _then)
      : super(_value, (v) => _then(v as _$DisconnectedPandoraMitmState));

  @override
  _$DisconnectedPandoraMitmState get _value =>
      super._value as _$DisconnectedPandoraMitmState;
}

/// @nodoc

class _$DisconnectedPandoraMitmState implements DisconnectedPandoraMitmState {
  const _$DisconnectedPandoraMitmState();

  @override
  String toString() {
    return 'PandoraMitmState.disconnected()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisconnectedPandoraMitmState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return disconnected();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return disconnected?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class DisconnectedPandoraMitmState implements PandoraMitmState {
  const factory DisconnectedPandoraMitmState() = _$DisconnectedPandoraMitmState;
}

/// @nodoc
abstract class _$$ConnectingPandoraMitmStateCopyWith<$Res> {
  factory _$$ConnectingPandoraMitmStateCopyWith(
          _$ConnectingPandoraMitmState value,
          $Res Function(_$ConnectingPandoraMitmState) then) =
      __$$ConnectingPandoraMitmStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectingPandoraMitmStateCopyWithImpl<$Res>
    extends _$PandoraMitmStateCopyWithImpl<$Res>
    implements _$$ConnectingPandoraMitmStateCopyWith<$Res> {
  __$$ConnectingPandoraMitmStateCopyWithImpl(
      _$ConnectingPandoraMitmState _value,
      $Res Function(_$ConnectingPandoraMitmState) _then)
      : super(_value, (v) => _then(v as _$ConnectingPandoraMitmState));

  @override
  _$ConnectingPandoraMitmState get _value =>
      super._value as _$ConnectingPandoraMitmState;
}

/// @nodoc

class _$ConnectingPandoraMitmState implements ConnectingPandoraMitmState {
  const _$ConnectingPandoraMitmState();

  @override
  String toString() {
    return 'PandoraMitmState.connecting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectingPandoraMitmState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return connecting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return connecting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class ConnectingPandoraMitmState implements PandoraMitmState {
  const factory ConnectingPandoraMitmState() = _$ConnectingPandoraMitmState;
}

/// @nodoc
abstract class _$$ConnectedPandoraMitmStateCopyWith<$Res> {
  factory _$$ConnectedPandoraMitmStateCopyWith(
          _$ConnectedPandoraMitmState value,
          $Res Function(_$ConnectedPandoraMitmState) then) =
      __$$ConnectedPandoraMitmStateCopyWithImpl<$Res>;
  $Res call(
      {PluginCapablePandoraMitm pandoraMitm,
      bool pluginListUpdating,
      RecordPlugin? recordPlugin,
      pmeplg.InferenceServerPlugin<InferencePlugin>? inferenceServerPlugin,
      pmplg.ReauthenticationPlugin? reauthenticationPlugin,
      pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
      pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin});
}

/// @nodoc
class __$$ConnectedPandoraMitmStateCopyWithImpl<$Res>
    extends _$PandoraMitmStateCopyWithImpl<$Res>
    implements _$$ConnectedPandoraMitmStateCopyWith<$Res> {
  __$$ConnectedPandoraMitmStateCopyWithImpl(_$ConnectedPandoraMitmState _value,
      $Res Function(_$ConnectedPandoraMitmState) _then)
      : super(_value, (v) => _then(v as _$ConnectedPandoraMitmState));

  @override
  _$ConnectedPandoraMitmState get _value =>
      super._value as _$ConnectedPandoraMitmState;

  @override
  $Res call({
    Object? pandoraMitm = freezed,
    Object? pluginListUpdating = freezed,
    Object? recordPlugin = freezed,
    Object? inferenceServerPlugin = freezed,
    Object? reauthenticationPlugin = freezed,
    Object? featureUnlockPlugin = freezed,
    Object? mitmproxyUiHelperPlugin = freezed,
  }) {
    return _then(_$ConnectedPandoraMitmState(
      pandoraMitm == freezed
          ? _value.pandoraMitm
          : pandoraMitm // ignore: cast_nullable_to_non_nullable
              as PluginCapablePandoraMitm,
      pluginListUpdating: pluginListUpdating == freezed
          ? _value.pluginListUpdating
          : pluginListUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      recordPlugin: recordPlugin == freezed
          ? _value.recordPlugin
          : recordPlugin // ignore: cast_nullable_to_non_nullable
              as RecordPlugin?,
      inferenceServerPlugin: inferenceServerPlugin == freezed
          ? _value.inferenceServerPlugin
          : inferenceServerPlugin // ignore: cast_nullable_to_non_nullable
              as pmeplg.InferenceServerPlugin<InferencePlugin>?,
      reauthenticationPlugin: reauthenticationPlugin == freezed
          ? _value.reauthenticationPlugin
          : reauthenticationPlugin // ignore: cast_nullable_to_non_nullable
              as pmplg.ReauthenticationPlugin?,
      featureUnlockPlugin: featureUnlockPlugin == freezed
          ? _value.featureUnlockPlugin
          : featureUnlockPlugin // ignore: cast_nullable_to_non_nullable
              as pmplg.FeatureUnlockPlugin?,
      mitmproxyUiHelperPlugin: mitmproxyUiHelperPlugin == freezed
          ? _value.mitmproxyUiHelperPlugin
          : mitmproxyUiHelperPlugin // ignore: cast_nullable_to_non_nullable
              as pmplg.MitmproxyUiHelperPlugin?,
    ));
  }
}

/// @nodoc

class _$ConnectedPandoraMitmState implements ConnectedPandoraMitmState {
  const _$ConnectedPandoraMitmState(this.pandoraMitm,
      {this.pluginListUpdating = false,
      this.recordPlugin,
      this.inferenceServerPlugin,
      this.reauthenticationPlugin,
      this.featureUnlockPlugin,
      this.mitmproxyUiHelperPlugin});

  @override
  final PluginCapablePandoraMitm pandoraMitm;
  @override
  @JsonKey()
  final bool pluginListUpdating;
  @override
  final RecordPlugin? recordPlugin;
  @override
  final pmeplg.InferenceServerPlugin<InferencePlugin>? inferenceServerPlugin;
  @override
  final pmplg.ReauthenticationPlugin? reauthenticationPlugin;
  @override
  final pmplg.FeatureUnlockPlugin? featureUnlockPlugin;
  @override
  final pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin;

  @override
  String toString() {
    return 'PandoraMitmState.connected(pandoraMitm: $pandoraMitm, pluginListUpdating: $pluginListUpdating, recordPlugin: $recordPlugin, inferenceServerPlugin: $inferenceServerPlugin, reauthenticationPlugin: $reauthenticationPlugin, featureUnlockPlugin: $featureUnlockPlugin, mitmproxyUiHelperPlugin: $mitmproxyUiHelperPlugin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectedPandoraMitmState &&
            const DeepCollectionEquality()
                .equals(other.pandoraMitm, pandoraMitm) &&
            const DeepCollectionEquality()
                .equals(other.pluginListUpdating, pluginListUpdating) &&
            const DeepCollectionEquality()
                .equals(other.recordPlugin, recordPlugin) &&
            const DeepCollectionEquality()
                .equals(other.inferenceServerPlugin, inferenceServerPlugin) &&
            const DeepCollectionEquality()
                .equals(other.reauthenticationPlugin, reauthenticationPlugin) &&
            const DeepCollectionEquality()
                .equals(other.featureUnlockPlugin, featureUnlockPlugin) &&
            const DeepCollectionEquality().equals(
                other.mitmproxyUiHelperPlugin, mitmproxyUiHelperPlugin));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pandoraMitm),
      const DeepCollectionEquality().hash(pluginListUpdating),
      const DeepCollectionEquality().hash(recordPlugin),
      const DeepCollectionEquality().hash(inferenceServerPlugin),
      const DeepCollectionEquality().hash(reauthenticationPlugin),
      const DeepCollectionEquality().hash(featureUnlockPlugin),
      const DeepCollectionEquality().hash(mitmproxyUiHelperPlugin));

  @JsonKey(ignore: true)
  @override
  _$$ConnectedPandoraMitmStateCopyWith<_$ConnectedPandoraMitmState>
      get copyWith => __$$ConnectedPandoraMitmStateCopyWithImpl<
          _$ConnectedPandoraMitmState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return connected(
        pandoraMitm,
        pluginListUpdating,
        recordPlugin,
        inferenceServerPlugin,
        reauthenticationPlugin,
        featureUnlockPlugin,
        mitmproxyUiHelperPlugin);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return connected?.call(
        pandoraMitm,
        pluginListUpdating,
        recordPlugin,
        inferenceServerPlugin,
        reauthenticationPlugin,
        featureUnlockPlugin,
        mitmproxyUiHelperPlugin);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(
          pandoraMitm,
          pluginListUpdating,
          recordPlugin,
          inferenceServerPlugin,
          reauthenticationPlugin,
          featureUnlockPlugin,
          mitmproxyUiHelperPlugin);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class ConnectedPandoraMitmState implements PandoraMitmState {
  const factory ConnectedPandoraMitmState(
          final PluginCapablePandoraMitm pandoraMitm,
          {final bool pluginListUpdating,
          final RecordPlugin? recordPlugin,
          final pmeplg.InferenceServerPlugin<InferencePlugin>?
              inferenceServerPlugin,
          final pmplg.ReauthenticationPlugin? reauthenticationPlugin,
          final pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
          final pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin}) =
      _$ConnectedPandoraMitmState;

  PluginCapablePandoraMitm get pandoraMitm =>
      throw _privateConstructorUsedError;
  bool get pluginListUpdating => throw _privateConstructorUsedError;
  RecordPlugin? get recordPlugin => throw _privateConstructorUsedError;
  pmeplg.InferenceServerPlugin<InferencePlugin>? get inferenceServerPlugin =>
      throw _privateConstructorUsedError;
  pmplg.ReauthenticationPlugin? get reauthenticationPlugin =>
      throw _privateConstructorUsedError;
  pmplg.FeatureUnlockPlugin? get featureUnlockPlugin =>
      throw _privateConstructorUsedError;
  pmplg.MitmproxyUiHelperPlugin? get mitmproxyUiHelperPlugin =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$$ConnectedPandoraMitmStateCopyWith<_$ConnectedPandoraMitmState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DisconnectingPandoraMitmStateCopyWith<$Res> {
  factory _$$DisconnectingPandoraMitmStateCopyWith(
          _$DisconnectingPandoraMitmState value,
          $Res Function(_$DisconnectingPandoraMitmState) then) =
      __$$DisconnectingPandoraMitmStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DisconnectingPandoraMitmStateCopyWithImpl<$Res>
    extends _$PandoraMitmStateCopyWithImpl<$Res>
    implements _$$DisconnectingPandoraMitmStateCopyWith<$Res> {
  __$$DisconnectingPandoraMitmStateCopyWithImpl(
      _$DisconnectingPandoraMitmState _value,
      $Res Function(_$DisconnectingPandoraMitmState) _then)
      : super(_value, (v) => _then(v as _$DisconnectingPandoraMitmState));

  @override
  _$DisconnectingPandoraMitmState get _value =>
      super._value as _$DisconnectingPandoraMitmState;
}

/// @nodoc

class _$DisconnectingPandoraMitmState implements DisconnectingPandoraMitmState {
  const _$DisconnectingPandoraMitmState();

  @override
  String toString() {
    return 'PandoraMitmState.disconnecting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisconnectingPandoraMitmState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return disconnecting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return disconnecting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) {
    if (disconnecting != null) {
      return disconnecting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) {
    return disconnecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) {
    return disconnecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) {
    if (disconnecting != null) {
      return disconnecting(this);
    }
    return orElse();
  }
}

abstract class DisconnectingPandoraMitmState implements PandoraMitmState {
  const factory DisconnectingPandoraMitmState() =
      _$DisconnectingPandoraMitmState;
}

/// @nodoc
abstract class _$$ConnectionFailedPandoraMitmStateCopyWith<$Res> {
  factory _$$ConnectionFailedPandoraMitmStateCopyWith(
          _$ConnectionFailedPandoraMitmState value,
          $Res Function(_$ConnectionFailedPandoraMitmState) then) =
      __$$ConnectionFailedPandoraMitmStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConnectionFailedPandoraMitmStateCopyWithImpl<$Res>
    extends _$PandoraMitmStateCopyWithImpl<$Res>
    implements _$$ConnectionFailedPandoraMitmStateCopyWith<$Res> {
  __$$ConnectionFailedPandoraMitmStateCopyWithImpl(
      _$ConnectionFailedPandoraMitmState _value,
      $Res Function(_$ConnectionFailedPandoraMitmState) _then)
      : super(_value, (v) => _then(v as _$ConnectionFailedPandoraMitmState));

  @override
  _$ConnectionFailedPandoraMitmState get _value =>
      super._value as _$ConnectionFailedPandoraMitmState;
}

/// @nodoc

class _$ConnectionFailedPandoraMitmState
    implements ConnectionFailedPandoraMitmState {
  const _$ConnectionFailedPandoraMitmState();

  @override
  String toString() {
    return 'PandoraMitmState.connectionFailed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionFailedPandoraMitmState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disconnected,
    required TResult Function() connecting,
    required TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return connectionFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return connectionFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disconnected,
    TResult Function()? connecting,
    TResult Function(
            PluginCapablePandoraMitm pandoraMitm,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmeplg.InferenceServerPlugin<InferencePlugin>?
                inferenceServerPlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DisconnectedPandoraMitmState value) disconnected,
    required TResult Function(ConnectingPandoraMitmState value) connecting,
    required TResult Function(ConnectedPandoraMitmState value) connected,
    required TResult Function(DisconnectingPandoraMitmState value)
        disconnecting,
    required TResult Function(ConnectionFailedPandoraMitmState value)
        connectionFailed,
  }) {
    return connectionFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
  }) {
    return connectionFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DisconnectedPandoraMitmState value)? disconnected,
    TResult Function(ConnectingPandoraMitmState value)? connecting,
    TResult Function(ConnectedPandoraMitmState value)? connected,
    TResult Function(DisconnectingPandoraMitmState value)? disconnecting,
    TResult Function(ConnectionFailedPandoraMitmState value)? connectionFailed,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed(this);
    }
    return orElse();
  }
}

abstract class ConnectionFailedPandoraMitmState implements PandoraMitmState {
  const factory ConnectionFailedPandoraMitmState() =
      _$ConnectionFailedPandoraMitmState;
}
