import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class FeatureUnlockPluginUi extends PluginUi<pmplg.FeatureUnlockPlugin> {
  const FeatureUnlockPluginUi();

  @override
  String get displayName => 'Feature unlock';

  @override
  String get description => 'Unlocks as many features as possible.';

  @override
  IconData? get iconData => Icons.lock_open;

  @override
  pmplg.FeatureUnlockPlugin buildPlugin() => pmplg.FeatureUnlockPlugin();
}
