import 'dart:async';
import 'dart:collection';

import 'package:iapetus/iapetus_data.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/api_method_inference.dart';

/// A [PandoraMitm] plugin that infers API request and response definitions over
/// time.
class InferencePlugin extends PandoraMitmPlugin
    implements BoilerplateStripperPlugin {
  /// A whitelist of API methods to infer.
  final Set<String>? apiMethodWhitelist;

  final Map<String, ValueType> _requestValueTypes = {};
  final Map<String, ValueType> _responseValueTypes = {};

  final _requestValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();
  final _responseValueTypeStreamController =
      StreamController<MapEntry<String, ValueType>>.broadcast();

  @override
  bool stripBoilerplate;

  Map<String, ValueType> get requestValueTypes =>
      UnmodifiableMapView(_requestValueTypes);

  Map<String, ValueType> get responseValueTypes =>
      UnmodifiableMapView(_responseValueTypes);

  InferencePlugin({
    this.apiMethodWhitelist,
    this.stripBoilerplate = false,
  });

  /// Flattens inferred object types and groups messages by API methods.
  ///
  /// Returns a sorted map of API methods to their corresponding
  /// [ApiMethodInference]s
  ///
  /// The entry [Iterables] in the [ApiMethodInference] keys are lazily
  /// computed; the JSON is recursively parsed as iteration is performed.
  /// This is a relatively cheap function call as a result.
  Map<String, ApiMethodInference> zipInferences() {
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
        key: ApiMethodInference(
          key,
          requestValueTypeEntries[key],
          responseValueTypeEntries[key],
        ),
    };
  }

  @override
  MessageSetSettings getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      MessageSetSettings.skip;

  @override
  MessageSetSettings getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      apiMethodWhitelist?.contains(apiMethod) ?? true
          ? MessageSetSettings.includeAll
          : MessageSetSettings.skip;

  @override
  PandoraMessageSet handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) {
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
