import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class MitmproxyUiHelperPluginUi
    extends PluginUi<pmplg.MitmproxyUiHelperPlugin> {
  const MitmproxyUiHelperPluginUi();

  @override
  String get displayName => 'mitmproxy UI';

  @override
  String get description => 'Enhances the mitmproxy UI experience.';

  @override
  IconData? get iconData => Icons.web;

  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    pmplg.MitmproxyUiHelperPlugin plugin,
  ) =>
      [
        CheckedPopupMenuItem(
          value: MitmproxyUiHelperPluginUiContextMenuAction.stripBoilerplate,
          checked: plugin.stripBoilerplate,
          padding: EdgeInsets.zero,
          child: const Text('Strip boilerplate'),
        ),
      ];

  @override
  void handleContextMenuSelection(
    pmplg.MitmproxyUiHelperPlugin plugin,
    Object selection,
  ) {
    switch (selection as MitmproxyUiHelperPluginUiContextMenuAction) {
      case MitmproxyUiHelperPluginUiContextMenuAction.stripBoilerplate:
        plugin.stripBoilerplate = !plugin.stripBoilerplate;
        break;
    }
  }

  @override
  pmplg.MitmproxyUiHelperPlugin buildPlugin() =>
      pmplg.MitmproxyUiHelperPlugin(stripBoilerplate: true);
}

enum MitmproxyUiHelperPluginUiContextMenuAction {
  stripBoilerplate,
}
