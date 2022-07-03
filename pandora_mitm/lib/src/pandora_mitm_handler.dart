import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mitmproxy_ri_client/mitmproxy_ri_client.dart' as mitm_ri;
import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_message_set.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';
import 'package:pandora_mitm/src/pandora_mitm_backend.dart';
import 'package:pandora_mitm/src/plugin_manager.dart';
import 'package:pandora_mitm/src/plugins/group.dart';

/// A [PandoraMitmHandler] requests and performs operations on Pandora API
/// messages.
///
/// See also:
///
/// * [PandoraMitmPluginGroupMixin], a [PandoraMitmHandler] implementation that
///   allows [PandoraMitmPlugin]s to be used.
/// * [PandoraMitmBackgroundIsolate], a [PandoraMitmHandler] implementation that
///   sends messages through a [SendPort] to a special [PandoraMitmBackend]
///   implementation.
abstract class PandoraMitmHandler {
  const PandoraMitmHandler._();

  @protected
  FutureOr<mitm_ri.MessageSetSettings> getRequestMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  );

  @protected
  FutureOr<mitm_ri.MessageSetSettings> getResponseMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  );

  @protected
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  );

  @protected
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  );
}

/// A [PandoraMitmHandler] implementation mixin provides a [PluginCapable]
/// implementation via an internal [PluginGroup] plugin.
///
/// This mixin depends on the [PandoraMitmBackend], and must be placed after it
/// in the mixin list.
mixin PandoraMitmPluginGroupMixin on PandoraMitmBackend
    implements PandoraMitmHandler, PluginCapable {
  final _pluginGroup = PluginGroup('root');

  @override
  PluginManager get pluginManager => _pluginGroup;

  @override
  Future<void> connect({String host = 'localhost', int port = 8082}) async {
    await _pluginGroup.attach();
    await super.connect(host: host, port: port);
    done.then((_) => _pluginGroup.detach());
  }

  @protected
  @override
  FutureOr<mitm_ri.MessageSetSettings> getRequestMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  ) =>
      _pluginGroup.getRequestSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @protected
  @override
  FutureOr<mitm_ri.MessageSetSettings> getResponseMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  ) =>
      _pluginGroup.getResponseSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @protected
  @override
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _pluginGroup.handleRequest(
        flowId,
        originalApiRequest,
        originalResponse,
      );

  @protected
  @override
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _pluginGroup.handleResponse(
        flowId,
        originalApiRequest,
        originalResponse,
      );
}
