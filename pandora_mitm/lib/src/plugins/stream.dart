import 'dart:async';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/record.dart';

/// A [PandoraMitm] plugin that streams API requests and responses.
///
/// This plugin has a large potential performance impact. To mitigate this,
/// consider using the [apiMethodWhitelist] or [LogPlugin].
class StreamPlugin extends PandoraMitmPlugin
    implements BoilerplateStripperPlugin {
  /// A whitelist of API methods to stream.
  final Set<String>? apiMethodWhitelist;

  @override
  bool stripBoilerplate;

  final _streamController = StreamController<PandoraMitmRecord>.broadcast();
  final Map<String, Completer<PandoraResponse>> _responseCompleters = {};

  StreamPlugin({
    this.apiMethodWhitelist,
    this.stripBoilerplate = false,
  });

  @override
  String get name => 'stream';

  /// The stream of API requests and responses.
  Stream<PandoraMitmRecord> get recordStream => _streamController.stream;

  @override
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) async =>
      apiMethodWhitelist?.contains(apiMethod) ?? true
          ? MessageSetSettings.includeRequestOnly
          : MessageSetSettings.skip;

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) async =>
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
    _responseCompleters[flowId] = responseCompleter;
    _streamController.add(
      PandoraMitmRecord(
        flowId,
        stripBoilerplate ? apiRequest.withoutBoilerplate() : apiRequest,
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
    _responseCompleters.remove(flowId)?.complete(response);
    return PandoraMessageSet.preserve;
  }
}
