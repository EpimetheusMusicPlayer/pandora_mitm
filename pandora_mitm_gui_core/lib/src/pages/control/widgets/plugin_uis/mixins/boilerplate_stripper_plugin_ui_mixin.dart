import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

mixin BoilerplateStripperPluginUiMixin<
    T extends pmplg.BoilerplateStripperPlugin> on PluginUi<T> {
  @mustCallSuper
  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    T plugin,
  ) =>
      [
        CheckedPopupMenuItem(
          value: BoilerplateStripperPluginUiContextMenuAction.stripBoilerplate,
          checked: plugin.stripBoilerplate,
          padding: EdgeInsets.zero,
          child: const Text('Strip boilerplate'),
        ),
      ];

  @mustCallSuper
  @override
  bool handleContextMenuSelection(T plugin, Object selection) {
    switch (selection) {
      case BoilerplateStripperPluginUiContextMenuAction.stripBoilerplate:
        plugin.stripBoilerplate = !plugin.stripBoilerplate;
        return true;
      default:
        return false;
    }
  }
}

enum BoilerplateStripperPluginUiContextMenuAction {
  stripBoilerplate,
}
