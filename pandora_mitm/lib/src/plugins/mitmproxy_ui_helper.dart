import 'dart:io';

import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitm] plugin to improve the mitmproxy UI experience.
///
/// It can:
/// - Decrypt encrypted API requests and responses
/// - Strip boilerplate JSON fields from API requests ([stripBoilerplate])
/// - Correct the Content-Type header to JSON in HTTP responses
///
/// This plugin destructively modifies HTTP requests and responses, and should
/// always be placed last in the plugin list.
class MitmproxyUiHelperPlugin extends PandoraMitmPlugin {
  /// If true, this plugin will only modify requests and responses that have
  /// been used by other plugins.
  ///
  /// This will vastly reduce the amount of data being streamed and processed.
  bool passive;

  /// If true, this plugin will strip boilerplate JSON fields from API requests.
  ///
  /// See the [handleResponse] implementation for more information about what is
  /// removed.
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
        apiRequest: apiRequest?.copyWith(
          encrypted: false,
          body: stripBoilerplate
              ? Map.fromEntries(
                  apiRequest.body.entries.where(
                    (entry) => !const {
                      'deviceId',
                      'deviceProperties',
                      'syncTime',
                      'userAuthToken',
                    }.contains(entry.key),
                  ),
                )
              : apiRequest.body,
        ),
        response: response?.copyWith(
          headers: {
            ...response.headers,
            HttpHeaders.contentTypeHeader: [ContentType.json.value],
          },
        ),
      );
}
