import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/popup_menu_utils.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:popup_menu_title/popup_menu_title.dart';

enum PluginSelectionPanelContextMenuAction { delete }

class PluginSelectionPanel extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;

  const PluginSelectionPanel({
    super.key,
    required this.pluginManager,
    required this.availablePluginUis,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PandoraMitmPlugin>>(
      initialData: pluginManager.plugins,
      stream: pluginManager.pluginListChanges,
      builder: (context, snapshot) {
        final plugins = snapshot.data!;
        return ReorderableListView.builder(
          onReorder: pluginManager.movePlugin,
          itemCount: plugins.length,
          itemBuilder: (context, index) {
            final plugin = plugins[index];
            final pluginUi = availablePluginUis.forPlugin(plugin);
            return PluginSelectionPanelTile(
              key: ObjectKey(index),
              plugin: plugin,
              pluginUi: pluginUi,
            );
          },
        );
      },
    );
  }
}

class PluginSelectionPanelTile extends StatefulWidget {
  final PandoraMitmPlugin plugin;
  final PluginUi pluginUi;

  const PluginSelectionPanelTile({
    super.key,
    required this.plugin,
    required this.pluginUi,
  });

  @override
  State<PluginSelectionPanelTile> createState() =>
      _PluginSelectionPanelTileState();
}

class _PluginSelectionPanelTileState extends State<PluginSelectionPanelTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onSecondaryTapDown: (details) async {
        final pluginItems =
            widget.pluginUi.buildContextMenuItems(context, widget.plugin);
        final menuResult = await showMenu<Object?>(
          context: context,
          position: details.calculateMenuPosition(context),
          items: [
            PopupMenuTitle(title: widget.pluginUi.displayName),
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
          widget.pluginUi.handleContextMenuSelection(widget.plugin, menuResult);
          return;
        }

        switch (menuResult) {
          case PluginSelectionPanelContextMenuAction.delete:
            if (!mounted) return;
            final pandoraMitmBloc = context.read<PandoraMitmBloc>();
            await pandoraMitmBloc.waitUntilPluginListUpdated();
            await widget.pluginUi.disablePlugin(pandoraMitmBloc);
            break;
        }
      },
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {},
        child: ListTile(
          leading: Icon(widget.pluginUi.iconData),
          title: Text(widget.pluginUi.displayName),
        ),
      ),
    );
  }
}
