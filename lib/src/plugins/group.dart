import 'dart:async';

import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitm] plugin that combines multiple plugins into one.
///
/// This won't be very useful in most circumstances, but there are times when
/// it's beneficial to reduce several plugins into one single request/response
/// replacement. In fact, the [PandoraMitm] object uses this plugin internally
/// to support multiple plugins!
class PluginGroup extends PandoraMitmPlugin {
  final List<PandoraMitmPlugin> plugins = [];

  PluginGroup([Iterable<PandoraMitmPlugin>? plugins]) {
    if (plugins != null) this.plugins.addAll(plugins);
  }

  @override
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      _getMessageSetSettings(
        (plugin) => plugin.getRequestSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      _getMessageSetSettings(
        (plugin) => plugin.getResponseSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @override
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _handleMessage(
        apiRequest,
        response,
        (plugin, apiRequest, response) =>
            plugin.handleRequest(flowId, apiRequest, response),
      );

  @override
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _handleMessage(
        apiRequest,
        response,
        (plugin, apiRequest, response) =>
            plugin.handleResponse(flowId, apiRequest, response),
      );

  Future<MessageSetSettings> _getMessageSetSettings(
    FutureOr<MessageSetSettings> Function(PandoraMitmPlugin plugin)
        getPluginSettings,
  ) async {
    var includeRequest = false;
    var includeResponse = false;

    for (final plugin in plugins) {
      final pluginSettings = await getPluginSettings(plugin);
      includeRequest |= pluginSettings.includeRequest;
      includeResponse |= pluginSettings.includeResponse;
    }

    return MessageSetSettings(
      includeRequest: includeRequest,
      includeResponse: includeResponse,
    );
  }

  Future<PandoraMessageSet> _handleMessage(
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
    FutureOr<PandoraMessageSet> Function(
      PandoraMitmPlugin plugin,
      PandoraApiRequest? apiRequest,
      PandoraResponse? response,
    )
        pluginHandleMessage,
  ) async {
    var modifiedApiRequest = originalApiRequest;
    var modifiedResponse = originalResponse;

    for (final plugin in plugins) {
      final modifiedMessageSet = await pluginHandleMessage(
        plugin,
        modifiedApiRequest,
        modifiedResponse,
      );
      modifiedApiRequest = modifiedMessageSet.apiRequest ?? modifiedApiRequest;
      modifiedResponse = modifiedMessageSet.response ?? modifiedResponse;
    }

    return PandoraMessageSet(
      apiRequest: modifiedApiRequest,
      response: modifiedResponse,
    );
  }
}
