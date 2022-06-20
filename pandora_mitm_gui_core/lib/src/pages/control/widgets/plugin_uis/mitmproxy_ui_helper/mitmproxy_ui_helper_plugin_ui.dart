import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mixins/boilerplate_stripper_plugin_ui_mixin.dart';

class MitmproxyUiHelperPluginUi extends PluginUi<pmplg.MitmproxyUiHelperPlugin>
    with BoilerplateStripperPluginUiMixin {
  const MitmproxyUiHelperPluginUi();

  @override
  String get displayName => 'mitmproxy UI';

  @override
  String get description => 'Enhances the mitmproxy UI experience.';

  @override
  IconData? get iconData => Icons.web;

  @override
  pmplg.MitmproxyUiHelperPlugin buildPlugin() =>
      pmplg.MitmproxyUiHelperPlugin(stripBoilerplate: true);
}
