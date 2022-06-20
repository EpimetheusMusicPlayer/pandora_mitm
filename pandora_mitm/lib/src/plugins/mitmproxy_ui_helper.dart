import 'dart:io';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/plugins/interfaces/boilerplate_stripper.dart';
import 'package:pandora_mitm/src/plugins/interfaces/passive_capable.dart';

/// A [PandoraMitm] plugin to improve the mitmproxy UI experience.
///
/// It can:
/// - Decrypt encrypted API requests and responses
/// - Strip boilerplate JSON fields from API requests ([stripBoilerplate])
/// - Correct the Content-Type header to JSON in HTTP responses
///
/// This plugin destructively modifies HTTP requests and responses, and should
/// always be placed last in the plugin list.
class MitmproxyUiHelperPlugin extends PandoraMitmPlugin
    implements PassiveCapablePlugin, BoilerplateStripperPlugin {
  /// If true, this plugin will only modify requests and responses that have
  /// been used by other plugins.
  ///
  /// This will vastly reduce the amount of data being streamed and processed.
  @override
  bool passive;

  /// If true, this plugin will strip boilerplate JSON fields from API requests.
  ///
  /// See the [handleResponse] implementation for more information about what is
  /// removed.
  @override
  bool stripBoilerplate;

  MitmproxyUiHelperPlugin({
    this.passive = false,
    this.stripBoilerplate = false,
  });

  @override
  MessageSetSettings getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      passive ? MessageSetSettings.skip : MessageSetSettings.includeAll;

  @override
  PandoraMessageSet handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      PandoraMessageSet(
        apiRequest: stripBoilerplate
            ? apiRequest?.withoutBoilerplate(decrypt: true)
            : apiRequest?.copyWith(encrypted: false),
        response: response?.copyWith(
          headers: {
            ...response.headers,
            HttpHeaders.contentTypeHeader: [ContentType.json.value],
          },
        ),
      );
}
