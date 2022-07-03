import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

mixin BoilerplateStripperPluginUiMixin<T extends PandoraMitmPlugin>
    on PluginUi<T> {
  @protected
  pmplg.BoilerplateStripperPlugin getBoilerplateStripperPlugin(T plugin) {
    assert(
      plugin is pmplg.BoilerplateStripperPlugin,
      'Plugin is not a BoilerplateStripperPlugin - getBoilerplateStripperPlugin must be implemented!',
    );
    return plugin as pmplg.BoilerplateStripperPlugin;
  }

  @mustCallSuper
  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    T plugin,
  ) =>
      [
        CheckedPopupMenuItem(
          value: BoilerplateStripperPluginUiContextMenuAction.stripBoilerplate,
          checked: getBoilerplateStripperPlugin(plugin).stripBoilerplate,
          padding: EdgeInsets.zero,
          child: const Text('Strip boilerplate'),
        ),
      ];

  @mustCallSuper
  @override
  bool handleContextMenuSelection(T plugin, Object selection) {
    switch (selection) {
      case BoilerplateStripperPluginUiContextMenuAction.stripBoilerplate:
        final boilerplateStripperPlugin = getBoilerplateStripperPlugin(plugin);
        boilerplateStripperPlugin.stripBoilerplate =
            !boilerplateStripperPlugin.stripBoilerplate;
        return true;
      default:
        return false;
    }
  }
}

enum BoilerplateStripperPluginUiContextMenuAction {
  stripBoilerplate,
}
