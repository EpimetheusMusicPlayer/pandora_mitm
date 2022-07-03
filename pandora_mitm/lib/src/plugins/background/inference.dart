import 'dart:async';
import 'dart:collection';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';
import 'package:pandora_mitm/src/plugins/inference.dart';

enum _BackgroundInferencePluginAction {
  setApiMethodWhitelist,
  setStripBoilerplate,
  getInferredApiMethods,
  getInferences,
  clear,
  getInference,
}

enum _BackgroundInferencePluginNotification { inferredApiMethod }

class BackgroundInferencePlugin extends ForegroundBuildingBackgroundBasePlugin<
    ForegroundInferencePlugin,
    _BackgroundInferencePluginAction,
    _BackgroundInferencePluginNotification> implements InferencePlugin {
  Set<String>? _apiMethodWhitelist;
  bool _stripBoilerplate;

  final _inferredApiMethodStreamController =
      StreamController<String>.broadcast();

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
  String get name => 'background_inference';

  @override
  ForegroundBuildingBackgroundPluginIsolateEntrypoint<ForegroundInferencePlugin>
      get isolateEntrypoint => BackgroundInferencePluginHost.new;

  @override
  ForegroundInferencePlugin buildPlugin() => ForegroundInferencePlugin(
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
      _BackgroundInferencePluginAction.setApiMethodWhitelist,
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
      _BackgroundInferencePluginAction.setStripBoilerplate,
      stripBoilerplate,
    );
  }

  @override
  Future<Set<String>> get inferredApiMethods =>
      doAction(_BackgroundInferencePluginAction.getInferredApiMethods);

  @override
  Stream<String> get inferredApiMethodStream =>
      _inferredApiMethodStreamController.stream;

  @override
  Future<Map<String, ApiMethodInference>> get inferences =>
      doAction(_BackgroundInferencePluginAction.getInferences);

  @override
  Future<void> clear() => doAction(_BackgroundInferencePluginAction.clear);

  @override
  Future<ApiMethodInference?> getInference(String apiMethod) =>
      doAction(_BackgroundInferencePluginAction.getInference, apiMethod);

  @override
  void onNotification(
    // ignore: library_private_types_in_public_api
    _BackgroundInferencePluginNotification tag,
    Object? message,
  ) {
    switch (tag) {
      case _BackgroundInferencePluginNotification.inferredApiMethod:
        _inferredApiMethodStreamController.add(message! as String);
        break;
    }
  }
}

class BackgroundInferencePluginHost
    extends ForegroundBuildingBackgroundPluginHost<
        ForegroundInferencePlugin,
        _BackgroundInferencePluginAction,
        _BackgroundInferencePluginNotification> {
  late final StreamSubscription<String> _inferredApiMethodSubscription;

  @override
  Future<void> attach() async {
    _inferredApiMethodSubscription = plugin.inferredApiMethodStream.listen(
      (apiMethod) => notify(
        _BackgroundInferencePluginNotification.inferredApiMethod,
        apiMethod,
      ),
    );
  }

  @override
  Future<void> detach() => _inferredApiMethodSubscription.cancel();

  @override
  // ignore: library_private_types_in_public_api
  Object? onAction(_BackgroundInferencePluginAction action, Object? argument) {
    switch (action) {
      case _BackgroundInferencePluginAction.setApiMethodWhitelist:
        plugin.apiMethodWhitelist = argument as Set<String>?;
        return null;
      case _BackgroundInferencePluginAction.setStripBoilerplate:
        plugin.stripBoilerplate = argument! as bool;
        return null;
      case _BackgroundInferencePluginAction.getInferredApiMethods:
        return plugin.inferredApiMethods;
      case _BackgroundInferencePluginAction.getInferences:
        return UnmodifiableMapView(plugin.inferences.precompute());
      case _BackgroundInferencePluginAction.clear:
        plugin.clear();
        return null;
      case _BackgroundInferencePluginAction.getInference:
        return plugin.getInference(argument! as String);
    }
  }

  BackgroundInferencePluginHost(super.payload);
}
