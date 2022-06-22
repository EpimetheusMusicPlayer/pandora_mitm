import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/popup_menu_utils.dart';
import 'package:popup_menu_title/popup_menu_title.dart';

class PluginSelectionPanel extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;

  const PluginSelectionPanel({
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
        return ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) => pluginManager.insertPlugin(
            oldIndex < newIndex ? newIndex - 1 : newIndex,
            pluginManager.removePluginAt(oldIndex),
          ),
          itemCount: plugins.length,
          itemBuilder: (context, index) {
            final plugin = plugins[index];
            final pluginUi = availablePluginUis.forPlugin(plugin);
            return GestureDetector(
              key: ObjectKey(index),
              behavior: HitTestBehavior.deferToChild,
              onSecondaryTapDown: (details) async {
                final pluginItems =
                    pluginUi.buildContextMenuItems(context, plugin);
                final menuResult = await showMenu<Object?>(
                  context: context,
                  position: details.calculateMenuPosition(context),
                  items: [
                    PopupMenuTitle(title: pluginUi.displayName),
                    const PopupMenuItem(
                      value: PluginSelectionPanelContextMenuAction.delete,
                      child: Text('Remove'),
                    ),
                    if (pluginItems.isNotEmpty) const PopupMenuDivider(),
                    ...pluginItems,
                  ],
                );

                if (menuResult == null) return;
                if (menuResult is! PluginSelectionPanelContextMenuAction) {
                  pluginUi.handleContextMenuSelection(plugin, menuResult);
                  return;
                }

                switch (menuResult) {
                  case PluginSelectionPanelContextMenuAction.delete:
                    pluginManager.removePluginAt(index);
                    break;
                }
              },
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {},
                child: ListTile(
                  leading: Icon(pluginUi.iconData),
                  title: Text(pluginUi.displayName),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

enum PluginSelectionPanelContextMenuAction { delete }
