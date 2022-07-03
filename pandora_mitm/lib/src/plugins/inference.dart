import 'dart:async';
import 'dart:collection';

import 'package:iapetus/iapetus_data.dart';
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
  Set<String>? get apiMethodWhitelist;

  /// Like setting the [apiMethodWhitelist], but completes when the operation
  /// completes.
  Future<void> applyApiMethodWhitelist(Set<String>? apiMethodWhitelist);

  /// Like setting the [stripBoilerplate] value, but completes when the
  /// operation completes.
  // ignore: avoid_positional_boolean_parameters
  Future<void> applyStripBoilerplate(bool stripBoilerplate);

  FutureOr<Map<String, ValueType>> get requestValueTypes;

  FutureOr<Map<String, ValueType>> get responseValueTypes;

  Stream<MapEntry<String, ValueType>> get requestValueTypeStream;

  Stream<MapEntry<String, ValueType>> get responseValueTypeStream;

  /// Clears existing inferences.
  FutureOr<void> clear();

  /// Flattens inferred object types and groups messages by API methods.
  ///
  /// Returns a sorted map of API methods to their corresponding
  /// [ApiMethodInference]s
  ///
  /// Some implementations may choose to use [LazyApiMethodInference]s, where
  /// the entry [Iterables] in the [ApiMethodInference] keys are lazily
  /// computed such that the JSON is recursively processed as iteration is
  /// performed. This is a relatively cheap function call as a result.
  FutureOr<Map<String, ApiMethodInference>> zipInferences();
}

class ForegroundInferencePlugin extends PandoraMitmPlugin
    implements InferencePlugin {
  final Map<String, ValueType> _requestValueTypes = {};
  final Map<String, ValueType> _responseValueTypes = {};

  final _requestValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();
  final _responseValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();

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
  Map<String, ValueType> get requestValueTypes =>
      UnmodifiableMapView(_requestValueTypes);

  @override
  Map<String, ValueType> get responseValueTypes =>
      UnmodifiableMapView(_responseValueTypes);

  @override
  Stream<MapEntry<String, ValueType>> get requestValueTypeStream =>
      _requestValueTypeStreamController.stream;

  @override
  Stream<MapEntry<String, ValueType>> get responseValueTypeStream =>
      _responseValueTypeStreamController.stream;

  ForegroundInferencePlugin({
    this.apiMethodWhitelist,
    this.stripBoilerplate = false,
  });

  @override
  FutureOr<void> clear() {
    _requestValueTypes.clear();
    _responseValueTypes.clear();
  }

  @override
  Map<String, LazyApiMethodInference> zipInferences() {
    Map<String, Iterable<NestedObjectValueTypeEntry>> flattenValueTypes(
      Map<String, ValueType> valueTypes,
    ) =>
        valueTypes
            .map((key, value) => MapEntry(key, value.flattenObjectTypes(key)));

    final requestValueTypeEntries = flattenValueTypes(_requestValueTypes);
    final responseValueTypeEntries = flattenValueTypes(_responseValueTypes);

    return {
      for (final key in SplayTreeSet<String>()
        ..addAll(requestValueTypeEntries.keys)
        ..addAll(responseValueTypeEntries.keys))
        key: LazyApiMethodInference(
          key,
          requestValueTypeEntries[key],
          responseValueTypeEntries[key],
        ),
    };
  }

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

    _addSample(
      _requestValueTypes,
      _requestValueTypeStreamController,
      apiRequest.method,
      stripBoilerplate ? apiRequest.withoutBoilerplate().body : apiRequest.body,
    );

    final apiResponse = response.apiResponse;
    if (apiResponse is SuccessfulPandoraApiResponse) {
      _addSample(
        _responseValueTypes,
        _responseValueTypeStreamController,
        apiRequest.method,
        apiResponse.result,
      );
    }

    return PandoraMessageSet.preserve;
  }

  static void _addSample(
    Map<String, ValueType> valueTypes,
    Sink<MapEntry<String, ValueType>> streamSink,
    String method,
    dynamic sample,
  ) {
    final valueType = generalizeValueTypes([
      if (valueTypes.containsKey(method)) valueTypes[method]!,
      estimateJsonFieldValueType(null, sample),
    ]);
    valueTypes[method] = valueType;
    streamSink.add(MapEntry(method, valueType));
  }
}

extension ZippedApiReferenceExtensions on Map<String, LazyApiMethodInference> {
  Map<String, PrecomputedApiMethodInference> precompute() =>
      {for (final entry in entries) entry.key: entry.value.precompute()};
}
