import 'dart:async';
import 'dart:collection';

import 'package:notifying_list/notifying_list.dart';
import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/plugin_manager.dart';

/// A [PandoraMitm] plugin that combines multiple plugins into one.
///
/// This plugin is also a complete [PluginManager] implementation.
///
/// The logic used to combine [MessageSetSettings]s and [PandoraMessageSet]s
/// into single objects is exposed through the static
/// [combineMessageSetSettings] and [combineMessageSets] functions.
/// These can be used for other combinational purposes, such as hosting a plugin
/// inside another.
class PluginGroup extends PandoraMitmPlugin
    with PandoraMitmPluginStateTrackerMixin
    implements PluginManager {
  final _plugins = StreamNotifyingList<PandoraMitmPlugin>();

  @override
  List<PandoraMitmPlugin> get plugins => UnmodifiableListView(_plugins);

  @override
  Stream<List<PandoraMitmPlugin>> get pluginListChanges => _plugins.stream;

  @override
  Future<void> attach() async {
    await super.attach();
    return _plugins.attach();
  }

  @override
  Future<void> detach() async {
    await _plugins.detach();
    await super.detach();
  }

  @override
  Future<void> addPlugin(PandoraMitmPlugin plugin) async {
    if (attached) await plugin.attach();
    _plugins.add(plugin);
  }

  @override
  Future<void> addPlugins(List<PandoraMitmPlugin> plugins) async {
    if (attached) await plugins.attach();
    _plugins.addAll(plugins);
  }

  @override
  Future<void> insertPlugin(int index, PandoraMitmPlugin plugin) async {
    if (attached) await plugin.attach();
    _plugins.insert(index, plugin);
  }

  @override
  Future<void> insertPlugins(int index, List<PandoraMitmPlugin> plugins) async {
    if (attached) await plugins.attach();
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
    if (attached) await removedPlugins.detach();
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
    if (attached) await removedPlugins.detach();
  }

  @override
  Future<PandoraMitmPlugin> removePluginAt(int index) async {
    final plugin = _plugins.removeAt(index);
    if (attached) await plugin.detach();
    return plugin;
  }

  @override
  Future<void> removeAllPlugins() async {
    final removedPlugins = List.of(_plugins);
    _plugins.clear();
    if (attached) await removedPlugins.detach();
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
  Future<PandoraMessageSet> handleRequest(
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
  Future<PandoraMessageSet> handleResponse(
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
  ) =>
      combineMessageSetSettings(plugins.map(getPluginSettings));

  Future<PandoraMessageSet> _handleMessage(
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
    FutureOr<PandoraMessageSet> Function(
      PandoraMitmPlugin plugin,
      PandoraApiRequest? apiRequest,
      PandoraResponse? response,
    )
        pluginHandleMessage,
  ) =>
      combineMessageSets(
        originalApiRequest,
        originalResponse,
        plugins.map(
          (plugin) => (apiRequest, response) =>
              pluginHandleMessage(plugin, apiRequest, response),
        ),
      );

  /// Combines several [MessageSetSettings] into one.
  ///
  /// If a request or response is requested in any one of the sets, then it will
  /// be requested in the returned settings.
  static Future<MessageSetSettings> combineMessageSetSettings(
    Iterable<FutureOr<MessageSetSettings>> settingsFutures,
  ) async {
    var includeRequest = false;
    var includeResponse = false;

    for (final settingsFuture in settingsFutures) {
      final settings = await settingsFuture;
      includeRequest |= settings.includeRequest;
      includeResponse |= settings.includeResponse;
    }

    return MessageSetSettings(
      includeRequest: includeRequest,
      includeResponse: includeResponse,
    );
  }

  /// Combines several [PandoraMessageSet]s into one, generating each message
  /// set one at a time using the previous result.
  static Future<PandoraMessageSet> combineMessageSets(
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
    Iterable<
            FutureOr<PandoraMessageSet> Function(
      PandoraApiRequest? apiRequest,
      PandoraResponse? response,
    )>
        messageSetGenerators,
  ) async {
    var modifiedApiRequest = originalApiRequest;
    var modifiedResponse = originalResponse;

    for (final messageSetGenerator in messageSetGenerators) {
      final modifiedMessageSet = await messageSetGenerator(
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
