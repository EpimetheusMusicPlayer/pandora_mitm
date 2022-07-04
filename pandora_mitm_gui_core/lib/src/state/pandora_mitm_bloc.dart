import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm/plugins.dart' show InferencePlugin; // for Freezed
import 'package:pandora_mitm_extra/plugins.dart' as pmeplg;
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

part 'pandora_mitm_bloc.freezed.dart';

class PandoraMitmBloc extends Cubit<PandoraMitmState> {
  PandoraMitmBloc() : super(const PandoraMitmState.disconnected());

  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
  }) async {
    emit(const PandoraMitmState.connecting());
    final pandoraMitm = BackgroundMitmproxyRiPandoraMitm()
      ..done.then((_) => emit(const PandoraMitmState.disconnected()));
    try {
      await pandoraMitm.connect(host: host, port: port);
      emit(PandoraMitmState.connected(pandoraMitm));
    } on IOException {
      emit(const PandoraMitmState.connectionFailed());
    }
  }

  Future<void> disconnect() async {
    final pandoraMitm = state.requireConnected.pandoraMitm;
    emit(const PandoraMitmState.disconnecting());
    await pandoraMitm.disconnect();
  }

  Future<ConnectedPandoraMitmState> _computeApiMethodSelection(
    String apiMethod,
    ConnectedPandoraMitmState state,
  ) async {
    final inference = await state.inferenceServerPlugin?.inferencePlugin
        .getInference(apiMethod);
    return state.copyWith(
      selectedApiMethod: apiMethod,
      selectedInference: inference,
    );
  }

  Future<void> selectRecord(int recordIndex) async {
    final state = this.state.requireConnected;
    assert(
      state.recordPlugin != null,
      'Cannot select a record - record plugin is not enabled!',
    );
    final record = state.recordPlugin!.messageRecorder.records[recordIndex];
    emit(
      // Compute the API method even if it doesn't change, to provide a
      // "refreshing" experience when a new record is selected.
      await _computeApiMethodSelection(
        record.apiRequest.method,
        state.copyWith(selectedRecord: record),
      ),
    );
  }

  Future<void> selectApiMethod(String apiMethod) async {
    final state = this.state.requireConnected;
    emit(
      await _computeApiMethodSelection(
        apiMethod,
        state.selectedRecord == null ||
                apiMethod == state.selectedRecord!.apiRequest.method
            ? state
            : state.copyWith(selectedRecord: null),
      ),
    );
  }

  Future<void> waitUntilPluginListUpdated() async {
    if (!state.requireConnected.pluginListUpdating) return;
    await stream.firstWhere(
      (state) =>
          state is ConnectedPandoraMitmState && !state.pluginListUpdating,
    );
  }

  Future<void> _enablePlugin<T extends PandoraMitmPlugin>(
    T Function() pluginFactory,
    int? Function(
      int? Function<T extends PandoraMitmPlugin>() indexOf,
      int? Function<T extends PandoraMitmPlugin>() indexAfter,
    )
        determineInsertionIndex,
    ConnectedPandoraMitmState Function(
      ConnectedPandoraMitmState state,
      T plugin,
    )
        updateState,
  ) async {
    final state = this.state.requireConnected;
    assert(!state.pluginListUpdating, 'Plugin list is updating!');
    final pandoraMitm = state.pandoraMitm;
    assert(
      pandoraMitm.pluginManager.plugins.whereType<T>().isEmpty,
      'Plugin of type $T is already enabled!',
    );

    int? indexOf<U extends PandoraMitmPlugin>() {
      assert(U != PandoraMitmPlugin, 'Plugin type not specified!');
      final pluginIndex =
          pandoraMitm.pluginManager.plugins.indexWhere((plugin) => plugin is U);
      if (pluginIndex == -1) return null;
      return pluginIndex;
    }

    int? indexAfter<U extends PandoraMitmPlugin>() {
      final pluginIndex = indexOf<U>();
      if (pluginIndex == null) return null;
      return pluginIndex + 1;
    }

    emit(state.copyWith(pluginListUpdating: true));
    final index = determineInsertionIndex(indexOf, indexAfter);
    final plugin = pluginFactory();
    if (index == null) {
      await pandoraMitm.pluginManager.addPlugin(plugin);
    } else {
      await pandoraMitm.pluginManager.insertPlugin(index, plugin);
    }
    emit(updateState(state, plugin).copyWith(pluginListUpdating: false));
  }

  Future<void> _disablePlugin<T extends PandoraMitmPlugin>(
    ConnectedPandoraMitmState Function(ConnectedPandoraMitmState state)
        updateState,
  ) async {
    final state = this.state.requireConnected;
    assert(!state.pluginListUpdating, 'Plugin list is updating!');
    final pandoraMitm = state.pandoraMitm;
    assert(T != PandoraMitmPlugin, 'Plugin type not specified!');
    assert(
      pandoraMitm.pluginManager.plugins.whereType<T>().isNotEmpty,
      'Plugin of type $T is not enabled!',
    );

    emit(state.copyWith(pluginListUpdating: true));
    await pandoraMitm.pluginManager.removePluginAt(
      pandoraMitm.pluginManager.plugins.indexWhere((plugin) => plugin is T),
    );
    emit(updateState(state).copyWith(pluginListUpdating: false));
  }

  Future<void> disableAllPlugins() async {
    final state = this.state.requireConnected;
    assert(!state.pluginListUpdating, 'Plugin list is updating!');
    final pandoraMitm = state.pandoraMitm;

    emit(state.copyWith(pluginListUpdating: true));
    await pandoraMitm.pluginManager.removeAllPlugins();
    emit(PandoraMitmState.connected(pandoraMitm));
  }

  Future<void> enableRecordPlugin() => _enablePlugin<RecordPlugin>(
        () => RecordPlugin(stripBoilerplate: true),
        (indexOf, indexAfter) => 0,
        (state, plugin) => state.copyWith(recordPlugin: plugin),
      );

  Future<void> disableRecordPlugin() => _disablePlugin<RecordPlugin>(
        (state) => state.copyWith(recordPlugin: null),
      );

  Future<void> enableInferenceServerPlugin() =>
      _enablePlugin<pmeplg.InferenceServerPlugin>(
        () => pmeplg.InferenceServerPlugin(
          pmplg.BackgroundInferencePlugin.new,
          port: 46337,
          stripBoilerplate: true,
        ),
        (indexOf, indexAfter) =>
            indexAfter<RecordPlugin>() ??
            indexOf<pmplg.MitmproxyUiHelperPlugin>(),
        (state, plugin) => state.copyWith(inferenceServerPlugin: plugin),
      );

  Future<void> disableInferenceServerPlugin() =>
      _disablePlugin<pmeplg.InferenceServerPlugin>(
        (state) => state.copyWith(inferenceServerPlugin: null),
      );

  Future<void> enableReauthenticationPlugin() =>
      _enablePlugin<pmplg.ReauthenticationPlugin>(
        () => pmplg.ReauthenticationPlugin(),
        (indexOf, indexAfter) =>
            indexOf<pmplg.FeatureUnlockPlugin>() ??
            indexOf<pmplg.MitmproxyUiHelperPlugin>(),
        (state, plugin) => state.copyWith(reauthenticationPlugin: plugin),
      );

  Future<void> disableReauthenticationPlugin() =>
      _disablePlugin<pmplg.ReauthenticationPlugin>(
        (state) => state.copyWith(reauthenticationPlugin: null),
      );

  Future<void> enableFeatureUnlockPlugin() =>
      _enablePlugin<pmplg.FeatureUnlockPlugin>(
        () => pmplg.FeatureUnlockPlugin(),
        (indexOf, indexAfter) =>
            indexAfter<pmplg.ReauthenticationPlugin>() ??
            indexOf<pmplg.MitmproxyUiHelperPlugin>(),
        (state, plugin) => state.copyWith(featureUnlockPlugin: plugin),
      );

  Future<void> disableFeatureUnlockPlugin() =>
      _disablePlugin<pmplg.FeatureUnlockPlugin>(
        (state) => state.copyWith(featureUnlockPlugin: null),
      );

  Future<void> enableMitmproxyUiHelperPlugin() =>
      _enablePlugin<pmplg.MitmproxyUiHelperPlugin>(
        () => pmplg.MitmproxyUiHelperPlugin(stripBoilerplate: true),
        (indexOf, indexAfter) => null,
        (state, plugin) => state.copyWith(mitmproxyUiHelperPlugin: plugin),
      );

  Future<void> disableMitmproxyUiHelperPlugin() =>
      _disablePlugin<pmplg.MitmproxyUiHelperPlugin>(
        (state) => state.copyWith(mitmproxyUiHelperPlugin: null),
      );
}

@freezed
class PandoraMitmState with _$PandoraMitmState {
  const PandoraMitmState._();

  const factory PandoraMitmState.disconnected() = DisconnectedPandoraMitmState;

  const factory PandoraMitmState.connecting() = ConnectingPandoraMitmState;

  const factory PandoraMitmState.connected(
    PluginCapablePandoraMitm pandoraMitm, {
    PandoraMitmRecord? selectedRecord,
    String? selectedApiMethod,
    ApiMethodInference? selectedInference,
    @Default(false) bool pluginListUpdating,
    RecordPlugin? recordPlugin,
    pmeplg.InferenceServerPlugin? inferenceServerPlugin,
    pmplg.ReauthenticationPlugin? reauthenticationPlugin,
    pmplg.FeatureUnlockPlugin? featureUnlockPlugin,
    pmplg.MitmproxyUiHelperPlugin? mitmproxyUiHelperPlugin,
  }) = ConnectedPandoraMitmState;

  const factory PandoraMitmState.disconnecting() =
      DisconnectingPandoraMitmState;

  const factory PandoraMitmState.connectionFailed() =
      ConnectionFailedPandoraMitmState;

  bool get allPluginsEnabled {
    final state = this;
    return state is ConnectedPandoraMitmState &&
        state.recordPlugin != null &&
        state.inferenceServerPlugin != null &&
        state.reauthenticationPlugin != null &&
        state.featureUnlockPlugin != null &&
        state.mitmproxyUiHelperPlugin != null;
  }

  ConnectedPandoraMitmState get requireConnected {
    assert(this is ConnectedPandoraMitmState, 'Not connected!');
    return this as ConnectedPandoraMitmState;
  }
}
