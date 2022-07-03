import 'dart:async';
import 'dart:collection';

import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';
import 'package:pandora_mitm/src/plugins/inference.dart';

enum _BackgroundInferencePluginAction {
  setApiMethodWhitelist,
  setStripBoilerplate,
  getRequestApiMethods,
  getResponseApiMethods,
  getAllApiMethods,
  getRequestValueTypes,
  getResponseValueTypes,
  zipInferences,
}

enum _BackgroundInferencePluginNotification {
  requestValueTypeUpdated,
  responseValueTypeUpdated,
}

class BackgroundInferencePlugin extends ForegroundBuildingBackgroundBasePlugin<
    ForegroundInferencePlugin,
    _BackgroundInferencePluginAction,
    _BackgroundInferencePluginNotification> implements InferencePlugin {
  Set<String>? _apiMethodWhitelist;
  bool _stripBoilerplate;

  final _requestValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();
  final _responseValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();

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

  Future<Set<String>> getRequestApiMethods() =>
      doAction(_BackgroundInferencePluginAction.getRequestApiMethods);

  Future<Set<String>> getResponseApiMethods() =>
      doAction(_BackgroundInferencePluginAction.getResponseApiMethods);

  Future<Set<String>> getAllApiMethods() =>
      doAction(_BackgroundInferencePluginAction.getAllApiMethods);

  @override
  Future<Map<String, ValueType>> get requestValueTypes =>
      doAction(_BackgroundInferencePluginAction.getRequestValueTypes);

  @override
  Future<Map<String, ValueType>> get responseValueTypes =>
      doAction(_BackgroundInferencePluginAction.getResponseValueTypes);

  @override
  Stream<MapEntry<String, ValueType>> get requestValueTypeStream =>
      _requestValueTypeStreamController.stream;

  @override
  Stream<MapEntry<String, ValueType>> get responseValueTypeStream =>
      _responseValueTypeStreamController.stream;

  @override
  Future<Map<String, PrecomputedApiMethodInference>> zipInferences() =>
      doAction(_BackgroundInferencePluginAction.zipInferences);

  @override
  void onNotification(
    // ignore: library_private_types_in_public_api
    _BackgroundInferencePluginNotification tag,
    Object? message,
  ) {
    switch (tag) {
      case _BackgroundInferencePluginNotification.requestValueTypeUpdated:
        _requestValueTypeStreamController
            .add(message! as MapEntry<String, ValueType>);
        break;
      case _BackgroundInferencePluginNotification.responseValueTypeUpdated:
        _responseValueTypeStreamController
            .add(message! as MapEntry<String, ValueType>);
        break;
    }
  }
}

class BackgroundInferencePluginHost
    extends ForegroundBuildingBackgroundPluginHost<
        ForegroundInferencePlugin,
        _BackgroundInferencePluginAction,
        _BackgroundInferencePluginNotification> {
  late final StreamSubscription<MapEntry<String, ValueType>>
      _requestValueTypeSubscription;

  late final StreamSubscription<MapEntry<String, ValueType>>
      _responseValueTypeSubscription;

  @override
  Future<void> attach() async {
    _requestValueTypeSubscription = plugin.requestValueTypeStream.listen(
      (entry) => notify(
        _BackgroundInferencePluginNotification.requestValueTypeUpdated,
        entry,
      ),
    );
    _responseValueTypeSubscription = plugin.responseValueTypeStream.listen(
      (entry) => notify(
        _BackgroundInferencePluginNotification.responseValueTypeUpdated,
        entry,
      ),
    );
  }

  @override
  Future<void> detach() => Future.wait<void>([
        _requestValueTypeSubscription.cancel(),
        _responseValueTypeSubscription.cancel(),
      ]);

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
      case _BackgroundInferencePluginAction.getRequestApiMethods:
        return SplayTreeSet.of(plugin.requestValueTypes.keys);
      case _BackgroundInferencePluginAction.getResponseApiMethods:
        return SplayTreeSet.of(plugin.responseValueTypes.keys);
      case _BackgroundInferencePluginAction.getAllApiMethods:
        return SplayTreeSet.of(plugin.requestValueTypes.keys)
          ..addAll(plugin.responseValueTypes.keys);
      case _BackgroundInferencePluginAction.getRequestValueTypes:
        return plugin.requestValueTypes;
      case _BackgroundInferencePluginAction.getResponseValueTypes:
        return plugin.responseValueTypes;
      case _BackgroundInferencePluginAction.zipInferences:
        return plugin.zipInferences().precompute();
    }
  }

  BackgroundInferencePluginHost(super.payload);
}
