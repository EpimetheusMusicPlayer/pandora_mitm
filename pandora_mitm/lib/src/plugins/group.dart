import 'dart:async';
import 'dart:collection';

import 'package:notifying_list/notifying_list.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/plugin_manager.dart';

/// A [PandoraMitm] plugin that combines multiple plugins into one.
///
/// This plugin is also a complete [PluginManager] implementation.
///
/// This won't be very useful in most circumstances, but there are times when
/// it's beneficial to reduce several plugins into one single request/response
/// replacement. In fact, the [PandoraMitm] object uses this plugin internally
/// to support multiple plugins!
class PluginGroup extends PandoraMitmPlugin implements PluginManager {
  final StreamNotifyingList<PandoraMitmPlugin> _plugins;

  PluginGroup([Iterable<PandoraMitmPlugin>? plugins])
      : _plugins = plugins == null
            ? StreamNotifyingList()
            : StreamNotifyingList.of(plugins);

  @override
  List<PandoraMitmPlugin> get plugins => UnmodifiableListView(_plugins);

  @override
  Stream<List<PandoraMitmPlugin>> get pluginListChanges => _plugins.stream;

  @override
  void addPlugin(PandoraMitmPlugin plugin) => _plugins.add(plugin);

  @override
  void addPlugins(Iterable<PandoraMitmPlugin> plugins) =>
      _plugins.addAll(plugins);

  @override
  void insertPlugin(int index, PandoraMitmPlugin plugin) =>
      _plugins.insert(index, plugin);

  @override
  void insertPlugins(int index, Iterable<PandoraMitmPlugin> plugins) =>
      _plugins.insertAll(index, plugins);

  @override
  void removePlugin(PandoraMitmPlugin pluginToRemove) =>
      _plugins.removeWhere((plugin) => plugin == pluginToRemove);

  @override
  void removePlugins(Set<PandoraMitmPlugin> pluginsToRemove) =>
      _plugins.removeWhere(pluginsToRemove.contains);

  @override
  void removePluginRange(int start, int end) =>
      _plugins.removeRange(start, end);

  @override
  PandoraMitmPlugin removePluginAt(int index) => _plugins.removeAt(index);

  @override
  void removeAllPlugins() => _plugins.clear();

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

    for (final plugin in _plugins) {
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

    for (final plugin in _plugins) {
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
