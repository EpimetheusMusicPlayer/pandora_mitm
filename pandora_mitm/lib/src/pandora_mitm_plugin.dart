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
/// Also see: [ResponseModificationBasePlugin]
abstract class PandoraMitmPlugin {
  const PandoraMitmPlugin();

  /// Called when a request is about to be sent.
  ///
  /// Returns a [MessageSetSettings] describing which messages must be sent to
  /// the plugin in the request stage.
  ///
  /// The settings returned here affect all plugins in the plugin list. If a
  /// single plugin requests that a message be sent to it, that message will
  /// be sent to all the other plugins in the list as well.
  FutureOr<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      MessageSetSettings.skip;

  /// Called when a response is about to be sent.
  ///
  /// Returns a [PandoraMessageSet] describing which messages must be sent to
  /// the plugin in the response stage.
  ///
  /// The settings returned here affect all plugins in the plugin list. If a
  /// single plugin requests that a message be sent to it, that message will
  /// be sent to all the other plugins in the list as well.
  FutureOr<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
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
  FutureOr<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
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
  FutureOr<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      PandoraMessageSet.preserve;
}

mixin PandoraMitmPluginLogging on PandoraMitmPlugin {
  @protected
  String get logTag;

  @protected
  late final Logger log = Logger('PandoraMitm.plugin.$logTag');
}