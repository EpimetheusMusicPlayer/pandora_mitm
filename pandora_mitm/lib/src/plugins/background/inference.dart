import 'dart:collection';

import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';
import 'package:pandora_mitm/src/plugins/inference.dart';

enum BackgroundInferencePluginAction {
  setApiMethodWhitelist,
  setStripBoilerplate,
  getRequestApiMethods,
  getResponseApiMethods,
  getAllApiMethods,
  getRequestValueTypes,
  getResponseValueTypes,
  zipInferences,
}

class BackgroundInferencePlugin extends ForegroundBuildingBackgroundBasePlugin<
    InferencePlugin,
    BackgroundInferencePluginAction> implements InferencePluginDefinition {
  Set<String>? _apiMethodWhitelist;
  bool _stripBoilerplate;

  /// Creates a new [BackgroundInferencePlugin].
  ///
  /// The given [apiMethodWhitelist] cannot be mutated directly - instead, it
  /// must be replaced with [applyApiMethodWhitelist].
  BackgroundInferencePlugin({
    Set<String>? apiMethodWhitelist,
    bool stripBoilerplate = false,
  })  : _apiMethodWhitelist = apiMethodWhitelist,
        _stripBoilerplate = stripBoilerplate;

  @override
  ForegroundBuildingBackgroundPluginIsolateEntrypoint<InferencePlugin>
      get isolateEntrypoint => BackgroundInferencePluginHost.new;

  @override
  InferencePlugin buildPlugin() => InferencePlugin(
        apiMethodWhitelist: _apiMethodWhitelist,
        stripBoilerplate: _stripBoilerplate,
      );

  @override
  Set<String>? get apiMethodWhitelist => _apiMethodWhitelist == null
      ? null
      : UnmodifiableSetView(apiMethodWhitelist!);

  @override
  set apiMethodWhitelist(Set<String>? apiMethodWhitelist) =>
      applyApiMethodWhitelist(apiMethodWhitelist);

  @override
  Future<void> applyApiMethodWhitelist(Set<String>? apiMethodWhitelist) {
    _apiMethodWhitelist = apiMethodWhitelist;
    return doAction(
      BackgroundInferencePluginAction.setApiMethodWhitelist,
      apiMethodWhitelist,
    ).then(
      (result) =>
          result == null ? null : UnmodifiableSetView(result as Set<String>),
    );
  }

  @override
  bool get stripBoilerplate => _stripBoilerplate;

  @override
  set stripBoilerplate(bool stripBoilerplate) =>
      applyStripBoilerplate(stripBoilerplate);

  // ignore: avoid_positional_boolean_parameters
  @override
  Future<void> applyStripBoilerplate(bool stripBoilerplate) {
    _stripBoilerplate = stripBoilerplate;
    return doAction(
      BackgroundInferencePluginAction.setStripBoilerplate,
      stripBoilerplate,
    );
  }

  Future<Set<String>> getRequestApiMethods() =>
      doAction(BackgroundInferencePluginAction.getRequestApiMethods);

  Future<Set<String>> getResponseApiMethods() =>
      doAction(BackgroundInferencePluginAction.getResponseApiMethods);

  Future<Set<String>> getAllApiMethods() =>
      doAction(BackgroundInferencePluginAction.getAllApiMethods);

  @override
  Future<Map<String, ValueType>> get requestValueTypes =>
      doAction(BackgroundInferencePluginAction.getRequestValueTypes);

  @override
  Future<Map<String, ValueType>> get responseValueTypes =>
      doAction(BackgroundInferencePluginAction.getResponseValueTypes);

  @override
  Future<Map<String, PrecomputedApiMethodInference>> zipInferences() =>
      doAction(BackgroundInferencePluginAction.zipInferences);
}

class BackgroundInferencePluginHost
    extends ForegroundBuildingBackgroundPluginHost<InferencePlugin,
        BackgroundInferencePluginAction> {
  @override
  Object? onAction(BackgroundInferencePluginAction action, Object? argument) {
    switch (action) {
      case BackgroundInferencePluginAction.setApiMethodWhitelist:
        plugin.apiMethodWhitelist = argument as Set<String>?;
        return null;
      case BackgroundInferencePluginAction.setStripBoilerplate:
        plugin.stripBoilerplate = argument! as bool;
        return null;
      case BackgroundInferencePluginAction.getRequestApiMethods:
        return SplayTreeSet.of(plugin.requestValueTypes.keys);
      case BackgroundInferencePluginAction.getResponseApiMethods:
        return SplayTreeSet.of(plugin.responseValueTypes.keys);
      case BackgroundInferencePluginAction.getAllApiMethods:
        return SplayTreeSet.of(plugin.requestValueTypes.keys)
          ..addAll(plugin.responseValueTypes.keys);
      case BackgroundInferencePluginAction.getRequestValueTypes:
        return plugin.requestValueTypes;
      case BackgroundInferencePluginAction.getResponseValueTypes:
        return plugin.responseValueTypes;
      case BackgroundInferencePluginAction.zipInferences:
        return plugin.zipInferences().precompute();
    }
  }

  BackgroundInferencePluginHost(super.payload);
}
