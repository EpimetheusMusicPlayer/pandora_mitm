import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [FeatureUnlockPlugin] plugin.
class FeatureUnlockPluginEntry extends PluginEntry {
  const FeatureUnlockPluginEntry();

  @override
  String get name => 'feature_unlock';

  @override
  String get description => 'Unlocks several features in the Pandora app.';

  @override
  bool get largePotentialImpact => false;

  @override
  pmplg.FeatureUnlockPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmplg.FeatureUnlockPlugin();
}
