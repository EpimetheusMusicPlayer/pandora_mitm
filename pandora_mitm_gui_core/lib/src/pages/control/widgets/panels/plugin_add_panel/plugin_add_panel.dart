import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_add_panel/plugin_add_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class PluginAddPanel extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;

  const PluginAddPanel({
    Key? key,
    required this.pluginManager,
    required this.availablePluginUis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PluginAddButton(
      pluginManager: pluginManager,
      availablePluginUis: availablePluginUis,
    );
  }
}
