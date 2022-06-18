import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [LogPlugin] plugin.
class LiteLogPluginEntry extends PluginEntry {
  const LiteLogPluginEntry();

  @override
  String get name => 'lite_log';

  @override
  String get description =>
      'Logs all API request and response methods to the console.';

  @override
  bool get largePotentialImpact => false;

  @override
  pmplg.LogPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmplg.LogPlugin(_writeLogMessage);

  void _writeLogMessage(
    String flowId,
    String method, {
    required bool response,
    StringBuffer? customBuffer,
  }) =>
      writeLogMessage(
        customBuffer: customBuffer,
        flowId: flowId,
        source: 'API',
        status: response ? 'RCV' : 'SND',
        method: method,
      );
}
