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
  var _attached = false;
  final StreamNotifyingList<PandoraMitmPlugin> _plugins;
  final _plugins = StreamNotifyingList<PandoraMitmPlugin>();

  @override
  List<PandoraMitmPlugin> get plugins => UnmodifiableListView(_plugins);

  @override
  Stream<List<PandoraMitmPlugin>> get pluginListChanges => _plugins.stream;

  @override
  Future<void> attach() {
    _attached = true;
    return _plugins.attach();
  }

  @override
  Future<void> detach() {
    _attached = false;
    return _plugins.detach();
  }

  @override
  Future<void> addPlugin(PandoraMitmPlugin plugin) async {
    if (_attached) await plugin.attach();
    _plugins.add(plugin);
  }

  @override
  Future<void> addPlugins(List<PandoraMitmPlugin> plugins) async {
    if (_attached) await plugins.attach();
    _plugins.addAll(plugins);
  }

  @override
  Future<void> insertPlugin(int index, PandoraMitmPlugin plugin) async {
    if (_attached) await plugin.attach();
    _plugins.insert(index, plugin);
  }

  @override
  Future<void> insertPlugins(int index, List<PandoraMitmPlugin> plugins) async {
    if (attached) await plugins.attach();
    if (_attached) await plugins.attach();
    _plugins.insertAll(index, plugins);
  }

  @override
  void movePlugin(int oldIndex, int newIndex) => _plugins.insert(
        oldIndex < newIndex ? newIndex - 1 : newIndex,
        _plugins.removeAt(oldIndex),
      );

  Future<void> _removePluginsWhere(
    bool Function(PandoraMitmPlugin plugin) test,
  ) async {
    final removedPlugins = <PandoraMitmPlugin>[];
    _plugins.removeWhere((plugin) {
      if (test(plugin)) {
        removedPlugins.add(plugin);
        return true;
      } else {
        return false;
      }
    });
    if (_attached) await removedPlugins.detach();
  }

  @override
  Future<void> removePlugin(PandoraMitmPlugin pluginToRemove) =>
      _removePluginsWhere((plugin) => plugin == pluginToRemove);

  @override
  Future<void> removePlugins(Set<PandoraMitmPlugin> pluginsToRemove) =>
      _removePluginsWhere(pluginsToRemove.contains);

  @override
  Future<void> removePluginRange(int start, int end) async {
    final removedPlugins = _plugins.sublist(start, end);
    _plugins.removeRange(start, end);
    if (_attached) await removedPlugins.detach();
  }

  @override
  Future<PandoraMitmPlugin> removePluginAt(int index) async {
    final plugin = _plugins.removeAt(index);
    if (_attached) await plugin.detach();
    return plugin;
  }

  @override
  Future<void> removeAllPlugins() async {
    final removedPlugins = List.of(_plugins);
    _plugins.clear();
    if (_attached) await removedPlugins.detach();
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
