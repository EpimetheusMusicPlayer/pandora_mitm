import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [MitmproxyUiHelperPlugin] plugin.
class UiHelperPluginEntry extends PluginEntry {
  static const _noStripBoilerplateFlag = 'no-strip-boilerplate';

  const UiHelperPluginEntry();

  @override
  String get name => 'ui_helper';

  @override
  String get description => 'Improves the experience in the mitmproxy UI.';

  @override
  bool get largePotentialImpact => true;

  @override
  Iterable<PluginFlag> get flags => const [
        PluginFlag(
          name: _noStripBoilerplateFlag,
          description:
              'Disables boilerplate JSON field stripping from API requests.',
        ),
      ];

  @override
  pmplg.MitmproxyUiHelperPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmplg.MitmproxyUiHelperPlugin(
        stripBoilerplate: !flags[_noStripBoilerplateFlag]!,
      );
}
