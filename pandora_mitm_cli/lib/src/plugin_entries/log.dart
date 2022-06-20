import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [StreamPlugin] plugin.
class LogPluginEntry extends PluginEntry {
  static const _apiMethodWhitelistOption = 'log-whitelist';

  const LogPluginEntry();

  @override
  String get name => 'log';

  @override
  String get description =>
      'Logs detailed API request and response messages to the console.';

  @override
  bool get largePotentialImpact => true;

  @override
  Iterable<PluginOption> get options => const [
        PluginOption<List<String>>(
          name: _apiMethodWhitelistOption,
          description: 'A list of specific API methods to log.',
        ),
      ];

  @override
  pmplg.StreamPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmplg.StreamPlugin(
        apiMethodWhitelist:
            (options[_apiMethodWhitelistOption] as List<String>?)?.toSet(),
      )..recordStream.forEach(_writeLogMessage);

  Future<void> _writeLogMessage(
    PandoraMitmRecord record, [
    StringBuffer? customBuffer,
  ]) async {
    writeLogMessage(
      customBuffer: customBuffer,
      flowId: record.flowId,
      source: 'API',
      status: 'SND',
      method: record.apiRequest.method,
      extra: record.apiRequest.encrypted ? 'encrypted' : null,
    );
    final response = await record.responseFuture;
    writeLogMessage(
      flowId: record.flowId,
      source: 'API',
      status: 'RCV',
      method: record.apiRequest.method,
      extra: response.encryptedBody ? 'encrypted' : null,
    );
  }
}
