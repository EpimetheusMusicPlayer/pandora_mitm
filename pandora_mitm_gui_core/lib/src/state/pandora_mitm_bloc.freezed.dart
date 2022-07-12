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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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

class _$DisconnectedPandoraMitmState extends DisconnectedPandoraMitmState
    with DiagnosticableTreeMixin {
  const _$DisconnectedPandoraMitmState() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PandoraMitmState.disconnected()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'PandoraMitmState.disconnected'));
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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

abstract class DisconnectedPandoraMitmState extends PandoraMitmState {
  const factory DisconnectedPandoraMitmState() = _$DisconnectedPandoraMitmState;
  const DisconnectedPandoraMitmState._() : super._();
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

class _$ConnectingPandoraMitmState extends ConnectingPandoraMitmState
    with DiagnosticableTreeMixin {
  const _$ConnectingPandoraMitmState() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PandoraMitmState.connecting()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'PandoraMitmState.connecting'));
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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

abstract class ConnectingPandoraMitmState extends PandoraMitmState {
  const factory ConnectingPandoraMitmState() = _$ConnectingPandoraMitmState;
  const ConnectingPandoraMitmState._() : super._();
}

/// @nodoc
abstract class _$$ConnectedPandoraMitmStateCopyWith<$Res> {
  factory _$$ConnectedPandoraMitmStateCopyWith(
          _$ConnectedPandoraMitmState value,
          $Res Function(_$ConnectedPandoraMitmState) then) =
      __$$ConnectedPandoraMitmStateCopyWithImpl<$Res>;
  $Res call(
      {PluginCapablePandoraMitm pandoraMitm,
      PandoraMitmRecord? selectedRecord,
      String? selectedApiMethod,
      ApiMethodInference? selectedInference,
      bool pluginListUpdating,
      RecordPlugin? recordPlugin,
      pmplg.InferencePlugin? inferencePlugin,
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
    Object? selectedRecord = freezed,
    Object? selectedApiMethod = freezed,
    Object? selectedInference = freezed,
    Object? pluginListUpdating = freezed,
    Object? recordPlugin = freezed,
    Object? inferencePlugin = freezed,
    Object? reauthenticationPlugin = freezed,
    Object? featureUnlockPlugin = freezed,
    Object? mitmproxyUiHelperPlugin = freezed,
  }) {
    return _then(_$ConnectedPandoraMitmState(
      pandoraMitm == freezed
          ? _value.pandoraMitm
          : pandoraMitm // ignore: cast_nullable_to_non_nullable
              as PluginCapablePandoraMitm,
      selectedRecord: selectedRecord == freezed
          ? _value.selectedRecord
          : selectedRecord // ignore: cast_nullable_to_non_nullable
              as PandoraMitmRecord?,
      selectedApiMethod: selectedApiMethod == freezed
          ? _value.selectedApiMethod
          : selectedApiMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedInference: selectedInference == freezed
          ? _value.selectedInference
          : selectedInference // ignore: cast_nullable_to_non_nullable
              as ApiMethodInference?,
      pluginListUpdating: pluginListUpdating == freezed
          ? _value.pluginListUpdating
          : pluginListUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      recordPlugin: recordPlugin == freezed
          ? _value.recordPlugin
          : recordPlugin // ignore: cast_nullable_to_non_nullable
              as RecordPlugin?,
      inferencePlugin: inferencePlugin == freezed
          ? _value.inferencePlugin
          : inferencePlugin // ignore: cast_nullable_to_non_nullable
              as pmplg.InferencePlugin?,
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

class _$ConnectedPandoraMitmState extends ConnectedPandoraMitmState
    with DiagnosticableTreeMixin {
  const _$ConnectedPandoraMitmState(this.pandoraMitm,
      {this.selectedRecord,
      this.selectedApiMethod,
      this.selectedInference,
      this.pluginListUpdating = false,
      this.recordPlugin,
      this.inferencePlugin,
      this.reauthenticationPlugin,
      this.featureUnlockPlugin,
      this.mitmproxyUiHelperPlugin})
      : super._();

  @override
  final PluginCapablePandoraMitm pandoraMitm;
  @override
  final PandoraMitmRecord? selectedRecord;
  @override
  final String? selectedApiMethod;
  @override
  final ApiMethodInference? selectedInference;
  @override
  @JsonKey()
  final bool pluginListUpdating;
  @override
  final RecordPlugin? recordPlugin;
  @override
  final pmplg.InferencePlugin? inferencePlugin;
  @override
  final pmplg.ReauthenticationPlugin? reauthenticationPlugin;
  @override
  final pmplg.FeatureUnlockPlugin? featureUnlockPlugin;
  @override
  final pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PandoraMitmState.connected(pandoraMitm: $pandoraMitm, selectedRecord: $selectedRecord, selectedApiMethod: $selectedApiMethod, selectedInference: $selectedInference, pluginListUpdating: $pluginListUpdating, recordPlugin: $recordPlugin, inferencePlugin: $inferencePlugin, reauthenticationPlugin: $reauthenticationPlugin, featureUnlockPlugin: $featureUnlockPlugin, mitmproxyUiHelperPlugin: $mitmproxyUiHelperPlugin)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PandoraMitmState.connected'))
      ..add(DiagnosticsProperty('pandoraMitm', pandoraMitm))
      ..add(DiagnosticsProperty('selectedRecord', selectedRecord))
      ..add(DiagnosticsProperty('selectedApiMethod', selectedApiMethod))
      ..add(DiagnosticsProperty('selectedInference', selectedInference))
      ..add(DiagnosticsProperty('pluginListUpdating', pluginListUpdating))
      ..add(DiagnosticsProperty('recordPlugin', recordPlugin))
      ..add(DiagnosticsProperty('inferencePlugin', inferencePlugin))
      ..add(
          DiagnosticsProperty('reauthenticationPlugin', reauthenticationPlugin))
      ..add(DiagnosticsProperty('featureUnlockPlugin', featureUnlockPlugin))
      ..add(DiagnosticsProperty(
          'mitmproxyUiHelperPlugin', mitmproxyUiHelperPlugin));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectedPandoraMitmState &&
            const DeepCollectionEquality()
                .equals(other.pandoraMitm, pandoraMitm) &&
            const DeepCollectionEquality()
                .equals(other.selectedRecord, selectedRecord) &&
            const DeepCollectionEquality()
                .equals(other.selectedApiMethod, selectedApiMethod) &&
            const DeepCollectionEquality()
                .equals(other.selectedInference, selectedInference) &&
            const DeepCollectionEquality()
                .equals(other.pluginListUpdating, pluginListUpdating) &&
            const DeepCollectionEquality()
                .equals(other.recordPlugin, recordPlugin) &&
            const DeepCollectionEquality()
                .equals(other.inferencePlugin, inferencePlugin) &&
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
      const DeepCollectionEquality().hash(selectedRecord),
      const DeepCollectionEquality().hash(selectedApiMethod),
      const DeepCollectionEquality().hash(selectedInference),
      const DeepCollectionEquality().hash(pluginListUpdating),
      const DeepCollectionEquality().hash(recordPlugin),
      const DeepCollectionEquality().hash(inferencePlugin),
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)
        connected,
    required TResult Function() disconnecting,
    required TResult Function() connectionFailed,
  }) {
    return connected(
        pandoraMitm,
        selectedRecord,
        selectedApiMethod,
        selectedInference,
        pluginListUpdating,
        recordPlugin,
        inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
            pmplg.ReauthenticationPlugin? reauthenticationPlugin,
            pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
            pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin)?
        connected,
    TResult Function()? disconnecting,
    TResult Function()? connectionFailed,
  }) {
    return connected?.call(
        pandoraMitm,
        selectedRecord,
        selectedApiMethod,
        selectedInference,
        pluginListUpdating,
        recordPlugin,
        inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
          selectedRecord,
          selectedApiMethod,
          selectedInference,
          pluginListUpdating,
          recordPlugin,
          inferencePlugin,
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

abstract class ConnectedPandoraMitmState extends PandoraMitmState {
  const factory ConnectedPandoraMitmState(
          final PluginCapablePandoraMitm pandoraMitm,
          {final PandoraMitmRecord? selectedRecord,
          final String? selectedApiMethod,
          final ApiMethodInference? selectedInference,
          final bool pluginListUpdating,
          final RecordPlugin? recordPlugin,
          final pmplg.InferencePlugin? inferencePlugin,
          final pmplg.ReauthenticationPlugin? reauthenticationPlugin,
          final pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
          final pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin}) =
      _$ConnectedPandoraMitmState;
  const ConnectedPandoraMitmState._() : super._();

  PluginCapablePandoraMitm get pandoraMitm;
  PandoraMitmRecord? get selectedRecord;
  String? get selectedApiMethod;
  ApiMethodInference? get selectedInference;
  bool get pluginListUpdating;
  RecordPlugin? get recordPlugin;
  pmplg.InferencePlugin? get inferencePlugin;
  pmplg.ReauthenticationPlugin? get reauthenticationPlugin;
  pmplg.FeatureUnlockPlugin? get featureUnlockPlugin;
  pmplg.MitmproxyUiHelperPlugin? get mitmproxyUiHelperPlugin;
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

class _$DisconnectingPandoraMitmState extends DisconnectingPandoraMitmState
    with DiagnosticableTreeMixin {
  const _$DisconnectingPandoraMitmState() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PandoraMitmState.disconnecting()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'PandoraMitmState.disconnecting'));
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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

abstract class DisconnectingPandoraMitmState extends PandoraMitmState {
  const factory DisconnectingPandoraMitmState() =
      _$DisconnectingPandoraMitmState;
  const DisconnectingPandoraMitmState._() : super._();
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
    extends ConnectionFailedPandoraMitmState with DiagnosticableTreeMixin {
  const _$ConnectionFailedPandoraMitmState() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PandoraMitmState.connectionFailed()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'PandoraMitmState.connectionFailed'));
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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
            PandoraMitmRecord? selectedRecord,
            String? selectedApiMethod,
            ApiMethodInference? selectedInference,
            bool pluginListUpdating,
            RecordPlugin? recordPlugin,
            pmplg.InferencePlugin? inferencePlugin,
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

abstract class ConnectionFailedPandoraMitmState extends PandoraMitmState {
  const factory ConnectionFailedPandoraMitmState() =
      _$ConnectionFailedPandoraMitmState;
  const ConnectionFailedPandoraMitmState._() : super._();
}
