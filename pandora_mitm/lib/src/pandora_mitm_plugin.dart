import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitm] plugin.
///
/// Plugins can analyze and modify Pandora JSON API requests and responses.
///
/// Plugins integrate with an API flow at four points:
/// 1. [getRequestSetSettings] is called, to determine which messages must be
///    sent to the plugin at the request stage
/// 2. [handleRequest] is called, allowing the plugin to modify API requests
///    before being sent, and/or to spoof responses without sending API requests
/// 3. [getResponseSetSettings] is called, to determine which messages must be
///    sent to the plugin at the response stage
/// 4. [handleResponse] is called, allowing the plugin to modify API requests
///    before being displayed in the mitmproxy UI, and/or to spoof responses
///    before being sent to the Pandora client.
///
/// See also:
///
/// * [ResponseModificationBasePlugin], which provides a simplified response
///   modification API
/// * [BackgroundBasePlugin], which provides a mechanism to wrap a plugin to
///   run in a background isolate.
abstract class PandoraMitmPlugin {
  const PandoraMitmPlugin();

  /// Called just before the plugin is added to the [PandoraMitm] instance.
  @mustCallSuper
  Future<void> attach() async {}

  /// Called just after the plugin is removed from the [PandoraMitm] instance.
  @mustCallSuper
  Future<void> detach() async {}

  /// Called when a request is about to be sent.
  ///
  /// Returns a [MessageSetSettings] describing which messages must be sent to
  /// the plugin in the request stage.
  ///
  /// The settings returned here affect all plugins in the plugin list. If a
  /// single plugin requests that a message be sent to it, that message will
  /// be sent to all the other plugins in the list as well.
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) async =>
      MessageSetSettings.skip;

  /// Called when a response is about to be sent.
  ///
  /// Returns a [PandoraMessageSet] describing which messages must be sent to
  /// the plugin in the response stage.
  ///
  /// The settings returned here affect all plugins in the plugin list. If a
  /// single plugin requests that a message be sent to it, that message will
  /// be sent to all the other plugins in the list as well.
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) async =>
      MessageSetSettings.skip;

  /// Called when a request is received, before it is sent to the Pandora
  /// server.
  ///
  /// Note that the [apiRequest] and [response] may be `null` if a plugin
  /// did not specify that they should be sent in [getRequestSetSettings].
  /// In this scenario, however, they are not guaranteed to be `null` - if
  /// another plugin has requested that a message be sent to it, the message
  /// will be provided to all plugins in the plugin list.
  ///
  /// Returns a [PandoraMessageSet] containing replacement messages to use.
  /// If a request or response is not provided in the [PandoraMessageSet],
  /// it will not be modified.
  ///
  /// If the returned [PandoraMessageSet] contains a response, the response will
  /// be sent to the Pandora client without sending the API request to the
  /// server.
  Future<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async =>
      PandoraMessageSet.preserve;

  /// Called when a response is received, before it is sent to the Pandora
  /// client.
  ///
  /// Note that the [apiRequest] and [response] may be `null` if a plugin
  /// did not specify that they should be sent in [getResponseSetSettings].
  /// In this scenario, however, they are not guaranteed to be `null` - if
  /// another plugin has requested that a message be sent to it, the message
  /// will be provided to all plugins in the plugin list.
  ///
  /// Returns a [PandoraMessageSet] containing replacement messages to use.
  /// If a request or response is not provided in the [PandoraMessageSet],
  /// it will not be modified.
  ///
  /// If the returned [PandoraMessageSet] contains a request, the modified
  /// request will display in the mitmproxy UI.
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async =>
      PandoraMessageSet.preserve;
}

mixin PandoraMitmPluginLoggingMixin on PandoraMitmPlugin {
  @protected
  String get logTag;

  @protected
  late final Logger log = Logger('pandora_mitm.plugin.$logTag');
}

mixin PandoraMitmPluginStateTrackerMixin on PandoraMitmPlugin {
  var _attached = false;

  /// Whether the plugin is currently attached or not.
  ///
  /// This value is updated before the base [attach] implementation starts,
  /// and after the base [detach] implementation finishes.
  @protected
  bool get attached => _attached;

  @override
  @mustCallSuper
  Future<void> attach() async {
    _attached = true;
    await super.attach();
  }

  @override
  @mustCallSuper
  Future<void> detach() async {
    await super.detach();
    _attached = false;
  }
}

extension PandoraMitmPluginCollectionExtension on Iterable<PandoraMitmPlugin> {
  @internal
  Future<void> attach() => Future.wait(map((plugin) => plugin.attach()));

  @internal
  Future<void> detach() => Future.wait(map((plugin) => plugin.detach()));
}
