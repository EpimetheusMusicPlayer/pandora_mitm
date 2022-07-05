import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_add_panel/plugin_add_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_add_panel/plugin_template_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class PluginAddPanel extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;
  final Map<String, List<PluginUi>> availablePluginTemplates;

  const PluginAddPanel({
    Key? key,
    required this.pluginManager,
    required this.availablePluginUis,
    required this.availablePluginTemplates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PluginTemplateButton(
          pluginManager: pluginManager,
          availablePluginTemplates: availablePluginTemplates,
        ),
        PluginAddButton(
          pluginManager: pluginManager,
          availablePluginUis: availablePluginUis,
        ),
      ],
    );
  }
}
