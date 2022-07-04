import 'dart:async';
import 'dart:collection';

import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';

typedef InferencePluginFactory<T extends InferencePlugin> = T Function({
  Set<String>? apiMethodWhitelist,
  bool stripBoilerplate,
});

/// A [PandoraMitm] plugin that infers API request and response definitions over
/// time.
///
/// See also:
///
/// * [ForegroundInferencePlugin], an implementation that runs in the main
///   isolate with synchronously accessible functions and properties
/// * [BackgroundInferencePlugin], an implementation that runs in a background
///   isolate
abstract class InferencePlugin
    implements PandoraMitmPlugin, BoilerplateStripperPlugin {
  /// A whitelist of API methods to infer.
  ///
  /// This set may not be mutated; it must be replaced.
  abstract Set<String>? apiMethodWhitelist;

  /// Like setting the [apiMethodWhitelist], but completes when the operation
  /// completes.
  Future<void> applyApiMethodWhitelist(Set<String>? apiMethodWhitelist);

  /// Like setting the [stripBoilerplate] value, but completes when the
  /// operation completes.
  // ignore: avoid_positional_boolean_parameters
  Future<void> applyStripBoilerplate(bool stripBoilerplate);

  FutureOr<Set<String>> get inferredApiMethods;

  /// A stream of new inferred API methods.
  ///
  /// Emits `null` events if any methods are cleared.
  Stream<String?> get inferredApiMethodStream;

  FutureOr<Map<String, ApiMethodInference>> get inferences;

  /// Clears existing inferences.
  FutureOr<void> clear();

  FutureOr<ApiMethodInference?> getInference(String apiMethod);
}

class ForegroundInferencePlugin extends PandoraMitmPlugin
    implements InferencePlugin {
  final _inferences = <String, LazyApiMethodInference>{};
  final _inferredApiMethodStreamController =
      StreamController<String?>.broadcast();

  @override
  String get name => 'foreground_inference';

  @override
  Set<String>? apiMethodWhitelist;

  @override
  Future<void> applyApiMethodWhitelist(Set<String>? apiMethodWhitelist) async =>
      this.apiMethodWhitelist = apiMethodWhitelist;

  @override
  bool stripBoilerplate;

  @override
  Future<void> applyStripBoilerplate(bool stripBoilerplate) async =>
      this.stripBoilerplate = stripBoilerplate;

  @override
  Set<String> get inferredApiMethods =>
      UnmodifiableSetView(SplayTreeSet.of(_inferences.keys));

  @override
  Stream<String?> get inferredApiMethodStream =>
      _inferredApiMethodStreamController.stream;

  @override
  Map<String, LazyApiMethodInference> get inferences =>
      UnmodifiableMapView(_inferences);

  ForegroundInferencePlugin({
    this.apiMethodWhitelist,
    this.stripBoilerplate = false,
  });

  @override
  void clear() {
    _inferences.clear();
    _inferredApiMethodStreamController.add(null);
  }

  @override
  ApiMethodInference? getInference(String apiMethod) => _inferences[apiMethod];

  @override
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) async =>
      MessageSetSettings.skip;

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) async =>
      apiMethodWhitelist?.contains(apiMethod) ?? true
          ? MessageSetSettings.includeAll
          : MessageSetSettings.skip;

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async {
    if (apiRequest == null ||
        response == null ||
        !(apiMethodWhitelist?.contains(apiRequest.method) ?? true)) {
      return PandoraMessageSet.preserve;
    }

    final existingInference = _inferences[apiRequest.method];
    _inferences[apiRequest.method] = LazyApiMethodInference(
      method: apiRequest.method,
      requestValueType: (existingInference?.requestValueType ??
              const UnknownValueType(optional: true)) +
          (stripBoilerplate ? apiRequest.withoutBoilerplate() : apiRequest)
              .body,
      responseValueType: (existingInference?.responseValueType ??
              const UnknownValueType(optional: true)) +
          response.apiResponse.when(
            ok: (result) => result,
            fail: (code, message) => const UnknownValueType(optional: true),
          ),
    );

    _inferredApiMethodStreamController.add(apiRequest.method);

    return PandoraMessageSet.preserve;
  }
}

extension ApiReferenceMapExtensions on Map<String, LazyApiMethodInference> {
  Map<String, PrecomputedApiMethodInference> precompute() =>
      {for (final entry in entries) entry.key: entry.value.precompute()};
}
