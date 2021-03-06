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
class MitmproxyUiHelperPlugin extends PandoraMitmPlugin
    implements PassiveCapablePlugin, BoilerplateStripperPlugin {
  @override
  bool passive;

  @override
  bool stripBoilerplate;

  MitmproxyUiHelperPlugin({
    this.passive = false,
    this.stripBoilerplate = false,
  });

  @override
  String get name => 'mitmproxy_ui_helper';

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) async =>
      passive ? MessageSetSettings.skip : MessageSetSettings.includeAll;

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async =>
      PandoraMessageSet(
        apiRequest: stripBoilerplate
            ? apiRequest?.withoutBoilerplate(decrypt: true)
            : apiRequest?.copyWith(encrypted: false),
        response: response?.copyWith(
          headers: {
            ...response.headers,
            'content-type': const ['application/json'],
          },
        ),
      );
}
