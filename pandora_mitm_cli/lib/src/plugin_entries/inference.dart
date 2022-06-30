import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_cli/src/plugin_entry.dart';
import 'package:pandora_mitm_extra/plugins.dart' as pmeplg;

/// A [PluginEntry] for the [InferenceServerPlugin] plugin.
class InferencePluginEntry extends PluginEntry {
  static const _serveFlag = 'serve-inferences';
  static const _portOption = 'inference-port';
  static const _noStripBoilerplateFlag = 'inference-no-strip-boilerplate';

  const InferencePluginEntry();

  @override
  String get name => 'inference';

  @override
  String get description =>
      'Infers API request and response definitions over time.';

  @override
  bool get largePotentialImpact => true;

  @override
  Iterable<PluginFlag> get flags => const [
        PluginFlag(
          name: _serveFlag,
          description: 'Serves inferences over HTTP.',
        ),
        PluginFlag(
          name: _noStripBoilerplateFlag,
          description:
              'Disables boilerplate JSON field stripping from API requests.',
        ),
      ];

  @override
  Iterable<PluginOption<Object?>> get options => const [
        PluginOption<int>(
          name: _portOption,
          description: 'The port to use for the inference HTTP server.',
          defaultValue: 46337,
        ),
      ];

  @override
  PandoraMitmPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmeplg.InferenceServerPlugin(
        serve: flags[_serveFlag]!,
        port: options[_portOption]! as int,
        stripBoilerplate: !flags[_noStripBoilerplateFlag]!,
      );
}
