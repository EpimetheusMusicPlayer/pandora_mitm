import 'dart:collection';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';
import 'package:pandora_mitm/src/plugins/inference.dart';

enum BackgroundInferencePluginAction {
  getRequestApiMethods,
  getResponseApiMethods,
  getAllApiMethods,
  getApiMethodWhitelist,
  setApiMethodWhitelist,
  getStripBoilerplate,
  setStripBoilerplate,
  zipReferences,
}

class BackgroundInferencePlugin extends ForegroundBuildingBackgroundBasePlugin<
    InferencePlugin, BackgroundInferencePluginAction> {
  @override
  ForegroundBuildingBackgroundPluginIsolateEntrypoint<InferencePlugin>
      get isolateEntrypoint => BackgroundInferencePluginHost.new;

  @override
  InferencePlugin buildPlugin() => InferencePlugin();

  Future<Set<String>?> getApiMethodWhitelist() async =>
      doAction(BackgroundInferencePluginAction.getApiMethodWhitelist);

  Future<void> setApiMethodWhitelist(Set<String>? apiMethodWhitelist) =>
      doAction(
        BackgroundInferencePluginAction.setApiMethodWhitelist,
        apiMethodWhitelist,
      );

  Future<bool> getStripBoilerplate() async =>
      doAction(BackgroundInferencePluginAction.getStripBoilerplate);

  // ignore: avoid_positional_boolean_parameters
  Future<void> setStripBoilerplate(bool stripBoilerplate) => doAction(
        BackgroundInferencePluginAction.setStripBoilerplate,
        stripBoilerplate,
      );

  Future<Set<String>> getRequestApiMethods() async =>
      doAction(BackgroundInferencePluginAction.getRequestApiMethods);

  Future<Set<String>> getResponseApiMethods() async =>
      doAction(BackgroundInferencePluginAction.getResponseApiMethods);

  Future<Set<String>> getAllApiMethods() async =>
      doAction(BackgroundInferencePluginAction.getAllApiMethods);

  Future<Map<String, PrecomputedApiMethodInference>> zipReferences() async =>
      doAction(BackgroundInferencePluginAction.zipReferences);
}

class BackgroundInferencePluginHost
    extends ForegroundBuildingBackgroundPluginHost<InferencePlugin,
        BackgroundInferencePluginAction> {
  @override
  Object? onAction(BackgroundInferencePluginAction action, Object? argument) {
    switch (action) {
      case BackgroundInferencePluginAction.getApiMethodWhitelist:
        return plugin.apiMethodWhitelist;
      case BackgroundInferencePluginAction.setApiMethodWhitelist:
        plugin.apiMethodWhitelist = argument! as Set<String>;
        return null;
      case BackgroundInferencePluginAction.getStripBoilerplate:
        return plugin.stripBoilerplate;
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
      case BackgroundInferencePluginAction.zipReferences:
        return plugin.zipInferences().precompute();
    }
  }

  BackgroundInferencePluginHost(super.payload);
}
