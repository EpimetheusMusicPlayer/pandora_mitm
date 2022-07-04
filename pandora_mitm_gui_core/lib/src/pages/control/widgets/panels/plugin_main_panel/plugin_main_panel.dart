import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/plugin_add_panel/plugin_add_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
import 'package:pandora_mitm_gui_core/src/widgets/splash_art.dart';

class PluginMainPanel extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;

  const PluginMainPanel({
    Key? key,
    required this.pluginManager,
    required this.availablePluginUis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PandoraMitmPlugin>>(
      initialData: pluginManager.plugins,
      stream: pluginManager.pluginListChanges,
      builder: (context, snapshot) {
        final plugins = snapshot.data!;
        final pluginUiMap = <PandoraMitmPlugin, PluginUi>{};
        for (final plugin in plugins) {
          final pluginUi = availablePluginUis.forPlugin(plugin);
          if (pluginUi.hasMainPanel) {
            pluginUiMap[plugin] = pluginUi;
          }
        }

        if (pluginUiMap.isEmpty) {
          return Center(
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SplashArt(),
                  const VerticalDivider(width: 56, indent: 12, endIndent: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PluginAddButton(
                        pluginManager: pluginManager,
                        availablePluginUis: availablePluginUis,
                        size: 72,
                        // Match the color with SplashArt
                        color: Theme.of(context).textTheme.displaySmall!.color,
                        showTooltip: false,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add an interactive plugin\nto populate this space',
                        // Match the style with SplashArt
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return ThemedTabbedSection(
          tabBar: ThemedTabBar(
            tabs: pluginUiMap.values
                .map(
                  (pluginUi) => ThemedTabEntry(
                    pluginUi.displayName,
                    pluginUi.iconData,
                  ),
                )
                .toList(growable: false),
          ),
          children: pluginUiMap.entries
              .map(
                (entry) => entry.value.buildMainPanel(context, entry.key),
              )
              .toList(growable: false),
        );
      },
    );
  }
}
