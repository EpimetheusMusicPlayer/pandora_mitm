import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class PluginAddButton extends StatelessWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;
  final Color? color;
  final double? size;
  final bool showTooltip;

  const PluginAddButton({
    Key? key,
    required this.pluginManager,
    required this.availablePluginUis,
    this.color,
    this.size,
    this.showTooltip = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      color: color,
      onPressed: () async {
        final selection = await showDialog<PandoraMitmPlugin>(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Add plugin'),
              children: availablePluginUis
                  .map(
                    (pluginUi) => SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, pluginUi.buildPlugin()),
                      child: ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        contentPadding: EdgeInsets.zero,
                        mouseCursor: MouseCursor.defer,
                        leading: Icon(pluginUi.iconData),
                        title: Text(pluginUi.displayName),
                        subtitle: Text(pluginUi.description),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        );
        if (selection == null) return;
        pluginManager.addPlugin(selection);
      },
      tooltip: showTooltip ? 'Add plugin' : null,
      icon: const Icon(Icons.add),
    );
  }
}
