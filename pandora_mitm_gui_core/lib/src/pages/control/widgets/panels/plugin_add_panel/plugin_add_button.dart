import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/feature_unlock/feature_unlock_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mitmproxy_ui_helper/mitmproxy_ui_helper_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/reauthentication/reauthentication_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_plugin_ui.dart';

class PluginAddButton extends StatelessWidget {
  final PluginManager pluginManager;
  final Color? color;
  final double? size;

  const PluginAddButton({
    Key? key,
    required this.pluginManager,
    this.color,
    this.size,
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
              children: const <PluginUi>[
                RecordPluginUi(),
                FeatureUnlockPluginUi(),
                ReauthenticationPluginUi(),
                MitmproxyUiHelperPluginUi(),
              ]
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
      icon: Icon(Icons.add),
    );
  }
}
