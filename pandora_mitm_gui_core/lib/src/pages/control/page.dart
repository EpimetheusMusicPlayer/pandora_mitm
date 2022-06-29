import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/control_app_bar/control_app_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_add_panel/plugin_add_panel.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_main_panel/plugin_main_panel.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_selection_panel/plugin_selection_panel.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/section_header.dart';

class ControlPage extends StatelessWidget {
  final List<PluginUi> availablePluginUis;
  final Map<String, Iterable<PluginUi>> availablePluginTemplates;

  const ControlPage({
    Key? key,
    required this.availablePluginUis,
    required this.availablePluginTemplates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pandoraMitm =
        ModalRoute.of(context)!.settings.arguments! as PluginCapablePandoraMitm;

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          animationEnabled: false,
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Scaffold(
        body: MultiSplitView(
          initialAreas: [
            Area(weight: 0.2, minimalWeight: 0.1),
            Area(minimalSize: 512),
          ],
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ControlAppBar(pandoraMitm: pandoraMitm),
                Row(
                  children: [
                    const Expanded(
                      child: SectionHeader(
                        child: Text('Plugins'),
                      ),
                    ),
                    PluginAddPanel(
                      pluginManager: pandoraMitm.pluginManager,
                      availablePluginUis: availablePluginUis,
                      availablePluginTemplates: availablePluginTemplates,
                    ),
                  ],
                ),
                Expanded(
                  child: PluginSelectionPanel(
                    pluginManager: pandoraMitm.pluginManager,
                    availablePluginUis: availablePluginUis,
                  ),
                ),
              ],
            ),
            PluginMainPanel(
              pluginManager: pandoraMitm.pluginManager,
              availablePluginUis: availablePluginUis,
            ),
          ],
        ),
      ),
    );
  }
}
