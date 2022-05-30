import 'dart:async';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/record.dart';

/// A [PandoraMitm] plugin that streams API requests and responses.
///
/// This plugin has a large potential performance impact. To mitigate this,
/// consider using the [apiMethodWhitelist] or [LogPlugin].
class StreamPlugin extends PandoraMitmPlugin {
  /// A whitelist of API methods to stream.
  Set<String>? apiMethodWhitelist;

  final _streamController = StreamController<PandoraMitmRecord>.broadcast();
  final Map<String, WeakReference<Completer<PandoraResponse>>>
      _responseCompleters = {};

  StreamPlugin([this.apiMethodWhitelist]);

  /// The stream of API requests and responses.
  Stream<PandoraMitmRecord> get stream => _streamController.stream;

  @override
  MessageSetSettings getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      apiMethodWhitelist?.contains(apiMethod) ?? true
          ? MessageSetSettings.includeRequestOnly
          : MessageSetSettings.skip;

  @override
  MessageSetSettings getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      apiMethodWhitelist?.contains(apiMethod) ?? true
          ? MessageSetSettings.includeResponseOnly
          : MessageSetSettings.skip;

  @override
  Future<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async {
    if (apiRequest == null ||
        !(apiMethodWhitelist?.contains(apiRequest.method) ?? true)) {
      return PandoraMessageSet.preserve;
    }

    final responseCompleter = Completer<PandoraResponse>();
    _responseCompleters[flowId] = WeakReference(responseCompleter);
    _streamController.add(
      PandoraMitmRecord(
        flowId,
        apiRequest,
        responseCompleter.future,
      ),
    );
    return PandoraMessageSet.preserve;
  }

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async {
    _responseCompleters.remove(flowId)?.target?.complete(response);
    return PandoraMessageSet.preserve;
  }
}
